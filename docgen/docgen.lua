local neorg = require("neorg.core")

local docgen = {}

-- Create the directory if it does not exist
docgen.output_dir = "../wiki"
docgen.static_dir = "../res/wiki/static"
pcall(vim.fn.mkdir, docgen.output_dir)

-- Copy static wiki resources into the wiki
vim.loop.fs_scandir(docgen.static_dir, function(err, handle)
    assert(handle, err) -- will not kill docgen on fail, because it is within async callback

    local name, type = vim.loop.fs_scandir_next(handle)
    while name do
        if type == "file" then
            assert(vim.loop.fs_copyfile(docgen.static_dir .. "/" .. name, docgen.output_dir .. "/" .. name))
        end
        name, type = vim.loop.fs_scandir_next(handle)
    end
end)

require("neorg").setup({
    load = {
        ["core.defaults"] = {},
        ["core.integrations.treesitter"] = {
            config = {
                configure_parsers = false,
            },
        },
    },
})

local lib, modules, utils, log = neorg.lib, neorg.modules, neorg.utils, neorg.log

-- Start neorg
neorg.org_file_entered(false)

-- Extract treesitter utility functions provided by Neorg and nvim-treesitter.ts_utils
local ts = modules.get_module("core.integrations.treesitter")
assert(ts, "treesitter not available")

--- Aggregates all the available modules.
---@return table #A list of paths to every module's `module.lua` file
docgen.aggregate_module_files = function()
    return vim.fs.find("module.lua", {
        path = "..",
        type = "file",
        limit = math.huge,
    })
end

--- Opens a file from a given path in a new buffer
---@param path string #The path of the file to open
---@return number #The buffer ID of the opened file
docgen.open_file = function(path)
    local uri = vim.uri_from_fname(path)
    local buf = vim.uri_to_bufnr(uri)

    return buf
end

--- Get the first comment (at line 0) from a module and get it's content
--- @param buf number #The buffer number to read from
--- @return table? #A table of lines
docgen.get_module_top_comment = function(buf)
    local node = ts.get_first_node_recursive("comment", { buf = buf, ft = "lua" })

    if not node then
        return
    end

    -- Verify if it's the first line
    local start_row = node:range()
    if start_row ~= 0 then
        return
    end

    local comment = vim.split(ts.get_node_text(node, buf), "\n")

    -- Stops execution if it's not a multiline comment
    if comment[1] ~= "--[[" or comment[#comment] ~= "--]]" then
        return
    end

    -- Removes first and last braces
    table.remove(comment, 1)
    table.remove(comment, #comment)

    return comment
end

---@alias TopComment { file: string, title: string, summary: string, description: string, embed: string, markdown: string[], internal: boolean }

--- Parses the top comment
---@param comment string[] #The comment
---@return TopComment #The parsed comment
docgen.parse_top_comment = function(comment)
    ---@type TopComment
    local result = {
        -- file = "",
        -- title = "",
        -- summary = "",
        markdown = {},
    }
    local can_have_options = true

    for _, line in ipairs(comment) do
        if line:match("^%s*%-%-%-%s*$") then
            can_have_options = false
        else
            local option_name, value = line:match("^%s*(%w+):%s*(.+)")

            if vim.tbl_contains({ "true", "false" }, value) then
                value = (value == "true")
            end

            if option_name and can_have_options then
                result[option_name:lower()] = value
            else
                table.insert(result.markdown, line)
            end
        end
    end

    return result
end

--- Ensures that the top comment of each Neorg module follows a certain set of rules.
---@param top_comment TopComment #The comment to check for errors
---@return string|TopComment #An error string or the comment itself
docgen.check_top_comment_integrity = function(top_comment)
    local tc = vim.tbl_deep_extend("keep", top_comment, {
        title = "",
        summary = "",
        markdown = {},
    })

    if not tc.file then
        return "no `File:` field provided."
    elseif tc.summary:sub(1, 1):upper() ~= tc.summary:sub(1, 1) then
        return "summary does not begin with a capital letter."
    elseif tc.summary:sub(tc.summary:len()) ~= "." then
        return "summary does not end with a full stop."
    elseif tc.title:find("neorg") then
        return "`neorg` written with lowercase letter. Use uppercase instead."
        -- elseif vim.tbl_isempty(tc.markdown) then
        --     return "no overview provided."
    end

    return top_comment
end

--- Retrieves the TS node corresponding to the `module.config.public` treesitter node
---@param buffer number #Buffer ID
---@param root TSNode #The root node
---@return TSNode? #The `module.config.public` node
docgen.get_module_config_node = function(buffer, root)
    local query = utils.ts_parse_query(
        "lua",
        [[
        (assignment_statement
          (variable_list) @_name
          (#eq? @_name "module.config.public")) @declaration
    ]]
    )

    local _, declaration_node = query:iter_captures(root, buffer)()

    return declaration_node and declaration_node:named_child(1):named_child(0) or nil
end

---@alias ConfigOptionData { node: TSNode, name: string, value: userdata, parents: string[] }

--- Recursively maps over each item in the `module.config.public` table,
--  invoking a callback on each run. Also descends down recursive tables.
---@param buffer number #Buffer ID
---@param start_node table #The node to start parsing
---@param callback fun(ConfigOptionData, table) #Invoked on each node with the corresponding data
---@param parents string[]? #Used internally to track nesting levels
docgen.map_config = function(buffer, start_node, callback, parents)
    parents = parents or {}

    ---@type string[]
    local comments = {}
    local index = 1

    for node in start_node:iter_children() do
        if node:type() == "comment" then
            table.insert(comments, ts.get_node_text(node, buffer))
        elseif node:type() == "field" then
            local name_node = node:field("name")[1]

            -- If a node does not have an associated name, then
            -- it's part of a list
            if name_node and name_node:type() == "string" then
                name_node = name_node:field("content")[1]
            end

            local name = name_node and ts.get_node_text(name_node, buffer) or nil
            local value = node:field("value")[1]

            -- If the right hand side of the expression is a table
            -- then go down it recursively
            if value:type() == "table_constructor" then
                callback({
                    node = node,
                    name = name,
                    value = value,
                    parents = parents,
                }, comments)

                -- The deepcopy is necessary or else
                -- the parents table would be overwritten in-place
                local copy = vim.deepcopy(parents)
                table.insert(copy, name or index)
                docgen.map_config(buffer, value, callback, copy)
            else
                callback({
                    node = node,
                    name = name,
                    value = value,
                    parents = parents,
                }, comments)
            end

            comments = {}
            index = index + 1
        else
            comments = {}
        end
    end
end

--- Goes through a table and evaluates all functions in that table, merging the
--  return values back into the original table.
---@param tbl table #Input table
---@return table #The new table
docgen.evaluate_functions = function(tbl)
    local new = {}

    lib.map(tbl, function(_, value)
        if type(value) == "function" then
            vim.list_extend(new, value())
        else
            table.insert(new, value)
        end
    end)

    return new
end

---@alias Module { top_comment_data: TopComment, buffer: number, parsed: table }
---@alias Modules { [string]: Module }

--- Returns a function which itself returns a table of links to modules
--  in a markdown-like unordered list.
---@param mods Modules #A table of modules to enumerate
---@param predicate fun(Module):boolean #A predicate that determines whether or not to render this object.
--- If the predicate returns false, then the object is dismissed.
---@return fun():string[] #An array of markdown strings with the enumerated modules
local function list_modules_with_predicate(mods, predicate)
    local sorted = lib.unroll(mods)

    table.sort(sorted, function(x, y)
        return x[1] < y[1]
    end)

    return function()
        local res = {}

        for _, kv_pair in ipairs(sorted) do
            local mod = kv_pair[1]
            local data = kv_pair[2]

            if predicate and predicate(data) then
                local insert

                if data.top_comment_data.file then
                    insert = "- [`"
                        .. data.parsed.name
                        .. "`](https://github.com/nvim-neorg/neorg/wiki/"
                        .. data.top_comment_data.file
                        .. ")"
                else
                    insert = "- `" .. mod .. "`"
                end

                if data.top_comment_data.summary then
                    insert = insert .. " - " .. data.top_comment_data.summary
                else
                    insert = insert .. " - undocumented module"
                end

                table.insert(res, insert)
            end
        end

        return res
    end
end

docgen.generators = {
    --- Generates the Home.md file
    ---@param mods Modules #A table of modules
    homepage = function(mods)
        local core_defaults = mods["core.defaults"]
        assert(core_defaults, "core.defaults module not loaded!")

        local structure = {
            '<div align="center">',
            "",
            "# Welcome to the Neorg wiki!",
            "Want to know how to properly use Neorg? Your answers are contained here.",
            "",
            "</div>",
            "",
            "# Kickstart",
            "",
            "If you would like a Neovim setup that has Neorg configured out of the box look no further than the [kickstart guide](https://github.com/nvim-neorg/neorg/wiki/Kickstart)!",
            "",
            "# Using Neorg",
            "",
            "Neorg depends on a number of other technologies, all of which have to be correctly configured to keep Neorg running smoothly.",
            "For some help on understanding how your terminal, Neovim, colourschemes, tree-sitter and more come together to produce your Neorg experience (or Neorg problems), see [this document on understanding Neorg dependencies](Dependencies).",
            "",
            "At first configuring Neorg might be rather scary. I have to define what modules I want to use in the `require('neorg').setup()` function?",
            "I don't even know what the default available values are!",
            "Don't worry, there are guides you are free to check out. The [tutorial](https://github.com/nvim-neorg/neorg/wiki/Tutorial) guides you through what Neorg is and its basics.",
            "Afterwards, feel free to check out the [configuration guide](https://github.com/nvim-neorg/neorg/wiki/Setup-Guide) as well as the [cookbook](https://github.com/nvim-neorg/neorg/wiki/Cookbook).",
            "",
            "# Broken Installation",
            "",
            "Having issues when installing Neorg, specifically past the `8.0.0` version? Check out the [following page](https://github.com/pysan3/Norg-Tutorial/blob/main/MIGRATION-v8.md) where you can troubleshoot your issue from start to finish.",
            "",
            "# Contributing to Neorg",
            "",
            "Neorg is a very big and powerful tool behind the scenes - way bigger than it may initially seem.",
            "Modules are its core foundation, and building modules is like building lego bricks to form a massive structure.",
            "There's an in-the-works tutorial dedicated to making modules [right here](https://github.com/andreadev-it/neorg-module-tutorials/blob/main/introduction.md)!",
            "",
            "# Module naming convention",
            "",
            "Neorg provides default modules, and users can extend Neorg by creating community modules.",
            "We agreed on a module naming convention, and it should be used as is.",
            "This convention should help users know at a glance what function the module serves in the grand scheme of things.",
            "- Core modules: `core.*`",
            "- Integrations with 3rd party software that are embedded in neorg: `core.integrations.*`",
            "- External modules: `external.*`",
            "- Integrations with 3rd party software that aren't embedded in neorg: `external.integrations.*`",
            "",
            "# Default Modules",
            "",
            function()
                local link = "[`core.defaults`](https://github.com/nvim-neorg/neorg/wiki/"
                    .. core_defaults.top_comment_data.file
                    .. ")"
                return {
                    "Neorg comes with some default modules that will be automatically loaded if you require the "
                        .. link
                        .. " module:",
                }
            end,
            "",
            list_modules_with_predicate(mods, function(data)
                return vim.tbl_contains(core_defaults.parsed.config.public.enable, data.parsed.name)
                    and not data.top_comment_data.internal
            end),
            "",
            "# Other Modules",
            "",
            "Some modules are not included by default as they require some manual configuration or are merely extra bells and whistles",
            "and are not critical to editing `.norg` files. Below is a list of all modules that are not required by default:",
            "",
            list_modules_with_predicate(mods, function(data)
                return not data.parsed.extension
                    and not vim.tbl_contains(core_defaults.parsed.config.public.enable, data.parsed.name)
                    and not data.top_comment_data.internal
            end),
            "",
            "# Developer modules",
            "",
            "These are modules that are only meant for developers. They are generally required in other modules:",
            "",
            list_modules_with_predicate(mods, function(data)
                return not data.parsed.extension and data.top_comment_data.internal
            end),
        }

        return docgen.evaluate_functions(structure)
    end,

    --- Generates the _Sidebar.md file
    ---@param mods Modules #A table of modules
    sidebar = function(mods)
        local structure = {
            "<div align='center'>",
            "",
            "# :star2: Neorg",
            "</div>",
            "",
            "",
            "- [Setup Guide](https://github.com/nvim-neorg/neorg/wiki/Setup-Guide)",
            "- [Tutorial](https://github.com/nvim-neorg/neorg/wiki/Tutorial)",
            "- [Default Keybinds](https://github.com/nvim-neorg/neorg/wiki/Default-Keybinds)",
            "",
            "<details>",
            "<summary><h3>Inbuilt modules:</h3></summary>",
            "",
            function()
                local res = {}
                local names = {}

                for n, data in pairs(mods) do
                    if data.parsed.extension ~= true then
                        table.insert(names, n)
                    end
                end

                table.sort(names)

                for _, name in ipairs(names) do
                    local data = mods[name]
                    if not data.parsed.internal then
                        local insert = ""
                        if data.top_comment_data.file then
                            insert = insert
                                .. "- [`"
                                .. data.parsed.name
                                .. "`](https://github.com/nvim-neorg/neorg/wiki/"
                                .. data.top_comment_data.file
                                .. ")"
                        else
                            insert = insert .. "- `" .. name .. "`"
                        end

                        table.insert(res, insert)
                    end
                end

                return res
            end,
            "",
            "</details>",
        }

        return docgen.evaluate_functions(structure)
    end,

    --- Generates the page for any Neorg module
    ---@param mods Modules #The list of currently loaded modules
    ---@param module Module #The module we want to generate the page for
    ---@param configuration string[] #An array of markdown strings detailing the configuration options for the module
    ---@return string[] #A table of markdown strings representing the page
    module = function(mods, module, configuration)
        local structure = {
            '<div align="center">',
            "",
            "# `" .. module.parsed.name .. "`",
            "",
            "### " .. (module.top_comment_data.title or ""),
            "",
            module.top_comment_data.description or "",
            "",
            module.top_comment_data.embed and ("![module-showcase](" .. module.top_comment_data.embed .. ")") or "",
            "",
            "</div>",
            "",
            function()
                if module.top_comment_data.markdown and not vim.tbl_isempty(module.top_comment_data.markdown) then
                    return vim.list_extend({
                        "# Overview",
                        "",
                    }, module.top_comment_data.markdown)
                end

                return {}
            end,
            "",
            "# Configuration",
            "",
            function()
                if vim.tbl_isempty(configuration) then
                    return {
                        "This module provides no configuration options!",
                    }
                else
                    return configuration
                end
            end,
            "",
            function()
                local required_modules = module.parsed.setup().requires or {}

                if vim.tbl_isempty(required_modules) then
                    return {}
                end

                local module_list = {}

                for _, module_name in ipairs(required_modules) do
                    module_list[module_name] = mods[module_name]
                end

                return docgen.evaluate_functions({
                    "# Dependencies",
                    "",
                    list_modules_with_predicate(module_list, function()
                        return true
                    end),
                })
            end,
            "",
            function()
                local required_by = {}

                for mod, data in pairs(mods) do
                    local required_modules = data.parsed.setup().requires or {}

                    if vim.tbl_contains(required_modules, module.parsed.name) then
                        required_by[mod] = data
                    end
                end

                if vim.tbl_isempty(required_by) then
                    return {}
                end

                return docgen.evaluate_functions({
                    "# Required By",
                    "",
                    list_modules_with_predicate(required_by, function()
                        return true
                    end),
                })
            end,
        }

        return docgen.evaluate_functions(structure)
    end,

    keybinds = function(mods, buffer)
        local keybind_data = docgen.parse_keybind_data(buffer)

        local layout = {
            '<div align="center">',
            "",
            "# :keyboard: Neorg Keybinds :keyboard:",
            "A comprehensive list of all keys available in Neorg.",
            "",
            "</div>",
            "",
            "### Further Reading",
            "",
            docgen.lookup_modules(
                mods,
                "To find out how to rebind the available keys consult the [`core.keybinds`](@core.keybinds) wiki entry."
            ),
            "",
        }

        for preset_name, preset_data in vim.spairs(keybind_data) do
            for neorg_mode_name, neorg_mode_data in vim.spairs(preset_data) do
                if neorg_mode_name == "all" then
                    table.insert(layout, string.format("## Preset `%s` // All Files", preset_name))
                    table.insert(layout, "")
                elseif neorg_mode_name == "norg" then
                    table.insert(layout, string.format("## Preset `%s` // Norg Only", preset_name))
                    table.insert(layout, "")
                end

                for mode_name, mode_data in vim.spairs(neorg_mode_data) do
                    mode_name = lib.match(mode_name)({
                        n = "Normal Mode",
                        i = "Insert Mode",
                        v = "Visual Mode",
                    })

                    table.insert(layout, "### " .. mode_name)
                    table.insert(layout, "")

                    for key, data in vim.spairs(mode_data) do
                        if not vim.tbl_isempty(data.comments) then
                            local comments = vim.iter(data.comments)
                                :map(function(comment)
                                    return (comment:gsub("^%s*%-%-%s*", ""))
                                end)
                                :totable()

                            local mnemonic = docgen.extract_mnemonic(comments)

                            local summary = comments[1]:sub(1, 1):lower() .. comments[1]:sub(2)
                            local description = vim.list_slice(comments, 2)
                            local err = docgen.check_comment_integrity(summary)

                            if err then
                                log.error("Invalid keybind description:", err)
                            end

                            table.insert(layout, "<details>")
                            table.insert(layout, "<summary>")
                            table.insert(layout, "")
                            table.insert(layout, string.format("#### `%s` - %s", key, summary))
                            table.insert(layout, "")
                            table.insert(layout, "</summary>")
                            table.insert(layout, "")
                            vim.list_extend(layout, description)
                            table.insert(layout, string.format("- Maps to: `%s`", data.rhs))
                            if mnemonic then
                                table.insert(
                                    layout,
                                    string.format("- Mnemonic: <code>%s</code>", docgen.format_mnemonic(mnemonic))
                                )
                            end
                            table.insert(layout, "")
                            table.insert(layout, "</details>")
                            table.insert(layout, "")
                        end
                    end
                end
            end
        end

        return layout
    end,
}

--- Check the integrity of the description comments found in configuration blocks
---@param comment string #The comment to check the integrity of
---@return nil|string #`nil` for success, `string` if there was an error
docgen.check_comment_integrity = function(comment)
    if comment:match("^%s*%-%-+%s*") then
        return "found leading `--` comment text."
    elseif comment:sub(1, 1):upper() ~= comment:sub(1, 1) then
        return "comment does not begin with a capital letter."
    elseif comment:find(" neorg ") then
        return "`neorg` written with lowercase letter. Use uppercase instead."
    end
end

--- Replaces all instances of a module reference (e.g. `@core.concealer`) with a link in the wiki
---@param mods Modules #The list of loaded modules
---@param str string #The string to perform the lookup in
---@return string #The original `str` parameter with all `@` references replaced with links
docgen.lookup_modules = function(mods, str)
    return (
        str:gsub("@([%-%.%w]+)", function(target_module_name)
            if not mods[target_module_name] then
                return table.concat({ "@", target_module_name })
            else
                return table.concat({
                    "https://github.com/nvim-neorg/neorg/wiki/",
                    mods[target_module_name].top_comment_data.file,
                })
            end
        end)
    )
end

--- Renders a treesitter node to a lua object
---@param node userdata #The node to render
---@param chunkname string? #The custom name to give to the chunk
---@return any #The converted object
docgen.to_lua_object = function(module, buffer, node, chunkname)
    local loaded = loadstring(table.concat({ "return ", ts.get_node_text(node, buffer) }), chunkname)

    if loaded then
        return setfenv(loaded, vim.tbl_extend("force", getfenv(0), { module = module }))()
    end
end

---@alias ConfigOptionArray { [string|number]: ConfigOptionArray, self: ConfigOption }
---@alias ConfigOption { buffer: number, data: ConfigOptionData, comments: string[], object: any }

--- Converts a ConfigOptionData struct to a html node in the resulting HTML document
---@param configuration_option ConfigOptionArray #The config option to render
---@param open boolean? #Whether to auto-open the generated `<details>` tag. Defaults to false.
---@return string[] #A list of markdown tables corresponding to the rendered element.
docgen.render = function(configuration_option, open)
    open = open or false

    local self = configuration_option.self

    local type_of_object = (function()
        local t = type(self.object)

        if t == "table" then
            return (vim.tbl_isempty(self.object) and "empty " or "")
                .. (vim.tbl_islist(self.object) and "list" or "table")
        else
            return t
        end
    end)()

    local basis = {
        "* <details" .. (open and " open>" or ">"),
        "",
        ((self.data.name or ""):match("^%s*$") and "<summary>" or table.concat({
            "<summary><h6><code>",
            self.data.name,
            "</h6></code>",
        })) .. " (" .. type_of_object .. ")</summary>",
        "",
    }

    if not vim.tbl_isempty(self.comments) then
        vim.list_extend(basis, {
            "<div>",
            "",
        })

        vim.list_extend(basis, self.comments)
        vim.list_extend(basis, {
            "",
            "</div>",
            "",
        })
    else
        vim.list_extend(basis, {
            "<br>",
            "",
        })
    end

    vim.list_extend(basis, docgen.htmlify(configuration_option))
    vim.list_extend(basis, {
        "",
        "</details>",
    })

    for i, str in ipairs(basis) do
        basis[i] = string.rep(" ", 2 - (i == 1 and 2 or 0)) .. str
    end

    return basis
end

--- Converts an object directly into HTML, with no extra fluff.
---@param configuration_option ConfigOptionArray
---@return string[] #An array of markdown strings with the rendered HTML inside
docgen.htmlify = function(configuration_option)
    local self = configuration_option.self

    local result = {}
    local code_block = true

    lib.match(self.data.value:type())({
        string = function()
            table.insert(result, table.concat({ '"', self.object, '"' }))
        end,
        table_constructor = function()
            table.insert(result, "")

            local unrolled = lib.unroll(self.object)

            table.sort(unrolled, function(x, y)
                return tostring(x[1]) < tostring(y[1])
            end)

            for _, data in ipairs(unrolled) do
                ---@type number|string
                local name_or_index = data[1]

                local subitem = configuration_option[name_or_index]

                if subitem then
                    vim.list_extend(result, docgen.render(subitem))
                end
            end

            table.insert(result, "")

            code_block = false
        end,
        function_definition = function()
            local text = ts.get_node_text(self.data.value, self.buffer):match("^function%s*(%b())")

            if not text then
                log.error(string.format("Unable to parse function, perhaps some wrong formatting?"))
                table.insert(result, "<error: incorrect formatting>")
                return
            end

            table.insert(result, "function" .. text)
        end,
        _ = function()
            table.insert(result, ts.get_node_text(self.data.value, self.buffer))
        end,
    })

    if code_block then
        table.insert(result, 1, "```lua")
        table.insert(result, "```")
    end

    return result
end

--- Parses keybind data and returns it in a readable format.
---@param buffer number The buffer ID to extract information from.
---@return table<string, table>
docgen.parse_keybind_data = function(buffer)
    local query = utils.ts_parse_query(
        "lua",
        [[
        (field
          name: (identifier) @_ident
          (#eq? @_ident "presets")) @presets
        ]]
    )

    local root = assert(vim.treesitter.get_parser(buffer, "lua"):parse()[1]:root(), "unable to parse keybinds!")

    local _, presets = query:iter_captures(root, buffer)()
    assert(presets, "could not find presets")

    local available_keys = neorg.modules.loaded_modules["core.keybinds"].private.presets

    local output = vim.defaulttable()

    for preset in presets:named_child(1):iter_children() do
        if preset:type() == "field" then
            local preset_name, preset_data =
                vim.treesitter.get_node_text(assert(preset:named_child(0)), buffer), preset:named_child(1)

            for neorg_mode in assert(preset_data):iter_children() do
                if neorg_mode:type() == "field" then
                    local neorg_mode_name, neorg_mode_data =
                        vim.treesitter.get_node_text(assert(neorg_mode:named_child(0)), buffer),
                        neorg_mode:named_child(1)

                    for neovim_mode in assert(neorg_mode_data):iter_children() do
                        if neovim_mode:type() == "field" then
                            local mode_name, mode_data =
                                vim.treesitter.get_node_text(assert(neovim_mode:named_child(0)), buffer),
                                neovim_mode:named_child(1)

                            local comments = {}
                            local i, keybind_data

                            for comment_or_data in assert(mode_data):iter_children() do
                                if comment_or_data:type() == "comment" then
                                    table.insert(
                                        comments,
                                        vim.trim(vim.treesitter.get_node_text(comment_or_data, buffer))
                                    )
                                elseif comment_or_data:type() == "field" then
                                    i, keybind_data = next(available_keys[preset_name][neorg_mode_name][mode_name], i)
                                    output[preset_name][neorg_mode_name][mode_name][keybind_data[1]] = {
                                        comments = comments,
                                        rhs = keybind_data[2],
                                    }
                                    comments = {}
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    return output
end

docgen.format_mnemonic = function(str)
    return str:gsub("([A-Z])", "<strong>%1</strong>"):lower()
end

docgen.extract_mnemonic = function(comments)
    for i, comment in ipairs(comments) do
        local mnemonic = comment:match("^%s*%^(.+)")

        if mnemonic then
            table.remove(comments, i)
            return mnemonic
        end
    end
end

return docgen
