--[[
    File: Concealer
    Title: Concealer Module for Neorg
    Summary: Enhances the basic Neorg experience by using icons instead of text.
    ---
This module handles the iconification and concealing of several different
syntax elements in your document.

It's also directly responsible for displaying completion levels
in situations like this:
```norg
* Do Some Things
- [ ] Thing A
- [ ] Thing B
```

Where it will display this instead:
```norg
* Do Some Things (0 of 2) [0% complete]
- [ ] Thing A
- [ ] Thing B
```

--[[
Once anticonceal (https://github.com/neovim/neovim/pull/9496) is
a thing, punctuation can be added (without removing the whitespace
between the icon and actual text) like so:

```lua
icon = module.private.ordered_concealing.punctuation.dot(
module.private.ordered_concealing.icon_renderer.numeric
),
```

Note: this will produce icons like `1.`, `2.`, etc.

You can even chain multiple punctuation wrappers like so:

```lua
icon = module.private.ordered_concealing.punctuation.parenthesis(
module.private.ordered_concealing.punctuation.dot(
module.private.ordered_concealing.icon_renderer.numeric
)
),
```

Note: this will produce icons like `1.)`, `2.)`, etc.
--]]

require("neorg.modules.base")

local module = neorg.modules.create("core.norg.concealer")

module.setup = function()
    return {
        success = true,
        requires = {
            "core.autocommands",
            "core.keybinds",
            "core.integrations.treesitter",
        },
        imports = {
            "preset_basic",
            "preset_varied",
            "preset_diamond",
            "preset_safe",
            "preset_brave",
            "preset_dimmed",
        },
    }
end

module.private = {
    icon_namespace = vim.api.nvim_create_namespace("neorg-conceals"),
    markup_namespace = vim.api.nvim_create_namespace("neorg-markup"),
    code_block_namespace = vim.api.nvim_create_namespace("neorg-code-blocks"),
    completion_level_namespace = vim.api.nvim_create_namespace("neorg-completion-level"),
    icons = {},
    markup = {},

    largest_change_start = -1,
    largest_change_end = -1,

    last_change = {
        active = false,
        line = 0,
    },
}

---@class core.norg.concealer
module.public = {

    -- @Summary Activates icons for the current window
    -- @Description Parses the user configuration and enables concealing for the current window.
    -- @Param icon_set (table) - the icon set to trigger
    -- @Param namespace
    -- @Param from (number) - the line number that we should start at (defaults to 0)
    trigger_icons = function(buf, icon_set, namespace, from, to)
        -- Clear all the conceals beforehand (so no overlaps occur)
        module.public.clear_icons(buf, namespace, from, to)

        -- Get the root node of the document (required to iterate over query captures)
        local document_root = module.required["core.integrations.treesitter"].get_document_root(buf)

        -- Loop through all icons that the user has enabled
        for _, icon_data in ipairs(icon_set) do
            vim.schedule(function()
                if icon_data.query then
                    -- Attempt to parse the query provided by `icon_data.query`
                    -- A query must have at least one capture, e.g. "(test_node) @icon"
                    local query = vim.treesitter.parse_query("norg", icon_data.query)

                    local ok_ts_query, nvim_ts_query = pcall(require, "nvim-treesitter.query")
                    local ok_ts_locals, nvim_locals = pcall(require, "nvim-treesitter.locals")

                    if not ok_ts_query or not ok_ts_locals then
                        log.error("Unable to trigger icons - nvim-treesitter is not loaded.")
                        return
                    end

                    -- Go through every found node and try to apply an icon to it
                    for match in nvim_ts_query.iter_prepared_matches(query, document_root, buf, from or 0, to or -1) do
                        nvim_locals.recurse_local_nodes(match, function(_, node, capture)
                            if capture == "icon" then
                                -- Extract both the text and the range of the node
                                local text = module.required["core.integrations.treesitter"].get_node_text(node, buf)
                                local range = module.required["core.integrations.treesitter"].get_node_range(node)

                                -- Set the offset to 0 here. The offset is a special value that, well, offsets
                                -- the location of the icon column-wise
                                -- It's used in scenarios where the node spans more than what we want to iconify.
                                -- A prime example of this is the todo item, whose content looks like this: "[x]".
                                -- We obviously don't want to iconify the entire thing, this is why we will tell Neorg
                                -- to use an offset of 1 to start the icon at the "x"
                                local offset = 0

                                -- The extract function is used exactly to calculate this offset
                                -- If that function is present then run it and grab the return value
                                if icon_data.extract then
                                    offset = icon_data.extract(text, node) or 0
                                end

                                -- Every icon can also implement a custom "render" function that can allow for things like multicoloured icons
                                -- This is primarily used in nested quotes
                                -- The "render" function must return a table of this structure: { { "text", "highlightgroup1" }, { "optionally more text", "higlightgroup2" } }
                                if not icon_data.render then
                                    module.public._set_extmark(
                                        buf,
                                        icon_data.icon,
                                        icon_data.highlight,
                                        namespace,
                                        range.row_start,
                                        range.row_end,
                                        range.column_start + offset,
                                        range.column_end,
                                        false,
                                        "combine"
                                    )
                                else
                                    module.public._set_extmark(
                                        buf,
                                        icon_data:render(text, node),
                                        icon_data.highlight,
                                        namespace,
                                        range.row_start,
                                        range.row_end,
                                        range.column_start + offset,
                                        range.column_end,
                                        false,
                                        "combine"
                                    )
                                end
                            end
                        end)
                    end
                end
            end)
        end
    end,

    trigger_highlight_regex_code_block = function(buf, from, to)
        -- The next block of code will be responsible for dimming code blocks accordingly
        local tree = vim.treesitter.get_parser(buf, "norg"):parse()[1]

        -- If the tree is valid then attempt to perform the query
        if tree then
            -- Query all code blocks
            local ok, query = pcall(
                vim.treesitter.parse_query,
                "norg",
                [[(
                    (ranged_tag (tag_name) @_name) @tag
                    (#eq? @_name "code")
                )]]
            )

            -- If something went wrong then go bye bye
            if not ok or not query then
                return
            end

            -- get the language used by the code block
            local code_lang = vim.treesitter.parse_query(
                "norg",
                [[(
                    (ranged_tag (tag_name) @_tagname (tag_parameters) @language)
                    (#eq? @_tagname "code")
                )]]
            )

            -- look for language name in code blocks
            -- this will not finish if a treesitter parser exists for the current language found
            for id, node in code_lang:iter_captures(tree:root(), buf, from or 0, to or -1) do
                vim.schedule(function()
                    local lang_name = code_lang.captures[id]

                    -- only look at nodes that have the language query
                    if lang_name == "language" then
                        local regex_language = vim.treesitter.get_node_text(node, buf)

                        if not regex_language then
                            goto continue
                        end

                        local result

                        -- see if parser exists
                        ok, result = pcall(vim.treesitter.require_language, regex_language, true)

                        -- if pcall was true we had parser, skip the rest
                        if ok and result then
                            goto continue
                        end

                        -- NOTE: the regex fallback code was mostly adapted from Vimwiki
                        -- It's a very good implementation of nested vim regex
                        regex_language = regex_language:gsub("%s+", "") -- need to trim out whitespace
                        local group = "textGroup" .. string.upper(regex_language)
                        local snip = "textSnip" .. string.upper(regex_language)
                        local start_marker = "@code " .. regex_language
                        local end_marker = "@end"
                        local has_syntax = "syntax list " .. snip

                        ok, result = pcall(vim.api.nvim_exec, has_syntax, true)
                        local count = select(2, result:gsub("\n", "\n")) -- get length of result from syn list

                        if ok == true and count > 0 then
                            goto continue
                        end

                        -- pass off the current syntax buffer var so things can load
                        local current_syntax = ""
                        if vim.b.current_syntax ~= "" or vim.b.current_syntax ~= nil then
                            vim.b.current_syntax = regex_language
                            current_syntax = vim.b.current_syntax
                            vim.b.current_syntax = nil
                        end

                        -- temporarily pass off keywords in case they get messed up
                        local is_keyword = vim.api.nvim_buf_get_option(buf, "iskeyword")

                        -- see if the syntax files even exist before we try to call them
                        -- if syn list was an error, or if it was an empty result
                        if ok == false or (ok == true and (string.sub(result, 1, 1) == "N" or count == 0)) then
                            local output = vim.api.nvim_get_runtime_file("syntax/" .. regex_language .. ".vim", false)
                            if output[1] ~= nil then
                                local command = "syntax include @" .. group .. " " .. output[1]
                                vim.cmd(command)
                            end
                            output = vim.api.nvim_get_runtime_file("after/syntax/" .. regex_language .. ".vim", false)
                            if output[1] ~= nil then
                                local command = "syntax include @" .. group .. " " .. output[1]
                                vim.cmd(command)
                            end
                        end

                        vim.api.nvim_buf_set_option(buf, "iskeyword", is_keyword)

                        -- reset it after
                        if current_syntax ~= "" or current_syntax ~= nil then
                            vim.b.current_syntax = current_syntax
                        else
                            vim.b.current_syntax = ""
                        end

                        -- set highlight groups
                        local regex_fallback_hl = "syntax region "
                            .. snip
                            .. ' matchgroup=Snip start="'
                            .. start_marker
                            .. "\" end='"
                            .. end_marker
                            .. "' contains=@"
                            .. group
                            .. " keepend"
                        vim.cmd("silent! " .. regex_fallback_hl)

                        -- resync syntax, fixes some slow loading
                        vim.cmd("syntax sync fromstart")
                        vim.b.current_syntax = ""
                    end

                    -- continue on from for loop if a language with parser is found or another syntax might be loaded
                    ::continue::
                end)
            end
        end
    end,

    trigger_code_block_highlights = function(buf, from, to)
        -- If the code block dimming is disabled, return right away.
        if not module.config.public.dim_code_blocks then
            return
        end

        module.public.clear_icons(buf, module.private.code_block_namespace, from, to)

        -- The next block of code will be responsible for dimming code blocks accordingly
        local tree = vim.treesitter.get_parser(buf, "norg"):parse()[1]

        -- If the tree is valid then attempt to perform the query
        if tree then
            -- Query all code blocks
            local ok, query = pcall(
                vim.treesitter.parse_query,
                "norg",
                [[(
                    (ranged_tag (tag_name) @_name) @tag
                    (#eq? @_name "code")
                )]]
            )

            -- If something went wrong then go bye bye
            if not ok or not query then
                return
            end

            -- Go through every found capture
            for id, node in query:iter_captures(tree:root(), buf, from or 0, to or -1) do
                vim.schedule(function()
                    local id_name = query.captures[id]

                    -- If the capture name is "tag" then that means we're dealing with our ranged_tag;
                    if id_name == "tag" then
                        -- Get the range of the code block
                        local range = module.required["core.integrations.treesitter"].get_node_range(node)

                        -- Go through every line in the code block and give it a magical highlight
                        for i = range.row_start, range.row_end >= vim.api.nvim_buf_line_count(buf) and 0 or range.row_end, 1 do
                            local line = vim.api.nvim_buf_get_lines(buf, i, i + 1, true)[1]

                            -- If our buffer is modifiable or if our line is too short then try to fill in the line
                            -- (this fixes broken syntax highlights automatically)
                            if vim.bo.modifiable and line:len() < range.column_start then
                                vim.api.nvim_buf_set_lines(buf, i, i + 1, true, { string.rep(" ", range.column_start) })
                            end

                            -- If our line is valid and it's not too short then apply the dimmed highlight
                            if line and line:len() >= range.column_start then
                                module.public._set_extmark(
                                    buf,
                                    nil,
                                    "NeorgCodeBlock",
                                    module.private.code_block_namespace,
                                    i,
                                    i + 1,
                                    range.column_start,
                                    nil,
                                    true,
                                    "blend"
                                )
                            end
                        end
                    end
                end)
            end
        end
    end,

    toggle_markup = function(buf)
        if module.config.public.markup.enabled then
            module.public.clear_icons(buf, module.private.markup_namespace)
            module.config.public.markup.enabled = false
        else
            module.config.public.markup.enabled = true
            module.public.trigger_icons(buf, module.private.markup, module.private.markup_namespace)
        end
    end,

    -- @Summary Sets an extmark in the buffer
    -- @Description Mostly a wrapper around vim.api.nvim_buf_set_extmark in order to make it more safe
    -- @Param  text (string|table) - the virtual text to overlay (usually the icon)
    -- @Param  highlight (string) - the name of a highlight to use for the icon
    -- @Param  line_number (number) - the line number to apply the extmark in
    -- @Param  end_line (number) - the last line number to apply the extmark to (useful if you want an extmark to exist for more than one line)
    -- @Param  start_column (number) - the start column of the conceal
    -- @Param  end_column (number) - the end column of the conceal
    -- @Param  whole_line (boolean) - if true will highlight the whole line (like in diffs)
    -- @Param  mode (string: "replace"/"combine"/"blend") - the highlight mode for the extmark
    _set_extmark = function(buf, text, highlight, ns, line_number, end_line, start_column, end_column, whole_line, mode)
        -- If the text type is a string then convert it into something that Neovim's extmark API can understand
        if type(text) == "string" then
            text = { { text, highlight } }
        end

        -- Attempt to call vim.api.nvim_buf_set_extmark with all the parameters
        local ok, result = pcall(vim.api.nvim_buf_set_extmark, buf, ns, line_number, start_column, {
            end_col = end_column,
            hl_group = highlight,
            end_line = end_line,
            virt_text = text or nil,
            virt_text_pos = "overlay",
            hl_mode = mode,
            hl_eol = whole_line,
        })

        -- If we have encountered an error then log it
        if not ok then
            log.error("Unable to create custom conceal for highlight:", highlight, "-", result)
        end
    end,

    -- @Summary Clears all the conceals that neorg has defined
    -- @Description Simply clears the Neorg extmark namespace
    -- @Param from (number) - the line number to start clearing from
    clear_icons = function(buf, namespace, from, to)
        vim.api.nvim_buf_clear_namespace(buf, namespace, from or 0, to or -1)
    end,

    completion_levels = {
        trigger_completion_levels_incremental = function(buf)
            -- Get the root node of the document (required to iterate over query captures)
            local document_root = module.required["core.integrations.treesitter"].get_document_root(buf)

            if not document_root then
                return
            end

            local current_node = module.required["core.integrations.treesitter"].get_ts_utils().get_node_at_cursor()

            if not current_node then
                return
            end

            local parent = module.required["core.integrations.treesitter"].find_parent(
                current_node,
                vim.tbl_keys(module.config.public.completion_level.queries)
            )

            if not parent then
                return
            end

            local query = module.config.public.completion_level.queries[parent:type()]

            if not query then
                return
            end

            local parent_range = module.required["core.integrations.treesitter"].get_node_range(parent)

            vim.schedule(function()
                module.public.completion_levels.clear_completion_levels(
                    buf,
                    parent_range.row_start,
                    parent_range.row_start + 1
                )

                local todo_item_counts = module.public.completion_levels.get_todo_item_counts(parent)

                if todo_item_counts.total ~= 0 then
                    vim.api.nvim_buf_set_extmark(
                        buf,
                        module.private.completion_level_namespace,
                        parent_range.row_start,
                        parent_range.column_start,
                        {
                            virt_text = module.public.completion_levels.convert_query_syntax_to_extmark_syntax(
                                query.text,
                                todo_item_counts
                            ),
                            hl_group = query.highlight,
                        }
                    )
                end
            end)
        end,

        trigger_completion_levels = function(buf, from, to)
            module.public.completion_levels.clear_completion_levels(buf, from, to)

            local root = module.required["core.integrations.treesitter"].get_document_root(buf)

            if not root then
                return
            end

            for node_name, data in pairs(module.config.public.completion_level.queries) do
                local ok, query = pcall(
                    vim.treesitter.parse_query,
                    "norg",
                    string.format(
                        [[
                        (%s) @parent
                    ]],
                        node_name
                    )
                )

                if not ok then
                    log.error(
                        "Failed to parse completion level for node type '"
                            .. node_name
                            .. "' - ensure that you're providing a valid node name. Full error: "
                            .. query
                    )
                    return
                end

                for id, node in query:iter_captures(root, buf, from, to) do
                    local capture = query.captures[id]

                    if capture == "parent" then
                        local node_range = module.required["core.integrations.treesitter"].get_node_range(node)

                        vim.schedule(function()
                            module.public.completion_levels.clear_completion_levels(
                                buf,
                                node_range.row_start,
                                node_range.row_start + 1
                            )

                            local todo_item_counts = module.public.completion_levels.get_todo_item_counts(node)

                            if todo_item_counts.total ~= 0 then
                                vim.api.nvim_buf_set_extmark(
                                    buf,
                                    module.private.completion_level_namespace,
                                    node_range.row_start,
                                    node_range.column_start,
                                    {
                                        virt_text = module.public.completion_levels.convert_query_syntax_to_extmark_syntax(
                                            data.text,
                                            todo_item_counts
                                        ),
                                        hl_group = data.highlight,
                                    }
                                )
                            end
                        end)
                    end
                end
            end
        end,

        get_todo_item_counts = function(start_node)
            local results = {}

            local total = 0

            for child_node in start_node:iter_children() do
                if child_node:type() == "generic_list" then
                    for todo_item_node in child_node:iter_children() do
                        if vim.startswith(todo_item_node:type(), "todo_item") then
                            local type_node = todo_item_node:named_child(1)

                            if type_node then
                                local todo_item_type = type_node:type():sub(string.len("todo_item_") + 1)
                                local resulting_todo_item = results[todo_item_type] or 0

                                results[todo_item_type] = resulting_todo_item + 1
                                total = total + (todo_item_type == "cancelled" and 0 or 1)
                            end
                        end
                    end
                end
            end

            results.total = total

            return results
        end,

        substitute_item_counts_in_str = function(str, item_counts)
            local types = {
                "undone",
                "pending",
                "done",
                "on_hold",
                "urgent",
                "cancelled",
                "recurring",
                "uncertain",
            }

            for _, type in ipairs(types) do
                str = str:gsub("<" .. type .. ">", item_counts[type] or 0)
            end

            str = str:gsub("<total>", item_counts.total)
            str = str:gsub("<percentage>", math.floor((item_counts.done or 0) / item_counts.total * 100))

            return str
        end,

        convert_query_syntax_to_extmark_syntax = function(tbl, item_counts)
            local result = vim.deepcopy(tbl)

            for i, item in ipairs(result) do
                if type(item) == "string" then
                    result[i] = { item }
                end

                result[i][1] = module.public.completion_levels.substitute_item_counts_in_str(result[i][1], item_counts)
            end

            return result
        end,

        clear_completion_levels = function(buf, from, to)
            vim.api.nvim_buf_clear_namespace(buf, module.private.completion_level_namespace, from or 0, to or -1)
        end,
    },

    -- VARIABLES
    concealing = {
        ordered = {
            get_index = function(node, level)
                local sibling = node:parent():prev_named_sibling()
                local count = 1

                while sibling and sibling:type() == level do
                    sibling = sibling:prev_named_sibling()
                    count = count + 1
                end

                return count
            end,

            enumerator = {
                numeric = function(count)
                    return tostring(count)
                end,

                latin_lowercase = function(count)
                    return string.char(96 + count)
                end,

                latin_uppercase = function(count)
                    return string.char(64 + count)
                end,

                -- NOTE: only supports number up to 12
                roman_lowercase = function(count)
                    local chars = {
                        [1] = "ⅰ",
                        [2] = "ⅱ",
                        [3] = "ⅲ",
                        [4] = "ⅳ",
                        [5] = "ⅴ",
                        [6] = "ⅵ",
                        [7] = "ⅶ",
                        [8] = "ⅷ",
                        [9] = "ⅸ",
                        [10] = "ⅹ",
                        [11] = "ⅺ",
                        [12] = "ⅻ",
                        [50] = "ⅼ",
                        [100] = "ⅽ",
                        [500] = "ⅾ",
                        [1000] = "ⅿ",
                    }
                    return chars[count]
                end,

                -- NOTE: only supports number up to 12
                roman_uppwercase = function(count)
                    local chars = {
                        [1] = "Ⅰ",
                        [2] = "Ⅱ",
                        [3] = "Ⅲ",
                        [4] = "Ⅳ",
                        [5] = "Ⅴ",
                        [6] = "Ⅵ",
                        [7] = "Ⅶ",
                        [8] = "Ⅷ",
                        [9] = "Ⅸ",
                        [10] = "Ⅹ",
                        [11] = "Ⅺ",
                        [12] = "Ⅻ",
                        [50] = "Ⅼ",
                        [100] = "Ⅽ",
                        [500] = "Ⅾ",
                        [1000] = "Ⅿ",
                    }
                    return chars[count]
                end,
            },

            punctuation = {
                dot = function(renderer)
                    return function(count)
                        return renderer(count) .. "."
                    end
                end,

                parenthesis = function(renderer)
                    return function(count)
                        return renderer(count) .. ")"
                    end
                end,

                double_parenthesis = function(renderer)
                    return function(count)
                        return "(" .. renderer(count) .. ")"
                    end
                end,

                -- NOTE: only supports arabic numbers up to 20
                unicode_dot = function(renderer)
                    return function(count)
                        local chars = {
                            ["1"] = "⒈",
                            ["2"] = "⒉",
                            ["3"] = "⒊",
                            ["4"] = "⒋",
                            ["5"] = "⒌",
                            ["6"] = "⒍",
                            ["7"] = "⒎",
                            ["8"] = "⒏",
                            ["9"] = "⒐",
                            ["10"] = "⒑",
                            ["11"] = "⒒",
                            ["12"] = "⒓",
                            ["13"] = "⒔",
                            ["14"] = "⒕",
                            ["15"] = "⒖",
                            ["16"] = "⒗",
                            ["17"] = "⒘",
                            ["18"] = "⒙",
                            ["19"] = "⒚",
                            ["20"] = "⒛",
                        }
                        return chars[renderer(count)]
                    end
                end,

                -- NOTE: only supports arabic numbers up to 20 or lowercase latin characters
                unicode_double_parenthesis = function(renderer)
                    return function(count)
                        local chars = {
                            ["1"] = "⑴",
                            ["2"] = "⑵",
                            ["3"] = "⑶",
                            ["4"] = "⑷",
                            ["5"] = "⑸",
                            ["6"] = "⑹",
                            ["7"] = "⑺",
                            ["8"] = "⑻",
                            ["9"] = "⑼",
                            ["10"] = "⑽",
                            ["11"] = "⑾",
                            ["12"] = "⑿",
                            ["13"] = "⒀",
                            ["14"] = "⒁",
                            ["15"] = "⒂",
                            ["16"] = "⒃",
                            ["17"] = "⒄",
                            ["18"] = "⒅",
                            ["19"] = "⒆",
                            ["20"] = "⒇",
                            ["a"] = "⒜",
                            ["b"] = "⒝",
                            ["c"] = "⒞",
                            ["d"] = "⒟",
                            ["e"] = "⒠",
                            ["f"] = "⒡",
                            ["g"] = "⒢",
                            ["h"] = "⒣",
                            ["i"] = "⒤",
                            ["j"] = "⒥",
                            ["k"] = "⒦",
                            ["l"] = "⒧",
                            ["m"] = "⒨",
                            ["n"] = "⒩",
                            ["o"] = "⒪",
                            ["p"] = "⒫",
                            ["q"] = "⒬",
                            ["r"] = "⒭",
                            ["s"] = "⒮",
                            ["t"] = "⒯",
                            ["u"] = "⒰",
                            ["v"] = "⒱",
                            ["w"] = "⒲",
                            ["x"] = "⒳",
                            ["y"] = "⒴",
                            ["z"] = "⒵",
                        }
                        return chars[renderer(count)]
                    end
                end,

                -- NOTE: only supports arabic numbers up to 20 or latin characters
                unicode_circle = function(renderer)
                    return function(count)
                        local chars = {
                            ["1"] = "①",
                            ["2"] = "②",
                            ["3"] = "③",
                            ["4"] = "④",
                            ["5"] = "⑤",
                            ["6"] = "⑥",
                            ["7"] = "⑦",
                            ["8"] = "⑧",
                            ["9"] = "⑨",
                            ["10"] = "⑩",
                            ["11"] = "⑪",
                            ["12"] = "⑫",
                            ["13"] = "⑬",
                            ["14"] = "⑭",
                            ["15"] = "⑮",
                            ["16"] = "⑯",
                            ["17"] = "⑰",
                            ["18"] = "⑱",
                            ["19"] = "⑲",
                            ["20"] = "⑳",
                            ["A"] = "Ⓐ",
                            ["B"] = "Ⓑ",
                            ["C"] = "Ⓒ",
                            ["D"] = "Ⓓ",
                            ["E"] = "Ⓔ",
                            ["F"] = "Ⓕ",
                            ["G"] = "Ⓖ",
                            ["H"] = "Ⓗ",
                            ["I"] = "Ⓘ",
                            ["J"] = "Ⓙ",
                            ["K"] = "Ⓚ",
                            ["L"] = "Ⓛ",
                            ["M"] = "Ⓜ",
                            ["N"] = "Ⓝ",
                            ["O"] = "Ⓞ",
                            ["P"] = "Ⓟ",
                            ["Q"] = "Ⓠ",
                            ["R"] = "Ⓡ",
                            ["S"] = "Ⓢ",
                            ["T"] = "Ⓣ",
                            ["U"] = "Ⓤ",
                            ["V"] = "Ⓥ",
                            ["W"] = "Ⓦ",
                            ["X"] = "Ⓧ",
                            ["Y"] = "Ⓨ",
                            ["Z"] = "Ⓩ",
                            ["a"] = "ⓐ",
                            ["b"] = "ⓑ",
                            ["c"] = "ⓒ",
                            ["d"] = "ⓓ",
                            ["e"] = "ⓔ",
                            ["f"] = "ⓕ",
                            ["g"] = "ⓖ",
                            ["h"] = "ⓗ",
                            ["i"] = "ⓘ",
                            ["j"] = "ⓙ",
                            ["k"] = "ⓚ",
                            ["l"] = "ⓛ",
                            ["m"] = "ⓜ",
                            ["n"] = "ⓝ",
                            ["o"] = "ⓞ",
                            ["p"] = "ⓟ",
                            ["q"] = "ⓠ",
                            ["r"] = "ⓡ",
                            ["s"] = "ⓢ",
                            ["t"] = "ⓣ",
                            ["u"] = "ⓤ",
                            ["v"] = "ⓥ",
                            ["w"] = "ⓦ",
                            ["x"] = "ⓧ",
                            ["y"] = "ⓨ",
                            ["z"] = "ⓩ",
                        }
                        return chars[renderer(count)]
                    end
                end,
            },
        },
    },

    foldtext = function()
        local foldstart = vim.v.foldstart
        local line = vim.api.nvim_buf_get_lines(0, foldstart - 1, foldstart, true)[1]
        local line_length = vim.api.nvim_strwidth(line)

        local icon_extmarks = vim.api.nvim_buf_get_extmarks(
            0,
            module.private.icon_namespace,
            { foldstart - 1, 0 },
            { foldstart - 1, line_length },
            {
                details = true,
            }
        )

        for _, extmark in ipairs(icon_extmarks) do
            local extmark_details = extmark[4]
            local extmark_column = extmark[3] + (line_length - line:len())

            for _, virt_text in ipairs(extmark_details.virt_text or {}) do
                line = line:sub(1, extmark_column)
                    .. virt_text[1]
                    .. line:sub(extmark_column + vim.api.nvim_strwidth(virt_text[1]) + 1)
                line_length = vim.api.nvim_strwidth(line) - line_length + vim.api.nvim_strwidth(virt_text[1])
            end
        end

        local completion_extmarks = vim.api.nvim_buf_get_extmarks(
            0,
            module.private.completion_level_namespace,
            { foldstart - 1, 0 },
            { foldstart - 1, vim.api.nvim_strwidth(line) },
            {
                details = true,
            }
        )

        if not vim.tbl_isempty(completion_extmarks) then
            line = line .. " "

            for _, extmark in ipairs(completion_extmarks) do
                for _, virt_text in ipairs(extmark[4].virt_text or {}) do
                    line = line .. virt_text[1]
                end
            end
        end

        return line
    end,
}

module.config.public = {
    -- Which icon preset to use
    -- Go to [imports](#imports) to see which ones are currently defined
    -- E.g `core.norg.concealer.preset_diamond` will be `preset = "diamond"`
    icon_preset = "basic",

    -- Icons related config
    icons = {
        todo = {
            enabled = true,

            done = {
                enabled = true,
                icon = "",
                highlight = "NeorgTodoItemDoneMark",
                query = "(todo_item_done) @icon",
                extract = function()
                    return 1
                end,
            },

            pending = {
                enabled = true,
                icon = "",
                highlight = "NeorgTodoItemPendingMark",
                query = "(todo_item_pending) @icon",
                extract = function()
                    return 1
                end,
            },

            undone = {
                enabled = true,
                icon = "×",
                highlight = "NeorgTodoItemUndoneMark",
                query = "(todo_item_undone) @icon",
                extract = function()
                    return 1
                end,
            },

            uncertain = {
                enabled = true,
                icon = "",
                highlight = "NeorgTodoItemUncertainMark",
                query = "(todo_item_uncertain) @icon",
                extract = function()
                    return 1
                end,
            },

            on_hold = {
                enabled = true,
                icon = "",
                highlight = "NeorgTodoItemOnHoldMark",
                query = "(todo_item_on_hold) @icon",
                extract = function()
                    return 1
                end,
            },

            cancelled = {
                enabled = true,
                icon = "",
                highlight = "NeorgTodoItemCancelledMark",
                query = "(todo_item_cancelled) @icon",
                extract = function()
                    return 1
                end,
            },

            recurring = {
                enabled = true,
                icon = "⟳",
                highlight = "NeorgTodoItemRecurringMark",
                query = "(todo_item_recurring) @icon",
                extract = function()
                    return 1
                end,
            },

            urgent = {
                enabled = true,
                icon = "⚠",
                highlight = "NeorgTodoItemUrgentMark",
                query = "(todo_item_urgent) @icon",
                extract = function()
                    return 1
                end,
            },
        },

        list = {
            enabled = true,

            level_1 = {
                enabled = true,
                icon = "•",
                highlight = "NeorgUnorderedList1",
                query = "(unordered_list1_prefix) @icon",
            },

            level_2 = {
                enabled = true,
                icon = " •",
                highlight = "NeorgUnorderedList2",
                query = "(unordered_list2_prefix) @icon",
            },

            level_3 = {
                enabled = true,
                icon = "  •",
                highlight = "NeorgUnorderedList3",
                query = "(unordered_list3_prefix) @icon",
            },

            level_4 = {
                enabled = true,
                icon = "   •",
                highlight = "NeorgUnorderedList4",
                query = "(unordered_list4_prefix) @icon",
            },

            level_5 = {
                enabled = true,
                icon = "    •",
                highlight = "NeorgUnorderedList5",
                query = "(unordered_list5_prefix) @icon",
            },

            level_6 = {
                enabled = true,
                icon = "     •",
                highlight = "NeorgUnorderedList6",
                query = "(unordered_list6_prefix) @icon",
            },
        },

        link = {
            enabled = true,
            level_1 = {
                enabled = true,
                icon = " ",
                highlight = "NeorgUnorderedLink1",
                query = "(unordered_link1_prefix) @icon",
            },
            level_2 = {
                enabled = true,
                icon = "  ",
                highlight = "NeorgUnorderedLink2",
                query = "(unordered_link2_prefix) @icon",
            },
            level_3 = {
                enabled = true,
                icon = "   ",
                highlight = "NeorgUnorderedLink3",
                query = "(unordered_link3_prefix) @icon",
            },
            level_4 = {
                enabled = true,
                icon = "    ",
                highlight = "NeorgUnorderedLink4",
                query = "(unordered_link4_prefix) @icon",
            },
            level_5 = {
                enabled = true,
                icon = "     ",
                highlight = "NeorgUnorderedLink5",
                query = "(unordered_link5_prefix) @icon",
            },
            level_6 = {
                enabled = true,
                icon = "      ",
                highlight = "NeorgUnorderedLink6",
                query = "(unordered_link6_prefix) @icon",
            },
        },

        ordered = {
            enabled = require("neorg.external.helpers").is_minimum_version(0, 6, 0),

            level_1 = {
                enabled = true,
                icon = module.public.concealing.ordered.punctuation.unicode_dot(
                    module.public.concealing.ordered.enumerator.numeric
                ),
                highlight = "NeorgOrderedList1",
                query = "(ordered_list1_prefix) @icon",
                render = function(self, _, node)
                    local count = module.public.concealing.ordered.get_index(node, "ordered_list1")
                    return {
                        { self.icon(count), self.highlight },
                    }
                end,
            },

            level_2 = {
                enabled = true,
                icon = module.public.concealing.ordered.enumerator.latin_uppercase,
                highlight = "NeorgOrderedList2",
                query = "(ordered_list2_prefix) @icon",
                render = function(self, _, node)
                    local count = module.public.concealing.ordered.get_index(node, "ordered_list2")
                    return {
                        { " " .. self.icon(count), self.highlight },
                    }
                end,
            },

            level_3 = {
                enabled = true,
                icon = module.public.concealing.ordered.enumerator.latin_lowercase,
                highlight = "NeorgOrderedList3",
                query = "(ordered_list3_prefix) @icon",
                render = function(self, _, node)
                    local count = module.public.concealing.ordered.get_index(node, "ordered_list3")
                    return {
                        { "  " .. self.icon(count), self.highlight },
                    }
                end,
            },

            level_4 = {
                enabled = true,
                icon = module.public.concealing.ordered.punctuation.unicode_double_parenthesis(
                    module.public.concealing.ordered.enumerator.numeric
                ),
                highlight = "NeorgOrderedList4",
                query = "(ordered_list4_prefix) @icon",
                render = function(self, _, node)
                    local count = module.public.concealing.ordered.get_index(node, "ordered_list4")
                    return {
                        { "   " .. self.icon(count), self.highlight },
                    }
                end,
            },

            level_5 = {
                enabled = true,
                icon = module.public.concealing.ordered.enumerator.latin_uppercase,
                highlight = "NeorgOrderedList5",
                query = "(ordered_list5_prefix) @icon",
                render = function(self, _, node)
                    local count = module.public.concealing.ordered.get_index(node, "ordered_list5")
                    return {
                        { "    " .. self.icon(count), self.highlight },
                    }
                end,
            },

            level_6 = {
                enabled = true,
                icon = module.public.concealing.ordered.punctuation.unicode_double_parenthesis(
                    module.public.concealing.ordered.enumerator.latin_lowercase
                ),
                highlight = "NeorgOrderedList6",
                query = "(ordered_list6_prefix) @icon",
                render = function(self, _, node)
                    local count = module.public.concealing.ordered.get_index(node, "ordered_list6")
                    return {
                        { "     " .. self.icon(count), self.highlight },
                    }
                end,
            },
        },

        ordered_link = {
            enabled = true,
            level_1 = {
                enabled = true,
                icon = module.public.concealing.ordered.punctuation.unicode_circle(
                    module.public.concealing.ordered.enumerator.numeric
                ),
                highlight = "NeorgOrderedLink1",
                query = "(ordered_link1_prefix) @icon",
                render = function(self, _, node)
                    local count = module.public.concealing.ordered.get_index(node, "ordered_link1")
                    return {
                        { " " .. self.icon(count), self.highlight },
                    }
                end,
            },
            level_2 = {
                enabled = true,
                icon = module.public.concealing.ordered.punctuation.unicode_circle(
                    module.public.concealing.ordered.enumerator.latin_uppercase
                ),
                highlight = "NeorgOrderedLink2",
                query = "(ordered_link2_prefix) @icon",
                render = function(self, _, node)
                    local count = module.public.concealing.ordered.get_index(node, "ordered_link2")
                    return {
                        { "  " .. self.icon(count), self.highlight },
                    }
                end,
            },
            level_3 = {
                enabled = true,
                icon = module.public.concealing.ordered.punctuation.unicode_circle(
                    module.public.concealing.ordered.enumerator.latin_lowercase
                ),
                highlight = "NeorgOrderedLink3",
                query = "(ordered_link3_prefix) @icon",
                render = function(self, _, node)
                    local count = module.public.concealing.ordered.get_index(node, "ordered_link3")
                    return {
                        { "   " .. self.icon(count), self.highlight },
                    }
                end,
            },
            level_4 = {
                enabled = true,
                icon = module.public.concealing.ordered.punctuation.unicode_circle(
                    module.public.concealing.ordered.enumerator.numeric
                ),
                highlight = "NeorgOrderedLink4",
                query = "(ordered_link4_prefix) @icon",
                render = function(self, _, node)
                    local count = module.public.concealing.ordered.get_index(node, "ordered_link4")
                    return {
                        { "    " .. self.icon(count), self.highlight },
                    }
                end,
            },
            level_5 = {
                enabled = true,
                icon = module.public.concealing.ordered.punctuation.unicode_circle(
                    module.public.concealing.ordered.enumerator.latin_uppercase
                ),
                highlight = "NeorgOrderedLink5",
                query = "(ordered_link5_prefix) @icon",
                render = function(self, _, node)
                    local count = module.public.concealing.ordered.get_index(node, "ordered_link5")
                    return {
                        { "     " .. self.icon(count), self.highlight },
                    }
                end,
            },
            level_6 = {
                enabled = true,
                icon = module.public.concealing.ordered.punctuation.unicode_circle(
                    module.public.concealing.ordered.enumerator.latin_lowercase
                ),
                highlight = "NeorgOrderedLink6",
                query = "(ordered_link6_prefix) @icon",
                render = function(self, _, node)
                    local count = module.public.concealing.ordered.get_index(node, "ordered_link6")
                    return {
                        { "      " .. self.icon(count), self.highlight },
                    }
                end,
            },
        },

        quote = {
            enabled = true,

            level_1 = {
                enabled = true,
                icon = "│",
                highlight = "NeorgQuote1",
                query = "(quote1_prefix) @icon",
            },

            level_2 = {
                enabled = true,
                icon = "│",
                highlight = "NeorgQuote2",
                query = "(quote2_prefix) @icon",
                render = function(self)
                    return {
                        { self.icon, module.config.public.icons.quote.level_1.highlight },
                        { self.icon, self.highlight },
                    }
                end,
            },

            level_3 = {
                enabled = true,
                icon = "│",
                highlight = "NeorgQuote3",
                query = "(quote3_prefix) @icon",
                render = function(self)
                    return {
                        { self.icon, module.config.public.icons.quote.level_1.highlight },
                        { self.icon, module.config.public.icons.quote.level_2.highlight },
                        { self.icon, self.highlight },
                    }
                end,
            },

            level_4 = {
                enabled = true,
                icon = "│",
                highlight = "NeorgQuote4",
                query = "(quote4_prefix) @icon",
                render = function(self)
                    return {
                        { self.icon, module.config.public.icons.quote.level_1.highlight },
                        { self.icon, module.config.public.icons.quote.level_2.highlight },
                        { self.icon, module.config.public.icons.quote.level_3.highlight },
                        { self.icon, self.highlight },
                    }
                end,
            },

            level_5 = {
                enabled = true,
                icon = "│",
                highlight = "NeorgQuote5",
                query = "(quote5_prefix) @icon",
                render = function(self)
                    return {
                        { self.icon, module.config.public.icons.quote.level_1.highlight },
                        { self.icon, module.config.public.icons.quote.level_2.highlight },
                        { self.icon, module.config.public.icons.quote.level_3.highlight },
                        { self.icon, module.config.public.icons.quote.level_4.highlight },
                        { self.icon, self.highlight },
                    }
                end,
            },

            level_6 = {
                enabled = true,
                icon = "│",
                highlight = "NeorgQuote6",
                query = "(quote6_prefix) @icon",
                render = function(self)
                    return {
                        { self.icon, module.config.public.icons.quote.level_1.highlight },
                        { self.icon, module.config.public.icons.quote.level_2.highlight },
                        { self.icon, module.config.public.icons.quote.level_3.highlight },
                        { self.icon, module.config.public.icons.quote.level_4.highlight },
                        { self.icon, module.config.public.icons.quote.level_5.highlight },
                        { self.icon, self.highlight },
                    }
                end,
            },
        },

        heading = {
            enabled = true,

            level_1 = {
                enabled = true,
                icon = "◉",
                highlight = "NeorgHeading1",
                query = "(heading1_prefix) @icon",
            },

            level_2 = {
                enabled = true,
                icon = " ◎",
                highlight = "NeorgHeading2",
                query = "(heading2_prefix) @icon",
            },

            level_3 = {
                enabled = true,
                icon = "  ○",
                highlight = "NeorgHeading3",
                query = "(heading3_prefix) @icon",
            },

            level_4 = {
                enabled = true,
                icon = "   ✺",
                highlight = "NeorgHeading4",
                query = "(heading4_prefix) @icon",
            },

            level_5 = {
                enabled = true,
                icon = "    ▶",
                highlight = "NeorgHeading5",
                query = "(heading5_prefix) @icon",
            },

            level_6 = {
                enabled = true,
                icon = "     ⤷",
                highlight = "NeorgHeading6",
                query = "(heading6_prefix) @icon",
                render = function(self, text)
                    return {
                        {
                            string.rep(" ", text:len() - string.len("******") - string.len(" ")) .. self.icon,
                            self.highlight,
                        },
                    }
                end,
            },
        },

        marker = {
            enabled = true,
            icon = "",
            highlight = "NeorgMarker",
            query = "(marker_prefix) @icon",
        },

        definition = {
            enabled = true,

            single = {
                enabled = true,
                icon = "≡",
                highlight = "NeorgDefinition",
                query = "(single_definition_prefix) @icon",
            },
            multi_prefix = {
                enabled = true,
                icon = "⋙ ",
                highlight = "NeorgDefinition",
                query = "(multi_definition_prefix) @icon",
            },
            multi_suffix = {
                enabled = true,
                icon = "⋘ ",
                highlight = "NeorgDefinition",
                query = "(multi_definition_suffix) @icon",
            },
        },

        footnote = {
            enabled = true,

            single = {
                enabled = true,
                icon = "⁎",
                highlight = "NeorgFootnote",
                query = "(single_footnote_prefix) @icon",
            },
            multi_prefix = {
                enabled = true,
                icon = "⁑ ",
                highlight = "NeorgFootnote",
                query = "(multi_footnote_prefix) @icon",
            },
            multi_suffix = {
                enabled = true,
                icon = "⁑ ",
                highlight = "NeorgFootnote",
                query = "(multi_footnote_suffix) @icon",
            },
        },

        delimiter = {
            enabled = true,

            weak = {
                enabled = true,
                icon = "⟨",
                highlight = "NeorgWeakParagraphDelimiter",
                query = "(weak_paragraph_delimiter) @icon",
                render = function(self, text)
                    return {
                        { string.rep(self.icon, text:len()), self.highlight },
                    }
                end,
            },

            strong = {
                enabled = true,
                icon = "⟪",
                highlight = "NeorgStrongParagraphDelimiter",
                query = "(strong_paragraph_delimiter) @icon",
                render = function(self, text)
                    return {
                        { string.rep(self.icon, text:len()), self.highlight },
                    }
                end,
            },

            horizontal_line = {
                enabled = true,
                icon = "─",
                highlight = "NeorgHorizontalLine",
                query = "(horizontal_line) @icon",
                render = function(self, _, node)
                    -- Get the length of the Neovim window (used to render to the edge of the screen)
                    local resulting_length = vim.api.nvim_win_get_width(0)

                    -- If we are running at least 0.6 (which has the prev_sibling() function) then
                    if require("neorg.external.helpers").is_minimum_version(0, 6, 0) then
                        -- Grab the sibling before our current node in order to later
                        -- determine how much space it occupies in the buffer vertically
                        local prev_sibling = node:prev_sibling()
                        local double_prev_sibling = prev_sibling:prev_sibling()
                        local ts = module.required["core.integrations.treesitter"].get_ts_utils()

                        if prev_sibling then
                            -- Get the text of the previous sibling and store its longest line width-wise
                            local text = ts.get_node_text(prev_sibling)
                            local longest = 3

                            if
                                prev_sibling:parent()
                                and double_prev_sibling
                                and double_prev_sibling:type() == "marker_prefix"
                            then
                                local range_of_prefix = module.required["core.integrations.treesitter"].get_node_range(
                                    double_prev_sibling
                                )
                                local range_of_title = module.required["core.integrations.treesitter"].get_node_range(
                                    prev_sibling
                                )
                                resulting_length = (range_of_prefix.column_end - range_of_prefix.column_start)
                                    + (range_of_title.column_end - range_of_title.column_start)
                            else
                                -- Go through each line and remove its surrounding whitespace,
                                -- we do this because some inconsistencies tend to occur with
                                -- the way whitespace is handled.
                                for _, line in ipairs(text) do
                                    line = vim.trim(line)

                                    -- If the line even has any "normal" characters
                                    -- and its length is a new record then update the
                                    -- `longest` variable
                                    if line:match("%w") and line:len() > longest then
                                        longest = line:len()
                                    end
                                end
                            end

                            -- If we've set a longest value then override the resulting length
                            -- with that longest value (to make it render only up until that point)
                            if longest > 0 then
                                resulting_length = longest
                            end
                        end
                    end

                    return {
                        {
                            string.rep(self.icon, resulting_length),
                            self.highlight,
                        },
                    }
                end,
            },
        },
    },

    -- Markup presets to use (currents: `safe`, `brave`)
    -- `safe` will use whitespaces to conceal markup
    -- `brave` will use the word joiner unicode
    -- `dimmed` will dim markup icons instead of concealing them
    markup_preset = "safe",

    -- Markup related config
    markup = {
        enabled = true,
        icon = " ",

        bold = {
            enabled = true,
            highlight = "NeorgMarkupBold",
            query = '(bold (["_open" "_close"]) @icon)',
        },

        italic = {
            enabled = true,
            highlight = "NeorgMarkupItalic",
            query = '(italic (["_open" "_close"]) @icon)',
        },

        underline = {
            enabled = true,
            highlight = "NeorgMarkupUnderline",
            query = '(underline (["_open" "_close"]) @icon)',
        },

        strikethrough = {
            enabled = true,
            highlight = "NeorgMarkupStrikethrough",
            query = '(strikethrough (["_open" "_close"]) @icon)',
        },

        subscript = {
            enabled = true,
            highlight = "NeorgMarkupSubscript",
            query = '(subscript (["_open" "_close"]) @icon)',
        },

        superscript = {
            enabled = true,
            highlight = "NeorgMarkupSuperscript",
            query = '(superscript (["_open" "_close"]) @icon)',
        },

        verbatim = {
            enabled = true,
            highlight = "NeorgMarkupVerbatim",
            query = '(verbatim (["_open" "_close"]) @icon)',
        },

        comment = {
            enabled = true,
            highlight = "NeorgMarkupInlineComment",
            query = '(inline_comment (["_open" "_close"]) @icon)',
        },

        math = {
            enabled = true,
            highlight = "NeorgMarkupMath",
            query = '(inline_math (["_open" "_close"]) @icon)',
        },

        variable = {
            enabled = true,
            highlight = "NeorgMarkupVariable",
            query = '(variable (["_open" "_close"]) @icon)',
        },

        spoiler = {
            enabled = true,
            icon = "●",
            -- NOTE: as you can see, you can still overwrite the parent-icon
            -- inherited from above.
            highlight = "NeorgMarkupSpoiler",
            query = "(spoiler) @icon",
            render = function(self, text)
                return {
                    { string.rep(self.icon, #text), self.highlight },
                }
            end,
        },

        link_modifier = {
            enabled = true,
            highlight = "NeorgLinkModifier",
            query = "(link_modifier) @icon",
        },

        trailing_modifier = {
            enabled = true,
            highlight = "NeorgTrailingModifier",
            query = '("_trailing_modifier") @icon',
        },

        url = {
            enabled = true,

            link = {
                enabled = true,

                unnamed = {
                    enabled = true,
                    highlight = "NeorgLinkLocationDelimiter",
                    query = [[
                    (link
                        (link_location
                            (["_begin" "_end"]) @icon
                        )
                        .
                    )
                    ]],
                },

                named = {
                    enabled = true,

                    location = {
                        enabled = true,
                        highlight = "NeorgLinkLocationDelimiter",
                        query = [[
                            (link
                                (link_location) @icon
                                (link_description)
                            )
                        ]],
                        render = function(self, text)
                            return {
                                { string.rep(self.icon, #text), self.highlight },
                            }
                        end,
                    },

                    text = {
                        enabled = true,
                        highlight = "NeorgLinkTextDelimiter",
                        query = [[
                            (link
                                (link_description (["_begin" "_end"]) @icon)
                            )
                        ]],
                    },
                },
            },

            anchor = {
                enabled = true,

                declaration = {
                    enabled = true,
                    highlight = "NeorgAnchorDeclarationDelimiter",
                    query = [[
                    (anchor_declaration
                        (link_description
                            (["_begin" "_end"]) @icon
                        )
                    )
                    ]],
                },

                definition = {
                    enabled = true,

                    description = {
                        enabled = true,
                        highlight = "NeorgAnchorDeclarationDelimiter",
                        query = [[(
                            (link_description
                                (["_begin" "_end"]) @icon
                            ) @_description
                            (#has-parent? @_description "anchor_definition")
                        )]],
                        -- NOTE: right now this is a duplicate of the above but
                        -- we could envision concealing these two scenarios
                        -- differently.
                    },

                    location = {
                        enabled = true,
                        highlight = "NeorgAnchorDefinitionDelimiter",
                        query = [[
                        (anchor_definition
                            (link_location) @icon
                        )
                        ]],
                        render = function(self, text)
                            return {
                                { string.rep(self.icon, #text), self.highlight },
                            }
                        end,
                    },
                },
            },
        },
    },

    -- If you want to dim code blocks
    dim_code_blocks = true,
    folds = true,

    completion_level = {
        enabled = true,

        queries = vim.tbl_deep_extend(
            "keep",
            {},
            (function()
                local result = {}

                for i = 1, 6 do
                    result["heading" .. i] = {
                        text = {
                            "(",
                            { "<done>", "TSField" },
                            " of ",
                            { "<total>", "NeorgTodoItem1Done" },
                            ") [<percentage>% complete]",
                        },

                        highlight = "DiagnosticVirtualTextHint",
                    }
                end

                return result
            end)()
            --[[ (function()
                local result = {}

                for i = 1, 6 do
                    result["todo_item" .. i] = {
                        text = "[<done>/<total>]",
                        highlight = "DiagnosticVirtualTextHint",
                    }
                end

                return result
            end)() ]]
        ),
    },

    performance = {
        increment = 1250,
        timeout = 0,
        interval = 500,
    },
}

module.load = function()
    if not module.config.private["icon_preset_" .. module.config.public.icon_preset] then
        log.error(
            string.format(
                "Unable to load icon preset '%s' - such a preset does not exist",
                module.config.public.icon_preset
            )
        )
        return
    end

    module.config.public.icons = vim.tbl_deep_extend(
        "force",
        module.config.public.icons,
        module.config.private["icon_preset_" .. module.config.public.icon_preset] or {},
        module.config.custom
    )

    if not module.config.private["markup_preset_" .. module.config.public.markup_preset] then
        log.error(
            string.format(
                "Unable to load markup preset '%s' - such a preset does not exist",
                module.config.public.markup_preset
            )
        )
        return
    end

    module.config.public.markup = vim.tbl_deep_extend(
        "force",
        module.config.public.markup,
        module.config.private["markup_preset_" .. module.config.public.markup_preset] or {},
        module.config.custom
    )

    -- @Summary Returns all the enabled icons from a table
    -- @Param  tbl (table) - the table to parse
    -- @Param parent_icon (string) - Is used to pass icons from parents down to their table children to handle inheritance.
    -- @Param rec_name (string) - should not be set manually. Is used for Neorg to have information about all other previous recursions
    local function get_enabled_icons(tbl, parent_icon, rec_name)
        rec_name = rec_name or ""

        -- Create a result that we will return at the end of the function
        local result = {}

        -- If the current table isn't enabled then don't parser any further - simply return the empty result
        if vim.tbl_isempty(tbl) or (tbl.enabled ~= nil and tbl.enabled == false) then
            return result
        end

        -- Go through every icon
        for name, icons in pairs(tbl) do
            -- If we're dealing with a table (which we should be) and if the current icon set is enabled then
            if type(icons) == "table" and icons.enabled then
                -- If we have defined a query value then add that icon to the result
                if icons.query then
                    result[rec_name .. name] = icons
                    if icons.icon == nil then
                        result[rec_name .. name].icon = parent_icon
                    end
                else
                    -- If we don't have an icon variable then we need to descend further down the lua table.
                    -- To do this we recursively call this very function and merge the results into the result table
                    result = vim.tbl_deep_extend(
                        "force",
                        result,
                        get_enabled_icons(icons, parent_icon, rec_name .. name)
                    )
                end
            end
        end

        return result
    end

    -- Set the module.private.icons variable to the values of the enabled icons
    module.private.icons = vim.tbl_values(get_enabled_icons(module.config.public.icons))
    module.private.markup = vim.tbl_values(
        get_enabled_icons(module.config.public.markup, module.config.public.markup.icon)
    )

    -- Register keybinds
    module.required["core.keybinds"].register_keybinds(module.name, { "toggle-markup" })

    -- Enable the required autocommands (these will be used to determine when to update conceals in the buffer)
    module.required["core.autocommands"].enable_autocommand("BufEnter")

    module.required["core.autocommands"].enable_autocommand("InsertEnter")
    module.required["core.autocommands"].enable_autocommand("InsertLeave")
end

module.on_event = function(event)
    if event.type == "core.autocommands.events.bufenter" and event.content.norg then
        local buf = event.buffer
        local line_count = vim.api.nvim_buf_line_count(buf)

        if line_count < module.config.public.performance.increment then
            module.public.trigger_icons(buf, module.private.icons, module.private.icon_namespace)
            module.public.trigger_icons(buf, module.private.markup, module.private.markup_namespace)
            module.public.trigger_highlight_regex_code_block(buf)
            module.public.trigger_code_block_highlights(buf)
            module.public.completion_levels.trigger_completion_levels(buf)
        else
            local block_current = math.floor(
                (line_count / module.config.public.performance.increment) % event.cursor_position[1]
            )

            local function trigger_conceals_for_block(block)
                local line_begin = block == 0 and 0 or block * module.config.public.performance.increment - 1
                local line_end = math.min(
                    block * module.config.public.performance.increment + module.config.public.performance.increment - 1,
                    line_count
                )

                module.public.trigger_icons(
                    buf,
                    module.private.icons,
                    module.private.icon_namespace,
                    line_begin,
                    line_end
                )
                module.public.trigger_icons(
                    buf,
                    module.private.markup,
                    module.private.markup_namespace,
                    line_begin,
                    line_end
                )
                module.public.trigger_highlight_regex_code_block(buf, line_begin, line_end)
                module.public.trigger_code_block_highlights(buf, line_begin, line_end)
                module.public.completion_levels.trigger_completion_levels(buf, line_begin, line_end)
            end

            trigger_conceals_for_block(block_current)

            local block_bottom, block_top = block_current - 1, block_current + 1

            local timer = vim.loop.new_timer()

            timer:start(
                module.config.public.performance.timeout,
                module.config.public.performance.interval,
                vim.schedule_wrap(function()
                    local block_bottom_valid = block_bottom == 0
                        or (block_bottom * module.config.public.performance.increment - 1 >= 0)
                    local block_top_valid = block_top * module.config.public.performance.increment - 1 < line_count

                    if not block_bottom_valid and not block_top_valid then
                        timer:stop()
                        return
                    end

                    if block_bottom_valid then
                        trigger_conceals_for_block(block_bottom)
                        block_bottom = block_bottom - 1
                    end

                    if block_top_valid then
                        trigger_conceals_for_block(block_top)
                        block_top = block_top + 1
                    end
                end)
            )
        end

        vim.api.nvim_buf_attach(buf, false, {
            on_lines = function(_, cur_buf, _, start, _end)
                if buf ~= cur_buf then
                    return true
                end

                module.private.last_change.active = true

                local mode = vim.api.nvim_get_mode().mode

                if mode ~= "i" then
                    vim.schedule(function()
                        local new_line_count = vim.api.nvim_buf_line_count(buf)

                        -- Sometimes occurs with one-line undos
                        if start == _end then
                            _end = _end + 1
                        end

                        if new_line_count > line_count then
                            _end = _end + (new_line_count - line_count - 1)
                        end

                        line_count = new_line_count

                        module.public.trigger_icons(
                            buf,
                            module.private.icons,
                            module.private.icon_namespace,
                            start,
                            _end
                        )

                        local node_range =
                            module.required["core.integrations.treesitter"].get_ts_utils().get_node_at_cursor()

                        if node_range then
                            node_range = module.required["core.integrations.treesitter"].get_node_range(
                                node_range:parent()
                            )
                        end

                        module.public.trigger_icons(
                            event.buffer,
                            module.private.markup,
                            module.private.markup_namespace,
                            node_range and node_range.row_start,
                            node_range and node_range.row_end
                        )

                        module.public.trigger_highlight_regex_code_block(buf, start, _end)

                        -- NOTE(vhyrro): It is simply not possible to perform incremental
                        -- updates here. Code blocks require more context than simply a few lines.
                        -- It's still incredibly fast despite this fact though.
                        module.public.trigger_code_block_highlights(buf)

                        module.public.completion_levels.trigger_completion_levels(buf, start, _end)
                    end)
                else
                    vim.schedule(neorg.lib.wrap(module.public.trigger_code_block_highlights, buf, start, _end))

                    if module.private.largest_change_start == -1 then
                        module.private.largest_change_start = start
                    end

                    if module.private.largest_change_end == -1 then
                        module.private.largest_change_end = _end
                    end

                    module.private.largest_change_start = start < module.private.largest_change_start and start
                        or module.private.largest_change_start
                    module.private.largest_change_end = _end > module.private.largest_change_end and _end
                        or module.private.largest_change_end
                end
            end,
        })
    elseif event.type == "core.autocommands.events.insertenter" then
        vim.schedule(function()
            module.private.last_change = {
                active = false,
                line = event.cursor_position[1] - 1,
            }

            vim.api.nvim_buf_clear_namespace(
                event.buffer,
                module.private.icon_namespace,
                event.cursor_position[1] - 1,
                event.cursor_position[1]
            )
            vim.api.nvim_buf_clear_namespace(
                event.buffer,
                module.private.markup_namespace,
                event.cursor_position[1] - 1,
                event.cursor_position[1]
            )
            vim.api.nvim_buf_clear_namespace(
                event.buffer,
                module.private.completion_level_namespace,
                event.cursor_position[1] - 1,
                event.cursor_position[1]
            )
        end)
    elseif event.type == "core.autocommands.events.insertleave" then
        vim.schedule(function()
            if not module.private.last_change.active or module.private.largest_change_end == -1 then
                module.public.trigger_icons(
                    event.buffer,
                    module.private.icons,
                    module.private.icon_namespace,
                    module.private.last_change.line,
                    module.private.last_change.line + 1
                )
                module.public.trigger_icons(
                    event.buffer,
                    module.private.markup,
                    module.private.markup_namespace,
                    module.private.last_change.line,
                    module.private.last_change.line + 1
                )
                module.public.trigger_highlight_regex_code_block(
                    event.buffer,
                    module.private.last_change.line,
                    module.private.last_change.line + 1
                )
                module.public.completion_levels.trigger_completion_levels_incremental(event.buffer)
            else
                module.public.trigger_icons(
                    event.buffer,
                    module.private.icons,
                    module.private.icon_namespace,
                    module.private.largest_change_start,
                    module.private.largest_change_end
                )
                module.public.trigger_icons(
                    event.buffer,
                    module.private.markup,
                    module.private.markup_namespace,
                    module.private.largest_change_start,
                    module.private.largest_change_end
                )
                module.public.trigger_highlight_regex_code_block(
                    event.buffer,
                    module.private.largest_change_start,
                    module.private.largest_change_end
                )
                module.public.completion_levels.trigger_completion_levels_incremental(event.buffer)
            end

            module.private.largest_change_start, module.private.largest_change_end = -1, -1
        end)
    elseif event.type == "core.keybinds.events.core.norg.concealer.toggle-markup" then
        module.public.toggle_markup(event.buffer)
    end
end

module.events.subscribed = {
    ["core.autocommands"] = {
        bufenter = true,
        insertenter = true,
        insertleave = true,
    },
    ["core.keybinds"] = {
        ["core.norg.concealer.toggle-markup"] = true,
    },
}

return module
