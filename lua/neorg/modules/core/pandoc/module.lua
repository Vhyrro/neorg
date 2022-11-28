require("neorg.modules.base")

local module = neorg.modules.create("pandoc")
local log = require("neorg.external.log")

module.setup = function()
    return {
        success = true,
        requires = {
            "core.integrations.treesitter",
        },
    }
end

module.load = function()
    neorg.modules.await("core.neorgcmd", function(neorgcmd)
        neorgcmd.add_commands_from_table({
            pandoc = {
                args = 1,
                condition = "norg",

                subcommands = {
                    export = {
                        min_args = 1,
                        name = "pandoc.export",
                        complete = {
                            module.config.public.formats,
                        },
                    },
                    list = {
                        args = 0,
                        name = "pandoc.list",
                    },
                    json = {
                        args = 0,
                        name = "pandoc.json",
                    },
                },
            },
        })
    end)
end

module.public = {
    ---Run a pandoc command using installed pandoc binary and return its result. Returns nil if arguments are empty or pandoc command failed.
    ---@param cmd string All desired arguments passed to pandoc
    ---@return string|nil stdout Command output
    pandoc_cmd = function(cmd)
        if not cmd then
            return nil
        end

        local res = io.popen("pandoc " .. cmd)

        if not res then
            log.error("Error running pandoc")
            return nil
        end

        return res:read("*a")
    end,

    ---Get a list of supported output formats from installed pandoc binary. Returns nil if pandoc command failed.
    ---@return string[]|nil formats
    get_output_formats = function()
        local output = module.public.pandoc_cmd("--list-output-formats")

        if not output then
            return nil
        end

        local formats = {}
        for s in output:gmatch("[^\r\n]+") do
            table.insert(formats, s)
        end
        return formats
    end,

    convert = function(buffer)
        local tree = vim.treesitter.get_parser(buffer, "norg"):parse()[1]
        local ts = module.required["core.integrations.treesitter"]

        local function inlines(node)
            local final = {}

            local inline_table = {
                ["_word"] = function(n)
                    return { t = "Str", c = ts.get_node_text(n) }
                end,
                ["bold"] = function(n)
                    return { t = "Strong", c = inlines(n) }
                end,
                ["italic"] = function(n)
                    return { t = "Emph", c = inlines(n) }
                end,
            }

            for n in node:iter_children() do
                local func = inline_table[n:type()]
                    or function(_)
                        log.error(n:type())
                        return nil
                    end
                table.insert(final, func(n))
            end

            return final
        end

        ---@param level number
        local function heading(node, level)
            return function()
                return {
                    {
                        t = "Header",
                        c = {
                            level,
                            { "", {}, {} },
                            inlines(node:named_child(1)),
                        },
                    },
                }
            end
        end

        ---

        local final = {}

        local function match_func(node)
            local output = neorg.lib.match(node:type())({
                ["heading1"] = heading(node, 1),
                ["heading2"] = heading(node, 2),
                ["heading3"] = heading(node, 3),
                ["heading4"] = heading(node, 4),
                ["heading5"] = heading(node, 5),
                ["heading6"] = heading(node, 6),
            })

            if output and output[1] then
                table.insert(final, output[1])
                return output[2]
            end
        end

        ts.tree_map_rec(match_func, tree)

        local norg_meta = ts.get_document_metadata(buffer)
        local meta = {}

        for key, value in pairs(norg_meta) do
            meta[key] = {
                t = "MetaInlines",
                c = { { t = "Str", c = value } },
            }
        end

        return {
            ["pandoc-api-version"] = { 1, 22, 2, 1 },
            meta = meta,
            blocks = final,
        }
    end,
}

module.config.public = {
    formats = module.public.get_output_formats(),
}

module.on_event = function(event)
    neorg.lib.match(event.type)({
        ["core.neorgcmd.events.pandoc.export"] = function()
            vim.notify(vim.inspect(module.public.convert(event.buffer)))
        end,
        ["core.neorgcmd.events.pandoc.list"] = function()
            vim.notify(table.concat(module.config.public.formats, "\n"))
        end,
        ["core.neorgcmd.events.pandoc.json"] = function()
            local file = io.open("json.json", "w")
            if not file then
                log.error("Failed to write file")
            else
                file:write(vim.json.encode(module.public.convert(event.buffer)))
                file:close()
            end
        end,
    })
end

module.events.subscribed = {
    ["core.neorgcmd"] = {
        ["pandoc.export"] = true,
        ["pandoc.list"] = true,
        ["pandoc.json"] = true,
    },
}

return module
