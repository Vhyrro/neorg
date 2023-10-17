local neorg = require("neorg.core")
local module = neorg.modules.create("core.latex.renderer")
local modules = neorg.modules

module.setup = function()
    return {
        requires = {
            "core.integrations.treesitter",
            "core.autocommands",
            "core.neorgcmd",
        },
    }
end

module.load = function()
    module.required["core.autocommands"].enable_autocommand("BufWinEnter")
    module.required["core.autocommands"].enable_autocommand("TextChanged")
    module.required["core.autocommands"].enable_autocommand("TextChangedI")
    module.required["core.autocommands"].enable_autocommand("TextChangedP")
    module.required["core.autocommands"].enable_autocommand("TextChangedT")

    modules.await("core.neorgcmd", function(neorgcmd)
        neorgcmd.add_commands_from_table({
            ["render-latex"] = {
                name = "core.latex.renderer.render",
                args = 0,
                condition = "norg",
            },
        })
    end)
end

module.public = {
    latex_renderer = function()
        local renderer = neorg.modules.get_module(module.config.public.renderer)

        if not renderer then
            return
        end

        renderer.clear()

        module.required["core.integrations.treesitter"].execute_query(
            [[
                (
                    (inline_math) @latex
                    (#offset! @latex 0 1 0 -1)
                )

                ; NOTE: We don't look for `@code` blocks here because those should be just that - code blocks, not rendered latex markup.
                (ranged_verbatim_tag (tag_name) @_tagname (tag_parameters .(tag_param) @_language) (ranged_verbatim_tag_content) @latex (#eq? @_tagname "embed") (#eq? @_language "latex"))
                (ranged_verbatim_tag (tag_name) @_tagname (tag_parameters)? (ranged_verbatim_tag_content) @latex (#eq? @_tagname "math"))
            ]],
            function(query, id, node)
                if query.captures[id] ~= "latex" then
                    return
                end

                local latex_snippet =
                    module.required["core.integrations.treesitter"].get_node_text(node, vim.api.nvim_get_current_buf())

                local png_location = module.public.parse_latex(latex_snippet)

                renderer.render(
                    vim.api.nvim_get_current_buf(),
                    png_location,
                    module.required["core.integrations.treesitter"].get_node_range(node),
                    vim.api.nvim_get_current_win(),
                    module.config.public.scale
                )
            end
        )
    end,
    latex_clearer = function()
        local clearer = neorg.modules.get_module(module.config.public.renderer)

        if not clearer then
            return
        end

        clearer.clear()
    end,
    create_latex_document = function(snippet)
        local tempname = vim.fn.tempname()

        local tempfile = io.open(tempname, "w")

        if not tempfile then
            return
        end

        local content = table.concat({
            "\\documentclass[6pt]{standalone}",
            "\\usepackage{amsmath}",
            "\\usepackage{amssymb}",
            "\\usepackage{graphicx}",
            "\\begin{document}",
            snippet,
            "\\end{document}",
        }, "\n")

        tempfile:write(content)
        tempfile:close()

        return tempname
    end,

    -- Returns a handle to an image containing
    -- the rendered snippet.
    -- This handle can then be delegated to an external renderer.
    parse_latex = function(snippet)
        local document_name = module.public.create_latex_document(snippet)

        if not document_name then
            return
        end

        local cwd = vim.fn.fnamemodify(document_name, ":h")
        vim.fn.jobwait({
            vim.fn.jobstart(
                "latex  --interaction=nonstopmode --output-dir=" .. cwd .. " --output-format=dvi " .. document_name,
                { cwd = cwd }
            ),
        })

        local png_result = vim.fn.tempname()
        -- TODO: Make the conversions async via `on_exit`
        vim.fn.jobwait({
            vim.fn.jobstart(
                "dvipng -D "
                    .. tostring(module.config.public.dpi)
                    .. " -T tight -bg Transparent -fg 'cmyk 0.00 0.04 0.21 0.02' -o "
                    .. png_result
                    .. " "
                    .. document_name
                    .. ".dvi",
                { cwd = vim.fn.fnamemodify(document_name, ":h") }
            ),
        })

        return png_result
    end,
}

module.config.public = {
    -- TODO: Documentation
    renderer = "core.integrations.image",
    dpi = 350,
    scale = 1,
}

local function render_latex()
    neorg.modules.get_module("core.latex.renderer").latex_renderer()
end

local function clear_latex()
    neorg.modules.get_module("core.latex.renderer").latex_clearer()
end

local event_handlers = {
    ["core.neorgcmd.events.core.latex.renderer.render"] = render_latex,
    ["core.autocommands.events.bufwinenter"] = render_latex,
    ["core.autocommands.events.textchanged"] = clear_latex,
    ["core.autocommands.events.textchangedi"] = clear_latex,
    ["core.autocommands.events.textchangedp"] = clear_latex,
    ["core.autocommands.events.textchangedt"] = clear_latex,
}

module.on_event = function(event)
    if event.referrer == "core.autocommands" and vim.bo[event.buffer].ft ~= "norg" then
        return
    end

    return event_handlers[event.type](event)
end

module.events.subscribed = {
    ["core.autocommands"] = {
        bufwinenter = true,
        textchanged = true,
        textchangedi = true,
        textchangedp = true,
        textchangedt = true,
    },
    ["core.neorgcmd"] = {
        ["core.latex.renderer.render"] = true,
    },
}
return module
