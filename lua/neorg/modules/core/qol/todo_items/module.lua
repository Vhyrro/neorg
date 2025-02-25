--[[
    file: Todo-Items
    title: Todo Item Swiss Army Knife
    summary: Module for implementing todo lists.
    ---
This module handles the whole concept of toggling TODO items, as well as updating
parent and/or children items alongside the current item.

The following keybinds are exposed (with their default binds):
- `<Plug>(neorg.qol.todo-items.todo.task-done)` (`<LocalLeader>td`)
- `<Plug>(neorg.qol.todo-items.todo.task-undone)` (`<LocalLeader>tu`)
- `<Plug>(neorg.qol.todo-items.todo.task-pending)` (`<LocalLeader>tp`)
- `<Plug>(neorg.qol.todo-items.todo.task-on_hold)` (`<LocalLeader>th`)
- `<Plug>(neorg.qol.todo-items.todo.task-cancelled)` (`<LocalLeader>tc`)
- `<Plug>(neorg.qol.todo-items.todo.task-recurring)` (`<LocalLeader>tr`)
- `<Plug>(neorg.qol.todo-items.todo.task-important)` (`<LocalLeader>ti`)
- `<Plug>(neorg.qol.todo-items.todo.task-cycle)` (`<C-Space>`)
- `<Plug>(neorg.qol.todo-items.todo.task-cycle-reverse)` (no default keybind)

With your cursor on a line that contains an item with a TODO attribute, press
any of the above keys to toggle the state of that particular item.
Parent items of the same type and children items of the same type are update accordingly.
--]]

local neorg = require("neorg.core")
local log, modules = neorg.log, neorg.modules --[[@as neorg.modules]]

local module = modules.create("core.qol.todo_items")

module.setup = function()
    return { success = true, requires = { "core.integrations.treesitter" } }
end

module.load = function()
    for _, task in ipairs({
        "done",
        "undone",
        "pending",
        "on-hold",
        "cancelled",
        "important",
        "recurring",
        "ambiguous",
        "cycle",
        "cycle-reverse",
    }) do
        vim.keymap.set(
            "",
            string.format("<Plug>(neorg.qol.todo-items.todo.task-%s)", task),
            module.public["task-" .. task]
        )
    end
end

module.config.public = {
    -- The default order of TODO item cycling when cycling via
    -- `<C-Space>`.
    --
    -- Defaults to the following order: `undone`, `done`, `pending`.
    order = {
        { "undone", " " },
        { "done", "x" },
        { "pending", "-" },
    },

    -- The default order of TODO item cycling when the item
    -- has nested children with TODO items.
    --
    -- When cycling through TODO items with children it's not
    -- always sensible to follow the same schema as the `order` table.
    --
    -- Defaults to the following order: `undone`, `done`.
    order_with_children = {
        { "undone", " " },
        { "done", "x" },
    },

    -- When set to `true`, will automatically convert parent
    -- items to TODOs whenever a child item's TODO state is updated.
    --
    -- For instance, given the following example:
    -- ```norg
    -- - Text
    -- -- ( ) Child text
    -- ```
    --
    -- When this option is `true` and the child's state is updated to e.g.
    -- `(x)` via the `<LocaLeader>td` keybind, the new output becomes:
    -- ```norg
    -- - (x) Text
    -- -- (x) Child text
    -- ```
    create_todo_parents = false,

    -- Automatically update the parent todo state when a child node is updated.
    --
    -- eg:
    -- ```norg
    -- - ( ) parent
    -- -- ( ) child
    -- ```
    -- Marking `-- ( ) child` as done (with a keybind) will result in:
    -- ```norg
    -- - (-) parent
    -- -- (x) child
    -- ```
    update_todo_parents = true,

    -- When `true`, will automatically create a TODO extension for an item
    -- if it does not exist and an operation is performed on that item.
    --
    -- Given the following example:
    -- ```norg
    -- - Test Item
    -- ```
    -- With this option set to true, performing an operation (like pressing `<C-space>`
    -- or what have you) will convert the non-todo item into one:
    -- ```norg
    -- - ( ) Test Item
    -- ```
    create_todo_items = true,
}

---@alias TodoItemType "undone"
---|"pending"
---|"done"
---|"cancelled"
---|"recurring"
---|"on_hold"
---|"urgent"
---|"uncertain"

module.private = {
    names = {
        ["x"] = "done",
        [" "] = "undone",
        ["-"] = "pending",
        ["="] = "on_hold",
        ["_"] = "cancelled",
        ["!"] = "important",
        ["+"] = "recurring",
        ["?"] = "ambiguous",
    },
    fire_update_event = function(char, line)
        local ev =
            modules.create_event(module, module.events.defined["todo-changed"].type, { char = char, line = line })
        if ev then
            modules.broadcast_event(ev)
        end
    end,
    --- Updates the parent todo item for the current todo item if it exists
    ---@param recursion_level number the index of the parent to change. The higher the number the more the code will traverse up the syntax tree.
    update_parent = function(buf, line, recursion_level)
        -- Force a reparse (this is required because otherwise some cached nodes will be incorrect)
        vim.treesitter.get_parser(buf, "norg"):parse()

        -- If present grab the item that is under the cursor
        local item_at_cursor = module.private.get_todo_item_from_cursor(buf, line)

        if not item_at_cursor then
            return
        end

        -- If we set a recursion level then go through and traverse up the syntax tree `recursion_level` times
        for _ = 0, recursion_level do
            item_at_cursor = item_at_cursor:parent() ---@diagnostic disable-line -- TODO: type error workaround <pysan3>
        end

        -- If the final item does not exist or the target item is not a detached modifier
        -- (i.e. it does not have a "prefix" node) then it is not a node worth updating.
        if
            not item_at_cursor
            or not item_at_cursor:named_child(0)
            or not item_at_cursor:named_child(0):type():match("prefix")
        then
            return
        end

        local counts = {
            undone = 0,
            pending = 0,
            done = 0,
            cancelled = 0,
            recurring = 0,
            on_hold = 0,
            urgent = 0,
            uncertain = 0,
        }

        local counter = 0

        -- Go through all the children of the current todo item node and count the amount of "done" children
        for node in item_at_cursor:iter_children() do
            if node:named_child(1) and node:named_child(1):type() == "detached_modifier_extension" then
                for status in node:named_child(1):iter_children() do
                    if status:type():match("^todo_item_") then
                        local type = status:type():match("^todo_item_(.+)$")

                        counts[type] = counts[type] + 1

                        if type == "cancelled" then
                            break
                        end

                        counter = counter + 1
                    end
                end
            end
        end

        -- [[
        --  Compare the counter to the amount of done items.
        --  If we have even one pending item then set the resulting char to `*`
        --  If the counter is the same as the done item count then that means all items are complete and we should display a done item in the parent.
        --  If the done item count is 0 then no task has been completed and we should set an undone item as the parent.
        --  If all other checks fail and the done item count is less than the total number of todo items then set a pending item.
        -- ]]

        if counter == 0 then
            return
        end

        local resulting_char = ""

        if counts.uncertain > 0 and counts.done + counts.uncertain == counter then
            resulting_char = "="
        elseif counts.on_hold > 0 and counts.done + counts.on_hold + counts.uncertain == counter then
            resulting_char = "="
        elseif counts.pending > 0 then
            resulting_char = "-"
        elseif counter == counts.done then
            resulting_char = "x"
        elseif counts.done == 0 then
            resulting_char = " "
        elseif counts.done < counter then
            resulting_char = "-"
        end

        local first_status_extension = module.private.find_first_status_extension(item_at_cursor:named_child(1))

        -- TODO(vhyrro):
        -- Implement a toggleable behaviour where Neorg can automatically convert this:
        --     * (@ Mon 5th Feb) Test
        --     ** ( ) Test
        -- To this:
        --     * (x|@ Mon 5th Feb) Test
        --     ** (x) Test
        if not first_status_extension then
            if not module.config.public.create_todo_parents then
                return
            end

            local row, _, _, column = item_at_cursor:named_child(0):range()

            vim.api.nvim_buf_set_text(buf, row, column, row, column, { "(" .. resulting_char .. ") " })

            module.private.fire_update_event(resulting_char, row)

            module.private.update_parent(buf, line, recursion_level + 1)
            return
        end

        local range = module.required["core.integrations.treesitter"].get_node_range(first_status_extension)

        -- Replace the line where the todo item is situated
        vim.api.nvim_buf_set_text(
            buf,
            range.row_start,
            range.column_start,
            range.row_end,
            range.column_end,
            { resulting_char }
        )

        module.private.fire_update_event(resulting_char, range.row_start)

        module.private.update_parent(buf, line, recursion_level + 1)
    end,

    --- Find the first occurence of a status extension within a detached
    --  modifier extension node.
    ---@param detached_modifier_extension_node userdata #A valid node of type `detached_modifier_extension`
    find_first_status_extension = function(detached_modifier_extension_node)
        if not detached_modifier_extension_node then
            return
        end

        for status in detached_modifier_extension_node:iter_children() do ---@diagnostic disable-line -- TODO: type error workaround <pysan3>
            if vim.startswith(status:type(), "todo_item_") then
                return status
            end
        end
    end,

    --- Tries to locate a todo_item node under the cursor
    ---@return userdata? #The node if it was located, else nil
    get_todo_item_from_cursor = function(buf, line)
        local node_at_cursor = module.required["core.integrations.treesitter"].get_first_node_on_line(buf, line)

        if not node_at_cursor then
            return
        end

        -- This is done because sometimes the first node can be
        -- e.g `generic_list`, which only contains the top level list items and
        -- not their data. It doesn't cost us much to do this operation for other
        -- nodes anyway.
        if node_at_cursor:named_child(0) then
            node_at_cursor = node_at_cursor:named_child(0)
        end

        while true do
            if not node_at_cursor then
                log.trace("Could not find TODO item under cursor, aborting...")
                return
            end

            local first_named_child = node_at_cursor:named_child(0)

            if first_named_child and first_named_child:type():match("prefix") then
                break
            else
                node_at_cursor = node_at_cursor:parent()
            end
        end

        return node_at_cursor
    end,

    --- Returns the type of a todo item (either "done", "pending" or "undone")
    ---@param todo_node userdata #The todo node to extract the data from
    ---@return TodoItemType? #A todo item type as a string, else nil
    get_todo_item_type = function(todo_node)
        if not todo_node or not todo_node:named_child(1) then ---@diagnostic disable-line -- TODO: type error workaround <pysan3>
            return
        end

        local todo_type = module.private.find_first_status_extension(todo_node:named_child(1)) ---@diagnostic disable-line -- TODO: type error workaround <pysan3>

        return todo_type and todo_type:type():sub(string.len("todo_item_") + 1) or nil
    end,

    --- Converts the current node and all its children to a certain type
    ---@param buf number the current buffer number
    ---@param node userdata the node to modify
    ---@param todo_item_type TodoItemType #The todo item type as a string
    ---@param char string the character to place within the square brackets of the todo item (one of "x", "*" or " ")
    make_all = function(buf, node, todo_item_type, char)
        if not node then
            return
        end

        local type = node:type():match("^(.+)%d+$") ---@diagnostic disable-line -- TODO: type error workaround <pysan3>

        -- If the type of the current todo item differs from the one we want to change to then
        -- We do this because we don't want to be unnecessarily modifying a line that doesn't need changing
        if module.private.get_todo_item_type(node) == todo_item_type then
            return
        end

        local first_status_extension = module.private.find_first_status_extension(node:named_child(1)) ---@diagnostic disable-line -- TODO: type error workaround <pysan3>

        local parent_line
        if not first_status_extension then
            if not module.config.public.create_todo_items then
                return
            end

            local row, _, _, column = node:named_child(0):range() ---@diagnostic disable-line -- TODO: type error workaround <pysan3>

            vim.api.nvim_buf_set_text(buf, row, column, row, column, { "(" .. char .. ") " })
            parent_line = row
        else
            local range = module.required["core.integrations.treesitter"].get_node_range(first_status_extension)
            parent_line = range.row_start

            module.private.fire_update_event(char, range.row_start)

            vim.api.nvim_buf_set_text(
                buf,
                range.row_start,
                range.column_start,
                range.row_end,
                range.column_end,
                { char }
            )
        end

        if module.config.public.update_todo_parents then
            module.private.update_parent(buf, parent_line, 0)
        end

        for child in node:iter_children() do ---@diagnostic disable-line -- TODO: type error workaround <pysan3>
            if type == child:type():match("^(.+)%d+$") then
                module.private.make_all(buf, child, todo_item_type, char)
            end
        end
    end,

    task_cycle = function(buf, linenr, types, alternative_types)
        local todo_item_at_cursor = module.private.get_todo_item_from_cursor(buf, linenr - 1)

        if not todo_item_at_cursor then
            return
        end

        local todo_item_type = module.private.get_todo_item_type(todo_item_at_cursor)

        --- Gets the next item of a flat list based on the first item
        ---@param type_list table[] #A list of { "type", "char" } items
        ---@param item_type string #The `type` field from the `type_list` array
        ---@return number? #An index into the next item of `type_list`
        local function get_index(type_list, item_type)
            for i, element in ipairs(type_list) do
                if element[1] == item_type then
                    if i >= #type_list then
                        return 1
                    else
                        return i + 1
                    end
                end
            end
        end

        if not todo_item_type then
            if not module.config.public.create_todo_items then
                return
            end

            module.private.make_all(buf, todo_item_at_cursor, types[1][1], types[1][2])
            module.private.update_parent(buf, linenr - 1, 0)
            return
        end

        local index = get_index(types, todo_item_type)

        local next = types[index] or types[1]

        for child in todo_item_at_cursor:iter_children() do
            if module.private.get_todo_item_type(child) then
                next = alternative_types[get_index(alternative_types, todo_item_type)] or alternative_types[1]
                break
            end
        end

        module.private.make_all(buf, todo_item_at_cursor, next[1], next[2])
        module.private.update_parent(buf, linenr - 1, 0)
    end,
}

---Set the todo item in the given buffer at the given line
---@param buffer number 0 for current
---@param line number 1 based line number, 0 for current
---@param character string
local function task_set_at(buffer, line, character)
    local name = module.private.names[character]
    if buffer == 0 then
        buffer = vim.api.nvim_get_current_buf()
    end
    if line == 0 then
        line = vim.api.nvim_win_get_cursor(0)[1]
    end
    local todo_item_at_cursor = module.private.get_todo_item_from_cursor(buffer, line - 1)

    if not todo_item_at_cursor then
        return
    end

    module.private.make_all(buffer, todo_item_at_cursor, name, character)
end

local function task_set(character)
    return neorg.utils.wrap_dotrepeat(function()
        task_set_at(0, 0, character)
    end)
end

---@class core.qol.todo_items
module.public = {
    ["set_at"] = task_set_at,
    ["task-done"] = task_set("x"),
    ["task-undone"] = task_set(" "),
    ["task-pending"] = task_set("-"),
    ["task-on-hold"] = task_set("="),
    ["task-cancelled"] = task_set("_"),
    ["task-important"] = task_set("!"),
    ["task-recurring"] = task_set("+"),
    ["task-ambiguous"] = task_set("?"),
    ["task-cycle"] = function()
        local buffer = vim.api.nvim_get_current_buf()
        local cursor = vim.api.nvim_win_get_cursor(0)

        module.private.task_cycle(
            buffer,
            cursor[1],
            module.config.public.order,
            module.config.public.order_with_children
        )
    end,
    ["task-cycle-reverse"] = function()
        local buffer = vim.api.nvim_get_current_buf()
        local cursor = vim.api.nvim_win_get_cursor(0)

        module.private.task_cycle(
            buffer,
            cursor[1],
            vim.fn.reverse(module.config.public.order),
            vim.fn.reverse(module.config.public.order_with_children)
        )
    end,
}

module.events.defined = {
    ["todo-changed"] = modules.define_event(module, "todo-changed"),
}

return module
