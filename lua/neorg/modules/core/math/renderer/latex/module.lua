--[[
    file: Math-Renderer-LaTeX
    title: Convert LaTeX snippets into image files
    summary: A module that provides images of LaTeX for `core.math.renderer`
    ---

The module is used by `core.math.renderer` to render math blocks as LaTeX.

Requires:
- `latex` executable in path with the following packages:
    - standalone
    - amsmath
    - amssymb
    - graphicx
- `dvipng` executable in path (normally comes with LaTeX)

A highlight group that controls the foreground color of the rendered math: `@neorg.rendered.math`,
configurable in `core.highlights`. It links to `Normal` by default

Note, when `'concealcursor'` contains `"n"` This plugin will fail for the time being.
--]]
local nio
local neorg = require("neorg.core")
local module = neorg.modules.create("core.math.renderer.latex")

module.load = function()
    nio = require("nio")
end

module.config.public = {
    -- "Dots Per Inch" increasing this value will result in crisper images at the expense of
    -- performance
    dpi = 350,
}

module.private = {}

---@type MathImageGenerator
module.public = {
    ---Returns a filepath where the rendered image sits
    ---@async
    ---@param snippet string the full latex snippet to convert to an image
    ---@param foreground_color { r: number, g: number, b: number }
    ---@return string | nil
    async_generate_image = function(snippet, foreground_color)
        local document_name = module.private.async_create_latex_document(snippet)

        if not document_name then
            return
        end

        local cwd = nio.fn.fnamemodify(document_name, ":h")
        local create_dvi = nio.process.run({
            cmd = "latex",
            args = {
                "--interaction=nonstopmode",
                "--output-format=dvi",
                document_name,
            },
            cwd = cwd,
        })
        if not create_dvi or type(create_dvi) == "string" then
            return
        end
        local res = create_dvi.result()
        if res ~= 0 then
            return
        end

        local png_result = nio.fn.tempname()
        png_result = ("%s.png"):format(png_result)

        local fg = module.private.format_color(foreground_color)
        local dvipng = nio.process.run({
            cmd = "dvipng",
            args = {
                "-D",
                module.config.public.dpi,
                "-T",
                "tight",
                "-bg",
                "Transparent",
                "-fg",
                fg,
                "-o",
                png_result,
                document_name .. ".dvi",
            },
        })

        if not dvipng or type(dvipng) == "string" then
            return
        end
        res = dvipng.result()
        if res ~= 0 then
            return
        end

        return png_result
    end,
}

---Writes a latex snippet to a file and wraps it with latex headers so it will render nicely
---@async
---@param snippet string latex snippet (if it's math it should include the surrounding $$)
---@return string temp file path
module.private.async_create_latex_document = function(snippet)
    local tempname = nio.fn.tempname()
    local tempfile = nio.file.open(tempname, "w")

    local content = table.concat({
        "\\documentclass[6pt]{standalone}",
        "\\usepackage{amsmath}",
        "\\usepackage{amssymb}",
        "\\usepackage{graphicx}",
        "\\begin{document}",
        snippet,
        "\\end{document}",
    }, "\n")

    tempfile.write(content)
    tempfile.close()

    return tempname
end

---Format the foreground color information into something that can be passed to the dvipng command
---@param foreground_color {r: number, g: number, b: number}
module.private.format_color = function(foreground_color)
    return ("rgb %s %s %s"):format(foreground_color.r, foreground_color.g, foreground_color.b)
end

return module
