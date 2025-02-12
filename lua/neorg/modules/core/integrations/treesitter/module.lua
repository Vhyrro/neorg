--[[
    file: Treesitter-Integration
    title: Snazzy Treesitter Integration
    summary: A module designed to integrate Treesitter into Neorg.
    embed: https://user-images.githubusercontent.com/76052559/151668244-9805afc4-8c50-4925-85ec-1098aff5ede6.gif
    internal: true
    ---

## Keybinds

This module exposes the following keybinds (see [`core.keybinds`](@core.keybinds) for instructions on
mapping them):

- `neorg.treesitter.next.heading` - jump to the next heading
- `neorg.treesitter.next.link` - jump to the next link
- `neorg.treesitter.previous.heading` - jump to the previous heading
- `neorg.treesitter.previous.link` - jump to the previous link
--]]

local neorg = require("neorg.core")
local lib, log, modules, utils = neorg.lib, neorg.log, neorg.modules, neorg.utils

local module = modules.create("core.integrations.treesitter")

module.private = {
    ts_utils = nil,
    link_query = [[
                (link) @next-segment
                (anchor_declaration) @next-segment
                (anchor_definition) @next-segment
             ]],
    heading_query = [[
                 [
                     (heading1
                         title: (paragraph_segment) @next-segment
                     )
                     (heading2
                         title: (paragraph_segment) @next-segment
                     )
                     (heading3
                         title: (paragraph_segment) @next-segment
                     )
                     (heading4
                         title: (paragraph_segment) @next-segment
                     )
                     (heading5
                         title: (paragraph_segment) @next-segment
                     )
                     (heading6
                         title: (paragraph_segment) @next-segment
                     )
                 ]
             ]],
}

module.setup = function()
    return { success = true, requires = { "core.highlights" } }
end

module.load = function()
    local success, ts_utils = pcall(require, "nvim-treesitter.ts_utils")

    assert(success, "Unable to load nvim-treesitter.ts_utils :(")

    if module.config.public.configure_parsers then
        -- luacheck: push ignore

        local parser_configs = require("nvim-treesitter.parsers").get_parser_configs()

        parser_configs.norg = {
            install_info = module.config.public.parser_configs.norg,
        }

        parser_configs.norg_meta = {
            install_info = module.config.public.parser_configs.norg_meta,
        }

        modules.await("core.neorgcmd", function(neorgcmd)
            neorgcmd.add_commands_from_table({
                ["sync-parsers"] = {
                    args = 0,
                    name = "sync-parsers",
                },
            })
        end)

        -- luacheck: pop

        vim.api.nvim_create_autocmd("BufEnter", {
            pattern = "*.norg",
            once = true,
            callback = function()
                module.public.parser_path = vim.api.nvim_get_runtime_file("parser/norg.so", false)[1]

                if module.public.parser_path then
                    return
                end

                if module.config.public.install_parsers then
                    require("nvim-treesitter.install").commands.TSInstallSync["run!"]("norg", "norg_meta")
                    module.public.parser_path = vim.api.nvim_get_runtime_file("parser/norg.so", false)[1]
                else
                    assert(
                        false,
                        "Neorg's parser is not installed! Run `:Neorg sync-parsers` to install it, then restart Neovim."
                    )
                end
            end,
        })
    end

    module.private.ts_utils = ts_utils

    vim.keymap.set(
        "",
        "<Plug>(neorg.treesitter.next.heading)",
        lib.wrap(module.public.goto_next_query_match, module.private.heading_query)
    )
    vim.keymap.set(
        "",
        "<Plug>(neorg.treesitter.next.link)",
        lib.wrap(module.public.goto_next_query_match, module.private.link_query)
    )
    vim.keymap.set(
        "",
        "<Plug>(neorg.treesitter.previous.heading)",
        lib.wrap(module.public.goto_previous_query_match, module.private.heading_query)
    )
    vim.keymap.set(
        "",
        "<Plug>(neorg.treesitter.previous.link)",
        lib.wrap(module.public.goto_previous_query_match, module.private.link_query)
    )
end

module.config.public = {
    --- If true will auto-configure the parsers to use the recommended setup.
    --  Set to false only if you know what you're doing, or if the setting messes
    --  with your personal configuration.
    configure_parsers = true,
    --- If true will automatically install Norg parsers if they are not present.
    install_parsers = true,
    --- Configurations for each parser as required by `nvim-treesitter`.
    --  If you would like to tweak your parser configs you may do so here.
    parser_configs = {
        -- Configuration for the mainline norg parser.
        norg = {
            url = "https://github.com/nvim-neorg/tree-sitter-norg",
            files = { "src/parser.c", "src/scanner.cc" },
            branch = "main",
            revision = "6348056b999f06c2c7f43bb0a5aa7cfde5302712",
        },
        -- Configuration for the metadata parser (used to parse the contents
        -- of `@document.meta` blocks).
        norg_meta = {
            url = "https://github.com/nvim-neorg/tree-sitter-norg-meta",
            files = { "src/parser.c" },
            branch = "main",
            revision = "a479d1ca05848d0b51dd25bc9f71a17e0108b240",
        },
    },
}

---@class core.integrations.treesitter
module.public = {
    parser_path = nil,
    --- Gives back an instance of `nvim-treesitter.ts_utils`
    ---@return table #`nvim-treesitter.ts_utils`
    get_ts_utils = function()
        return module.private.ts_utils
    end,
    --- Jumps to the next match of a query in the current buffer
    ---@param query_string string Query with `@next-segment` captures
    goto_next_query_match = function(query_string)
        local cursor = vim.api.nvim_win_get_cursor(0)
        local line_number, col_number = cursor[1], cursor[2]

        local document_root = module.public.get_document_root(0)

        if not document_root then
            return
        end
        local next_match_query = utils.ts_parse_query("norg", query_string)
        for id, node in next_match_query:iter_captures(document_root, 0, line_number - 1, -1) do
            if next_match_query.captures[id] == "next-segment" then
                local start_line, start_col = node:range()
                -- start_line is 0-based; increment by one so we can compare it to the 1-based line_number
                start_line = start_line + 1

                -- Skip node if it's inside a closed fold
                if not vim.tbl_contains({ -1, start_line }, vim.fn.foldclosed(start_line)) then
                    goto continue
                end

                -- Find and go to the first matching node that starts after the current cursor position.
                if (start_line == line_number and start_col > col_number) or start_line > line_number then
                    module.private.ts_utils.goto_node(node) ---@diagnostic disable-line -- TODO: type error workaround <pysan3>
                    return
                end
            end

            ::continue::
        end
    end,
    --- Jumps to the previous match of a query in the current buffer
    ---@param query_string string Query with `@next-segment` captures
    goto_previous_query_match = function(query_string)
        local cursor = vim.api.nvim_win_get_cursor(0)
        local line_number, col_number = cursor[1], cursor[2]

        local document_root = module.public.get_document_root(0)

        if not document_root then
            return
        end
        local previous_match_query = utils.ts_parse_query("norg", query_string)
        local final_node = nil

        for id, node in previous_match_query:iter_captures(document_root, 0, 0, line_number) do
            if previous_match_query.captures[id] == "next-segment" then
                local start_line, _, _, end_col = node:range()
                -- start_line is 0-based; increment by one so we can compare it to the 1-based line_number
                start_line = start_line + 1

                -- Skip node if it's inside a closed fold
                if not vim.tbl_contains({ -1, start_line }, vim.fn.foldclosed(start_line)) then
                    goto continue
                end

                -- Find the last matching node that ends before the current cursor position.
                if start_line < line_number or (start_line == line_number and end_col < col_number) then
                    final_node = node
                end
            end

            ::continue::
        end
        if final_node then
            module.private.ts_utils.goto_node(final_node) ---@diagnostic disable-line -- TODO: type error workaround <pysan3>
        end
    end,
    ---  Gets all nodes of a given type from the AST
    ---@param node_type string #The type of node to filter out
    ---@param opts? table #A table of two options: `buf` and `ft`, for the buffer and format to use respectively.
    get_all_nodes = function(node_type, opts)
        local result = {}
        opts = opts or {}

        if not opts.buf then
            opts.buf = 0
        end

        if not opts.ft then
            opts.ft = "norg"
        end

        -- Do we need to go through each tree? lol
        vim.treesitter.get_parser(opts.buf, opts.ft):for_each_tree(function(tree)
            table.insert(result, module.public.search_tree(tree, node_type))
        end)

        return vim.iter(result):flatten():totable()
    end,

    ---Gets all nodes of a given type from the AST
    ---@param node_type string #The type of node to filter out
    ---@param path string path to the file to parse
    ---@param filetype string? file type of the file or `norg` if omitted
    get_all_nodes_in_file = function(node_type, path, filetype)
        path = vim.fs.normalize(path)
        if not filetype then
            filetype = "norg"
        end

        local contents = io.open(path, "r"):read("*a")
        local tree = vim.treesitter.get_string_parser(contents, filetype):parse()[1]
        if not (tree or tree.root) then
            return {}
        end

        return module.public.search_tree(tree, node_type)
    end,

    search_tree = function(tree, node_type)
        local result = {}
        local root = tree:root()

        --- Recursively searches for a node of a given type
        ---@param node TSNode #The starting point for the search
        local function descend(node)
            -- Iterate over all children of the node and try to match their type
            for child, _ in node:iter_children() do
                if child:type() == node_type then
                    table.insert(result, child)
                else
                    -- If no match is found try descending further down the syntax tree
                    for _, child_node in ipairs(descend(child) or {}) do
                        table.insert(result, child_node)
                    end
                end
            end
        end

        descend(root)
        return result
    end,

    --- Executes function callback on each child node of the root
    ---@param callback function
    ---@param ts_tree any #Optional syntax tree ---@diagnostic disable-line -- TODO: type error workaround <pysan3>
    tree_map = function(callback, ts_tree)
        local tree = ts_tree or vim.treesitter.get_parser(0, "norg"):parse()[1]

        local root = tree:root()

        for child, _ in root:iter_children() do
            callback(child)
        end
    end,
    --- Executes callback on each child recursive
    ---@param callback function Executes with each node as parameter, can return false to stop recursion
    ---@param ts_tree any #Optional syntax tree ---@diagnostic disable-line -- TODO: type error workaround <pysan3>
    tree_map_rec = function(callback, ts_tree)
        local tree = ts_tree or vim.treesitter.get_parser(0, "norg"):parse()[1]

        local root = tree:root()

        local function descend(start)
            for child, _ in start:iter_children() do
                local stop_descending = callback(child)
                if not stop_descending then
                    descend(child)
                end
            end
        end

        descend(root)
    end,
    get_node_text = function(node, source)
        if not node then
            return ""
        end

        -- when source is the string contents of the file
        if type(source) == "string" then
            local _, _, start_bytes = node:start()
            local _, _, end_bytes = node:end_()
            return string.sub(source, start_bytes + 1, end_bytes)
        end

        source = source or 0

        local start_row, start_col = node:start()
        local end_row, end_col = node:end_()

        local eof_row = vim.api.nvim_buf_line_count(source)

        if end_row >= eof_row then
            end_row = eof_row - 1
            end_col = -1
        end

        if start_row >= eof_row then
            return ""
        end

        local lines = vim.api.nvim_buf_get_text(source, start_row, start_col, end_row, end_col, {})

        return table.concat(lines, "\n")
    end,

    --- Get the range of a TSNode as an LspRange
    ---@param node TSNode
    ---@return lsp.Range
    node_to_lsp_range = function(node)
        local start_line, start_col, end_line, end_col = node:range()
        return {
            start = { line = start_line, character = start_col },
            ["end"] = { line = end_line, character = end_col },
        }
    end,

    --- Swap two nodes in the buffer. Ignores newlines at the end of the node
    ---@param node1 TSNode
    ---@param node2 TSNode
    ---@param bufnr number
    ---@param cursor_to_second boolean move the cursor to the start of the second node (default false)
    swap_nodes = function(node1, node2, bufnr, cursor_to_second)
        if not node1 or not node2 then
            return
        end
        local range1 = module.public.node_to_lsp_range(node1)
        local range2 = module.public.node_to_lsp_range(node2)

        local _text1 = module.public.get_node_text(node1, bufnr)
        local _text2 = module.public.get_node_text(node2, bufnr)

        if not _text1 or not _text2 then
            return
        end

        local text1 = vim.split(_text1, "\n")
        local text2 = vim.split(_text2, "\n")

        ---remove trailing blank lines from the text, and update the corresponding range appropriately
        ---@param text string[]
        ---@param range table
        local function remove_trailing_blank_lines(text, range)
            local end_line_offset = 0
            while text[#text] == "" do
                text[#text] = nil
                end_line_offset = end_line_offset + 1
            end
            range["end"] = {
                character = string.len(text[#text]),
                line = range["end"].line - end_line_offset,
            }
            if #text == 1 then -- ie. start and end lines are equal
                range["end"].character = range["end"].character + range.start.character
            end
        end

        remove_trailing_blank_lines(text1, range1)
        remove_trailing_blank_lines(text2, range2)

        local edit1 = { range = range1, newText = table.concat(text2, "\n") }
        local edit2 = { range = range2, newText = table.concat(text1, "\n") }

        vim.lsp.util.apply_text_edits({ edit1, edit2 }, bufnr, "utf-8")

        if cursor_to_second then
            -- set jump location
            vim.cmd("normal! m'")

            local char_delta = 0
            local line_delta = 0
            if
                range1["end"].line < range2.start.line
                or (range1["end"].line == range2.start.line and range1["end"].character <= range2.start.character)
            then
                line_delta = #text2 - #text1
            end

            if range1["end"].line == range2.start.line and range1["end"].character <= range2.start.character then
                if line_delta ~= 0 then
                    --- why?
                    --correction_after_line_change =  -range2.start.character
                    --text_now_before_range2 = #(text2[#text2])
                    --space_between_ranges = range2.start.character - range1["end"].character
                    --char_delta = correction_after_line_change + text_now_before_range2 + space_between_ranges
                    --- Equivalent to:
                    char_delta = #text2[#text2] - range1["end"].character

                    -- add range1.start.character if last line of range1 (now text2) does not start at 0
                    if range1.start.line == range2.start.line + line_delta then
                        char_delta = char_delta + range1.start.character
                    end
                else
                    char_delta = #text2[#text2] - #text1[#text1]
                end
            end

            vim.api.nvim_win_set_cursor(
                vim.api.nvim_get_current_win(),
                { range2.start.line + 1 + line_delta, range2.start.character + char_delta }
            )
        end
    end,

    --- Returns the first node of given type if present
    ---@deprecated use get_first_node_recursive instead
    ---@param type string #The type of node to search for
    ---@param buf number #The buffer to search in
    ---@param parent userdata #The node to start searching in
    get_first_node = function(type, buf, parent)
        if not buf then
            buf = 0
        end

        local function iterate(parent_node)
            for child, _ in parent_node:iter_children() do
                if child:type() == type then
                    return child
                end
            end
        end

        if parent then
            return iterate(parent)
        end

        vim.treesitter.get_parser(buf, "norg"):for_each_tree(function(tree)
            -- FIXME: this return value doesn't do what the original author thinks it does
            -- Iterate over all top-level children and attempt to find a match
            return iterate(tree:root()) ---@diagnostic disable-line -- TODO: type error workaround <pysan3>
        end)
    end,
    --- Recursively attempts to locate a node of a given type
    ---@param type string #The type of node to look for
    ---@param opts {buf: number?, ft: string?, parent: TSNode?} # Buffer, filetype (for TS parsing),
    ---parent, defaults to root node
    ---@return TSNode?
    get_first_node_recursive = function(type, opts)
        opts = opts or {}
        local result

        if not opts.buf then
            opts.buf = 0
        end

        if not opts.ft then
            opts.ft = "norg"
        end

        -- Do we need to go through each tree? lol
        vim.treesitter.get_parser(opts.buf, opts.ft):for_each_tree(function(tree)
            -- Get the root for that tree
            local root
            if opts.parent then
                root = opts.parent
            else
                root = tree:root()
            end

            if not root then return end

            --- Recursively searches for a node of a given type
            ---@param node TSNode #The starting point for the search
            local function descend(node)
                -- Iterate over all children of the node and try to match their type
                for child, _ in node:iter_children() do
                    if child:type() == type then
                        return child
                    else
                        -- If no match is found try descending further down the syntax tree
                        local descent = descend(child)
                        if descent then
                            return descent
                        end
                    end
                end

                return nil
            end

            result = result or descend(root)
        end)

        return result
    end,

    --- Given a node this function will break down the AST elements and return the corresponding text for certain nodes
    --- @param tag_node TSNode - a node of type tag/carryover_tag
    --- @param throw boolean - when true, throw an error instead of logging and returning on failure
    get_tag_info = function(tag_node, throw)
        if
            not tag_node
            or not vim.tbl_contains(
                { "ranged_tag", "ranged_verbatim_tag", "weak_carryover", "strong_carryover" },
                tag_node:type()
            )
        then
            return nil
        end

        local start_row, start_column, end_row, end_column = tag_node:range()

        local attributes = {}
        local resulting_name, params, content = {}, {}, {}
        local content_start_column = 0

        -- Iterate over all children of the tag node
        for child, _ in tag_node:iter_children() do
            -- If we are dealing with a weak/strong attribute set then parse that set
            if vim.endswith(child:type(), "_carryover_set") then
                for subchild in child:iter_children() do
                    if vim.endswith(subchild:type(), "_carryover") then
                        local meta = module.public.get_tag_info(subchild, throw)

                        table.insert(attributes, meta)
                    end
                end
            elseif child:type() == "tag_name" then
                -- If we're dealing with the tag name then append the text of the tag_name node to this table
                table.insert(resulting_name, vim.split(module.public.get_node_text(child), "\n")[1])
            elseif child:type() == "tag_parameters" then
                table.insert(params, vim.split(module.public.get_node_text(child), "\n")[1])
            elseif child:type() == "ranged_verbatim_tag_content" then
                -- If we're dealing with tag content then retrieve that content
                content = vim.split(module.public.get_node_text(child), "\n")
                _, content_start_column = child:range()
            end
        end

        for i, line in ipairs(content) do
            if i == 1 then
                if content_start_column < start_column then
                    local error_msg = string.format(
                        "Unable to query information about tag on line %d: content is indented less than tag start!",
                        start_row + 1
                    )

                    if throw then
                        error(error_msg)
                    else
                        log.error(error_msg)
                        return nil
                    end
                end
                content[i] = string.rep(" ", content_start_column - start_column) .. line
            else
                content[i] = line:sub(1 + start_column)
            end
        end

        content[#content] = nil

        return {
            name = table.concat(resulting_name, "."),
            parameters = params,
            content = content,
            attributes = vim.fn.reverse(attributes),
            start = { row = start_row, column = start_column },
            ["end"] = { row = end_row, column = end_column },
        }
    end,
    --- Gets the range of the given node
    ---@param node TSNode
    ---@return { row_start: number, column_start: number, row_end: number, column_end: number } range
    get_node_range = function(node)
        if not node then
            return {
                row_start = 0,
                column_start = 0,
                row_end = 0,
                column_end = 0,
            }
        end

        local rs, cs, re, ce = lib.when(type(node) == "table", function()
            local brs, bcs, _, _ = node[1]:range()
            local _, _, ere, ece = node[#node]:range()
            return brs, bcs, ere, ece
        end, function()
            local a, b, c, d = node:range()
            return a, b, c, d
        end)

        return {
            row_start = rs,
            column_start = cs,
            row_end = re,
            column_end = ce,
        }
    end,
    --- Extracts the document root from the current document or from the string
    ---@param src number|string The number of the buffer to extract or string with code (can be nil)
    ---@param filetype string? #The filetype of the buffer or the string with code
    ---@return TSNode? #The root node of the document
    get_document_root = function(src, filetype)
        filetype = filetype or "norg"

        local parser
        if type(src) == "string" then
            parser = vim.treesitter.get_string_parser(src, filetype)
        else
            parser = vim.treesitter.get_parser(src or 0, filetype)
        end

        local tree = parser:parse()[1]

        if not tree or not tree:root() then
            return
        end

        return tree:root()
    end,

    --- Attempts to find a parent of a node recursively
    ---@param node TSNode #The node to start at
    ---@param types table|string #If `types` is a table, this function will attempt to match any of the types present in the table.
    -- If the type is a string, the function will attempt to pattern match the `types` value with the node type.
    find_parent = function(node, types)
        ---@type TSNode?
        local _node = node

        while _node do
            if type(types) == "string" then
                if _node:type():match(types) then
                    return _node
                end
            elseif vim.tbl_contains(types, _node:type()) then
                return _node
            end

            _node = _node:parent()
        end
    end,

    --- Retrieves the first node at a specific line
    ---@param buf number #The buffer to search in (0 for current)
    ---@param line number #The line number (0-indexed) to get the node from the same line as `line`.
    ---@param stop_type string|table? #Don't recurse to the provided type(s)
    ---@return TSNode|nil #The first node on `line`
    get_first_node_on_line = function(buf, line, stop_type)
        if type(stop_type) == "string" then
            stop_type = { stop_type }
        end

        local document_root = module.public.get_document_root(buf)

        if not document_root then
            return
        end

        local first_char = (vim.api.nvim_buf_get_lines(buf, line, line + 1, true)[1] or ""):match("^(%s+)[^%s]")
        first_char = first_char and first_char:len() or 0

        local descendant = document_root:descendant_for_range(line, first_char, line, first_char + 1)

        if not descendant then
            return
        end

        while
            descendant:parent()
            and (descendant:parent():start()) == line
            and descendant:parent():symbol() ~= document_root:symbol() ---@diagnostic disable-line -- TODO: type error workaround <pysan3>
        do
            local parent = descendant:parent()

            if parent and stop_type and vim.tbl_contains(stop_type, parent:type()) then
                break
            end

            if not parent then return end

            descendant = parent
        end

        return descendant
    end,

    ---get document's metadata
    ---@param source number | string | PathlibPath
    ---@param no_trim boolean?
    ---@return table?
    get_document_metadata = function(source, no_trim)
        source = source or 0

        local norg_parser, iter_src = module.public.get_ts_parser(source)
        if not norg_parser then
            return
        end

        local norg_tree = norg_parser:parse()[1]
        if not norg_tree then
            return
        end

        local function trim(value)
            return no_trim and value or vim.trim(value)
        end

        local result = {}
        local function parse_data(node, src)
            return lib.match(node:type())({
                string = function()
                    return trim(module.public.get_node_text(node, src))
                end,
                number = function()
                    return tonumber(module.public.get_node_text(node, src))
                end,
                array = function()
                    local resulting_array = {}

                    for child in node:iter_children() do
                        if child:named() then
                            local parsed_data = parse_data(child, src)

                            if parsed_data then
                                table.insert(resulting_array, parsed_data)
                            end
                        end
                    end

                    return resulting_array
                end,
                object = function()
                    local resulting_object = {}

                    for child in node:iter_children() do
                        if not child:named() or child:type() ~= "pair" then
                            goto continue
                        end

                        local key = child:named_child(0)
                        local value = child:named_child(1)

                        if not key then
                            goto continue
                        end

                        local key_content = trim(module.public.get_node_text(key, src))

                        resulting_object[key_content] = (value and parse_data(value, src) or vim.NIL)

                        ::continue::
                    end

                    return resulting_object
                end,
            })
        end

        local norg_query = utils.ts_parse_query(
            "norg",
            [[
                (document
                  (ranged_verbatim_tag
                    (tag_name) @tag_name
                    (ranged_verbatim_tag_content) @tag_content
                  )
                )
            ]]
        )

        local meta_query = utils.ts_parse_query(
            "norg_meta",
            [[
                (metadata
                  (pair
                    (key) @key
                    (value) @value
                  )
                )
            ]]
        )

        local meta_node
        for id, node in norg_query:iter_captures(norg_tree:root(), iter_src) do
            if norg_query.captures[id] == "tag_name" then
                local tag_name = trim(module.public.get_node_text(node, iter_src))
                if tag_name == "document.meta" then
                    meta_node = node:next_named_sibling() or vim.NIL
                    break
                end
            end
        end

        if not meta_node then
            return result
        end

        local meta_source = module.public.get_node_text(meta_node, iter_src)

        local norg_meta_parser = vim.treesitter.get_string_parser(meta_source, "norg_meta")

        local norg_meta_tree = norg_meta_parser:parse()[1]

        if not norg_meta_tree then
            return
        end

        for id, node in meta_query:iter_captures(norg_meta_tree:root(), meta_source) do
            if meta_query.captures[id] == "key" then
                local key = trim(module.public.get_node_text(node, meta_source))

                local val
                if key == "title" then
                    -- force title's value as string type
                    val = trim(module.public.get_node_text(node:next_named_sibling(), meta_source))
                else
                    val = node:next_named_sibling() and parse_data(node:next_named_sibling(), meta_source) or vim.NIL
                end

                result[key] = val
            end
        end

        return result
    end,

    --- Parses a query and automatically executes it for Norg
    ---@param query_string string #The query string
    ---@param callback function #The callback to execute with all values returned by
    ---`Query:iter_captures()`. When callback returns true, this function returns early
    ---@param source number | string | PathlibPath #buf number, or file path or 0 for current buffer
    ---@param start number? #The start line for the query
    ---@param finish number? #The end line for the query
    execute_query = function(query_string, callback, source, start, finish)
        local query = utils.ts_parse_query("norg", query_string)
        local norg_parser, iter_src = module.public.get_ts_parser(source)

        if not norg_parser then
            return false
        end

        local root = norg_parser:parse()[1]:root()
        for id, node, metadata in query:iter_captures(root, iter_src, start, finish) do
            if callback(query, id, node, metadata) == true then
                return true
            end
        end

        return true
    end,

    ---Create a norg TS parser from the given source
    ---@param source string | number | PathlibPath file path or buf number or 0 for current buffer
    ---@return vim.treesitter.LanguageTree? norg_parser
    ---@return string | number iter_src the corresponding source that you must pass to
    ---`iter_query()`, either the full file text, or the buffer number
    get_ts_parser = function(source)
        local norg_parser
        local iter_src
        if type(source) ~= "string" and type(source) ~= "number" then
            source = tostring(source)
        end
        if type(source) == "string" then
            -- check if the file is open; use the buffer contents if it is
            if vim.fn.bufnr(source) ~= -1 then ---@diagnostic disable-line
                source = vim.uri_to_bufnr(vim.uri_from_fname(source))
            else
                iter_src = io.open(source, "r"):read("*a")
                norg_parser = vim.treesitter.get_string_parser(iter_src, "norg")
            end
        end
        if type(source) == "number" then
            if source == 0 then
                source = vim.api.nvim_get_current_buf()
            end
            norg_parser = vim.treesitter.get_parser(source, "norg")
            iter_src = source
        end

        return norg_parser, iter_src
    end,
}

-- this fixes the problem of installing neorg ts parsers on macOS without resorting to using gcc
local function install_norg_ts()
    local install = require("nvim-treesitter.install")

    if vim.fn.has("macunix") == 1 then
        -- https://github.com/nvim-neorg/tree-sitter-norg/issues/7
        -- (we have to force clang to c++11 mode on macOS manually)

        local shell = require("nvim-treesitter.shell_command_selectors")

        -- save the original functions
        local select_executable = shell.select_executable
        local compilers = install.compilers

        -- temporarily patch treesitter install logic
        local cc = "clang++ -std=c++11"
        ---@diagnostic disable-next-line: duplicate-set-field
        shell.select_executable = function(executables)
            return vim.tbl_filter(function(c) ---@param c string
                return c ~= vim.NIL and (vim.fn.executable(c) == 1 or c == cc)
            end, executables)[1]
        end
        install.compilers = { cc }

        -- install norg parsers
        local ok, err = pcall(function()
            install.commands.TSInstallSync["run!"]("norg")
        end)

        -- no matter what, restore the defaults back
        shell.select_executable = select_executable
        install.compilers = compilers

        -- if an error occurred during install, propagate it up
        if not ok then
            error(err)
        end
    else
        install.commands.TSInstallSync["run!"]("norg")
    end
end

module.on_event = function(event)
    if event.split_type[2] == "sync-parsers" then
        local ok, err = pcall(install_norg_ts)

        if not ok then
            utils.notify(string.format([[Unable to auto-install Norg parser: %s]], err), vim.log.levels.WARN)
        end

        local install = require("nvim-treesitter.install")
        install.commands.TSInstallSync["run!"]("norg_meta")
    end
end

module.events.subscribed = {
    ["core.neorgcmd"] = {
        ["sync-parsers"] = true,
    },
}

return module
