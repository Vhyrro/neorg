--[[
    file: Math-Renderer
    title: Conceal Math ranges with their rendered versions
    summary: An experimental module for rendering inline math blocks
    ---

> [!WARNING]
> This is an experimental module. It's also a module that can potentially render a large number of
> images to your terminal. Terminal images, are inherently pretty slow, so be careful activating this
> plugin in files that contains excessive amounts of inline math blocks.

It renders math snippets as images making use of the image.nvim
plugin. By default, images are only rendered after running the command: `:Neorg render-math`.

Requires:
- [image.nvim](https://github.com/3rd/image.nvim)

## Commands
- `:Neorg render-math enable`
- `:Neorg render-math disable`
- `:Neorg render-math toggle`

## Highlights
- `@neorg.rendered.math` - highlight group that controls the foreground color of the rendered math
    - Configurable in `core.highlights`
    - Links to `:h hi-Normal` by default
--]]
local nio
local neorg = require("neorg.core")
local module = neorg.modules.create("core.math.renderer")
local modules = neorg.modules

assert(vim.re ~= nil, "Neovim 0.10.0+ is required to run the `core.math.renderer` module!")

module.setup = function()
    return {
        requires = {
            "core.integrations.image",
            "core.integrations.treesitter",
            "core.autocommands",
            "core.neorgcmd",
            "core.highlights",
        },
    }
end

module.config.public = {
    -- When true, images of rendered LaTeX will cover the source LaTeX they were produced from.
    -- Setting this value to false creates more lag, and can be buggy with large numbers of images.
    conceal = true,

    -- When true, images will render when a `.norg` buffer is entered
    render_on_enter = false,

    -- Module that renders the images. "core.integrations.image" makes use of image.nvim and is
    -- currently the only option
    image_renderer = "core.integrations.image",

    -- The module which provides a function which takes a cleaned math string and creates a temp
    -- file containing the rendered image data, and returns that data.
    --
    -- There is currently one option: "core.math.renderer.latex"
    image_generator = "core.math.renderer.latex",

    -- Don't re-render anything until 200ms after the buffer has stopped changing. Lowering will
    -- lead to a more seamless experience but will cause more temporary images to be created
    debounce_ms = 200,

    -- Only render math snippets that are longer than this many chars. Escaped chars are removed
    -- spaces are counted, `$` and `$|`/`|$` are not (ie. `$\\int$` counts as 4 chars)
    min_length = 3,

    -- Make the images larger or smaller by adjusting the scale. Will not pad images with virtual
    -- text when `conceal = true`, so they can overlap text. Images will not be blown up larger than
    -- their true size, so images may still render one line tall.
    scale = 1,
}

---@class Image
---@field path string
-- and many other fields that I don't necessarily need

---@class MathRange
---@field image Image our limited representation of an image
---@field range Range4 last range of the math block. Updated based on the extmark
---@field snippet string cleaned math snippet
---@field extmark_id number? when rendered, the extmark_id that belongs to this image
---@field real boolean tag ranges that are confirmed to still exist by TS

---Compute the foreground color
---@return { r: number, g: number, b: number } #each value is a number between 0 and 1
local function compute_foreground()
    local neorg_hi = neorg.modules.get_module("core.highlights")
    assert(neorg_hi, "Failed to load core.highlights")
    local hi = vim.api.nvim_get_hl(0, { name = "@neorg.rendered.math", link = false })
    if not vim.tbl_isempty(hi) then
        local r, g, b = neorg_hi.hex_to_rgb(("%06x"):format(hi.fg))
        return { r = r / 255, g = g / 255, b = b / 255 }
    end

    return { r = 0.5, g = 0.5, b = 0.5 } -- grey
end

---@class MathImageGenerator
---@field async_generate_image function ()

module.load = function()
    local success, image_api = pcall(neorg.modules.get_module, module.config.public.image_renderer)
    assert(success, "Unable to load image_renderer module")
    local ok = neorg.modules.load_module(module.config.public.image_generator)
    assert(ok, "Unable to load image_generator module")
    local math_image_generator = neorg.modules.get_module(module.config.public.image_generator)

    nio = require("nio")

    -- compute the foreground color in rgb
    module.private.foreground = compute_foreground()

    ---@type string[] ids
    module.private.cleared_at_cursor = {}

    ---Image cache. math snippet to file path
    ---@type table<string, string>
    module.private.image_paths = {}

    ---@type table<number, table<string, MathRange>>
    module.private.math_images = {}

    module.private.image_api = image_api
    module.private.math_image_generator = math_image_generator
    module.private.extmark_ns = vim.api.nvim_create_namespace("neorg-math-concealer")

    module.private.do_render = module.config.public.render_on_enter

    module.required["core.autocommands"].enable_autocommand("BufWinEnter")
    module.required["core.autocommands"].enable_autocommand("CursorMoved")
    module.required["core.autocommands"].enable_autocommand("TextChanged")
    module.required["core.autocommands"].enable_autocommand("TextChangedI")

    modules.await("core.neorgcmd", function(neorgcmd)
        neorgcmd.add_commands_from_table({
            ["render-math"] = {
                name = "math.render.render",
                min_args = 0,
                max_args = 1,
                subcommands = {
                    enable = {
                        args = 0,
                        name = "math.render.enable",
                    },
                    disable = {
                        args = 0,
                        name = "math.render.disable",
                    },
                    toggle = {
                        args = 0,
                        name = "math.render.toggle",
                    },
                },
                condition = "norg",
            },
        })
    end)
end

---Get the key for a given range
---@param range Range4
module.private.get_key = function(range)
    return ("%d:%d"):format(range[1], range[2])
end

module.public = {
    ---@async
    ---@param buf number
    async_math_renderer = function(buf)
        -- Update all the limage keys to their new extmark locations
        ---@type table<string, MathRange>
        local new_limages = {}
        for _, limage in pairs(module.private.math_images[buf] or {}) do
            if limage.extmark_id then
                local extmark =
                    nio.api.nvim_buf_get_extmark_by_id(buf, module.private.extmark_ns, limage.extmark_id, {})
                local new_key = module.private.get_key({ extmark[1], extmark[2] })
                limage.real = false
                new_limages[new_key] = limage
            end
        end
        module.private.cleared_at_cursor = {}
        module.required["core.integrations.treesitter"].execute_query(
            [[
                (
                    (inline_math) @math
                    (#offset! @math 0 1 0 -1)
                )
            ]],
            function(query, id, node)
                if query.captures[id] ~= "math" then
                    return
                end

                local original_snippet =
                    module.required["core.integrations.treesitter"].get_node_text(node, nio.api.nvim_get_current_buf())
                local clean_snippet = string.gsub(original_snippet, "^%$|", "$")
                clean_snippet = string.gsub(clean_snippet, "|%$$", "$")
                if clean_snippet == original_snippet then
                    -- this is a normal math block, we need to remove leading `\` chars
                    -- TODO: test that this regex is actually correct
                    clean_snippet = string.gsub(clean_snippet, "\\(.)", "%1")
                end
                -- `- 2` for the two `$`s
                if string.len(clean_snippet) - 2 < module.config.public.min_length then
                    return
                end

                local png_location = module.private.image_paths[clean_snippet]
                    or module.private.math_image_generator.async_generate_image(
                        clean_snippet,
                        module.private.foreground
                    )
                if not png_location then
                    return
                end
                module.private.image_paths[clean_snippet] = png_location
                local range = { node:range() }
                local key = module.private.get_key(range)

                -- If there's already an image at this location and it's the same snippet, don't do
                -- anything
                if new_limages[key] then
                    if new_limages[key].snippet == clean_snippet then
                        new_limages[key].range = range
                        new_limages[key].real = true
                        return
                    end
                end

                local img = module.private.image_api.new_image(
                    buf,
                    png_location,
                    module.required["core.integrations.treesitter"].get_node_range(node),
                    nio.api.nvim_get_current_win(),
                    module.config.public.scale,
                    not module.config.public.conceal
                )
                local existing_ext_id = new_limages[key] and new_limages[key].extmark_id
                new_limages[key] = {
                    image = img,
                    range = range,
                    snippet = clean_snippet,
                    real = true,
                    extmark_id = existing_ext_id,
                }
            end,
            buf
        )

        nio.scheduler()

        for key, limage in pairs(new_limages) do
            if not limage.real then
                module.private.image_api.clear({ [key] = limage })
                if limage.extmark_id then
                    nio.api.nvim_buf_del_extmark(0, module.private.extmark_ns, limage.extmark_id)
                end
                new_limages[key] = nil
            end
        end
        module.private.math_images[buf] = new_limages
    end,

    ---Actually renders the images (along with any extmarks it needs)
    ---@param images table<string, MathRange>
    render_inline_math = function(images, buffer)
        local conceallevel = vim.api.nvim_get_option_value("conceallevel", { win = 0 })
        local concealcursor = vim.api.nvim_get_option_value("concealcursor", { win = 0 })
        local mode = vim.api.nvim_get_mode().mode
        -- account for concealcursor, ie. don't un-render images when conceal cursor contains "n" unless
        -- we're in insert mode.
        local cc_n = concealcursor:match("n") and mode == "n"
        local cursor_row = vim.api.nvim_win_get_cursor(0)[1]
        local conceal_on = conceallevel >= 2 and module.config.public.conceal
        -- Create all extmarks before rendering images b/c these extmarks will change the
        -- position of the images
        for _, limage in pairs(images) do
            local range = limage.range

            local ext_opts = {
                end_col = range[4],
                strict = false,
                invalidate = true,
                undo_restore = false,
                id = limage.extmark_id, -- if it exists, update it, else this is nil so it will create a new one
            }

            if module.config.public.conceal then
                local image = limage.image
                local predicted_image_dimensions =
                    module.private.image_api.image_size(image, { height = module.config.public.scale })
                if range[1] ~= cursor_row - 1 or cc_n then
                    ext_opts.virt_text = { { (" "):rep(predicted_image_dimensions.width) } }
                    ext_opts.virt_text_pos = "inline"
                end
            end

            if conceal_on and (range[1] ~= cursor_row - 1 or cc_n) then
                ext_opts.conceal = ""
            end

            limage.extmark_id =
                vim.api.nvim_buf_set_extmark(buffer, module.private.extmark_ns, range[1], range[2], ext_opts)
        end

        for key, limage in pairs(images) do
            local range = limage.range
            if conceal_on and (range[1] == cursor_row - 1 and not cc_n) then
                table.insert(module.private.cleared_at_cursor, key)
                module.private.image_api.clear({ limage })
                if limage.extmark_id then
                    vim.api.nvim_buf_set_extmark(buffer, module.private.extmark_ns, range[1], range[2], {
                        virt_text = { { "" } },
                    })
                end
                goto continue
            end
            module.private.image_api.render({ limage })
            ::continue::
        end
    end,
}

local running_proc = {}
local render_timer = {}
local function render_math()
    local buf = vim.api.nvim_get_current_buf()
    if not module.private.do_render then
        if render_timer[buf] then
            render_timer[buf]:stop()
            render_timer[buf]:close()
            render_timer[buf] = nil
        end
        return
    end

    if not render_timer[buf] then
        render_timer[buf] = vim.uv.new_timer()
    end

    render_timer[buf]:start(module.config.public.debounce_ms, 0, function()
        render_timer[buf]:stop()
        render_timer[buf]:close()
        render_timer[buf] = nil

        if not running_proc[buf] then
            running_proc[buf] = nio.run(function()
                nio.scheduler()
                module.public.async_math_renderer(buf)
            end, function()
                module.public.render_inline_math(module.private.math_images[buf] or {}, buf)
                running_proc[buf] = nil
            end)
        end
    end)
end

local function clear_at_cursor()
    local buf = vim.api.nvim_get_current_buf()
    if not module.private.do_render or render_timer[buf] then
        return
    end

    local concealcursor = vim.api.nvim_get_option_value("concealcursor", { win = 0 })
    local mode = vim.api.nvim_get_mode().mode
    -- account for concealcursor, ie. don't un-render images when conceal cursor contains "n" unless
    -- we're in insert mode.
    local cc_and_insert = (concealcursor:match("n") and mode == "i") or not concealcursor:match("n")

    if module.config.public.conceal and cc_and_insert and module.private.math_images[buf] ~= nil then
        local cleared = module.private.image_api.clear_at_cursor(
            module.private.math_images[buf],
            vim.api.nvim_win_get_cursor(0)[1] - 1
        )
        for _, id in ipairs(cleared) do
            local limage = module.private.math_images[buf][id]
            if limage.extmark_id then
                vim.api.nvim_buf_set_extmark(0, module.private.extmark_ns, limage.range[1], limage.range[2], {
                    id = limage.extmark_id,
                    end_col = limage.range[4],
                    conceal = "",
                    virt_text = { { "", "" } },
                    strict = false,
                })
            end
        end
        local to_render = {}
        for _, key in ipairs(module.private.cleared_at_cursor) do
            if not vim.tbl_contains(cleared, key) then
                -- this image was cleared b/c it was at our cursor, and now it should be rendered again
                to_render[key] = module.private.math_images[buf][key]
            end
        end

        local updated_positions = {}
        for _, limage in pairs(to_render) do
            if limage.extmark_id then
                local extmark = vim.api.nvim_buf_get_extmark_by_id(
                    buf,
                    module.private.extmark_ns,
                    limage.extmark_id,
                    { details = true }
                )
                local range = { extmark[1], extmark[2], extmark[3].end_row, extmark[3].end_col }
                local new_key = module.private.get_key(range)
                updated_positions[new_key] = limage
                updated_positions[new_key].range = range
            end
        end
        module.public.render_inline_math(updated_positions, buf)
        module.private.cleared_at_cursor = cleared
    end
end

local function enable_rendering()
    module.private.do_render = true
    render_math()
end

local function disable_rendering()
    module.private.do_render = false
    for buf, images in pairs(module.private.math_images) do
        module.private.image_api.clear(images)
        vim.api.nvim_buf_clear_namespace(buf, module.private.extmark_ns, 0, -1)
    end
    module.private.math_images = {}
end

local function toggle_rendering()
    if module.private.do_render then
        disable_rendering()
    else
        enable_rendering()
    end
end

local function show_hidden()
    local buf = vim.api.nvim_get_current_buf()
    if not module.private.do_render then
        return
    end

    module.private.image_api.render(module.private.math_images[buf] or {})
end

local function colorscheme_change()
    module.private.image_paths = {}
    if module.private.do_render then
        disable_rendering()
        module.private.math_images = {}
        vim.schedule(function()
            module.private.foreground = compute_foreground()
            enable_rendering()
        end)
    else
        vim.schedule(function()
            module.private.foreground = compute_foreground()
        end)
    end
end

local event_handlers = {
    ["core.neorgcmd.events.math.render.render"] = enable_rendering,
    ["core.neorgcmd.events.math.render.enable"] = enable_rendering,
    ["core.neorgcmd.events.math.render.disable"] = disable_rendering,
    ["core.neorgcmd.events.math.render.toggle"] = toggle_rendering,
    ["core.autocommands.events.bufreadpost"] = render_math,
    ["core.autocommands.events.bufwinenter"] = show_hidden,
    ["core.autocommands.events.cursormoved"] = clear_at_cursor,
    ["core.autocommands.events.textchanged"] = render_math,
    ["core.autocommands.events.insertleave"] = render_math,
    ["core.autocommands.events.insertenter"] = vim.schedule_wrap(clear_at_cursor),
    ["core.autocommands.events.colorscheme"] = colorscheme_change,
}

module.on_event = function(event)
    if event.referrer == "core.autocommands" and vim.bo[event.buffer].ft ~= "norg" then
        return
    end

    return event_handlers[event.type]()
end

module.events.subscribed = {
    ["core.autocommands"] = {
        bufreadpost = module.config.public.render_on_enter,
        bufwinenter = true,
        cursormoved = true,
        textchanged = true,
        -- textchangedi = true,
        insertleave = true,
        insertenter = true,
        colorscheme = true,
    },
    ["core.neorgcmd"] = {
        ["math.render.render"] = true,
        ["math.render.enable"] = true,
        ["math.render.disable"] = true,
        ["math.render.toggle"] = true,
    },
}
return module
