--[[
    Module for implementing todo lists.

    Available binds:
        - todo.task_done
        - todo.task_undone
        - todo.task_pending
        - todo.task_cycle

    The same as:
        ["core.norg.qol.todo_items.todo"] = {
            ["task_done"] = true
            ["task_undone"] = true
            ["task_pending"] = true
            ["task_cycle"] = true
        }
--]]

require("neorg.modules.base")

local module = neorg.modules.create("core.norg.qol.todo_items")

module.setup = function()
    return { success = true, requires = { "core.keybinds", "core.autocommands", "core.integrations.treesitter" } }
end

module.load = function()
    module.required["core.keybinds"].register_keybinds(
        module.name,
        { "todo.task_done", "todo.task_undone", "todo.task_pending", "todo.task_cycle" }
    )

    -- module.required["core.autocommands"].enable_autocommand("TextChanged")
    -- module.required["core.autocommands"].enable_autocommand("TextChangedI")
end

module.public = {
    --- Updates the parent todo item for the current todo item if it exists
    --- @param recursion_level number the index of the parent to change. The higher the number the more the code will traverse up the syntax tree.
    update_parent = function(recursion_level)
        -- Force a reparse (this is required because otherwise some cached nodes will be incorrect)
        vim.treesitter.get_parser(0, "norg"):parse()

        -- If present grab the list item that is under the cursor
        local list_node_at_cursor = module.public.get_list_item_from_cursor()

        -- If we set a recursion level then go through and traverse up the syntax tree `recursion_level` times
        for _ = 0, recursion_level do
            list_node_at_cursor = list_node_at_cursor:parent()
        end

        -- If the list node isn't present or if the list element's type isn't a todo_item then return
        if list_node_at_cursor and not list_node_at_cursor:type():match("todo_item%d") then
            return
        end

        local done_item_count = 0
        local counter = 0

        -- Go through all the children of the current todo item node and count the amount of "done" children
        for node in list_node_at_cursor:iter_children() do
            if vim.startswith(node:type(), "todo_item") then
                if node:type():match("todo_item%d") and node:named_child(1):type() == "todo_item_done" then
                    done_item_count = done_item_count + 1
                end

                counter = counter + 1
            end
        end

        -- [[
        --  Compare the counter to the amount of done items.
        --  If the counter is the same as the done item count then that means all items are complete and we should display a done item in the parent.
        --  If the done item count is 0 then no task has been completed and we should set an undone item as the parent.
        --  If all other checks fail and the done item count is less than the total number of todo items then set a pending item.
        -- ]]

        local resulting_char = ""

        if (counter - 1) == done_item_count then
            resulting_char = "x"
        elseif done_item_count == 0 then
            resulting_char = " "
        elseif done_item_count < (counter - 1) then
            resulting_char = "*"
        end

        local range = module.required["core.integrations.treesitter"].get_node_range(list_node_at_cursor)

        -- Replace the line where the todo item is situated
        local current_line = vim.fn.getline(range.row_start + 1):gsub(
            "^(%s*%-+%s+%[%s*)[x%*%s](%s*%]%s+)",
            "%1" .. resulting_char .. "%2"
        )

        vim.fn.setline(range.row_start + 1, current_line)

        module.public.update_parent(recursion_level + 1)
    end,

    --- Tries to locate a todo_item node under the cursor
    --- @return userdata nil if no such node could be found else returns the todo_item node
    get_list_item_from_cursor = function()
        local node_at_cursor = module.required["core.integrations.treesitter"].get_ts_utils().get_node_at_cursor()

        while node_at_cursor:type() ~= "document_content" and not node_at_cursor:type():match("todo_item%d") do
            node_at_cursor = node_at_cursor:parent()
        end

        if node_at_cursor:type() == "document_content" then
            log.trace("Could not find TODO item under cursor, aborting...")
            return
        end

        return node_at_cursor
    end,

    --- Converts the current node and all its children to a certain type
    --- @param node userdata the node to modify
    --- @param todo_item_type string one of "done", "pending" or "undone"
    --- @param char string the character to place within the square brackets of the todo item (one of "x", "*" or " ")
    make_all = function(node, todo_item_type, char)
        --- Returns the type of a todo item (either "done", "pending" or "undone")
        local function get_todo_item_type(todo_node)
            local todo_type = todo_node:named_child(1):type()

            return todo_type and todo_type:sub(string.len("todo_item_") + 1) or ""
        end

        if not node then
            return
        end

        local range = module.required["core.integrations.treesitter"].get_node_range(node)
        local position = range.row_start
        local type = get_todo_item_type(node)

        -- If the type of the current todo item differs from the one we want to change to then
        -- We do this because we don't want to be unnecessarily modifying a line that doesn't need changing
        if type ~= todo_item_type then
            -- 3 is the default amount of children a todo_item should have. If it has more then it has children
            -- and we should handle those too
            if node:named_child_count() <= 3 then
                local current_line = vim.fn.getline(position + 1):gsub(
                    "^(%s*%-+%s+%[%s*)[x%*%s](%s*%]%s+)",
                    "%1" .. char .. "%2"
                )

                vim.fn.setline(position + 1, current_line)
                return
            else
                local current_line = vim.fn.getline(position + 1):gsub(
                    "^(%s*%-+%s+%[%s*)[x%*%s](%s*%]%s+)",
                    "%1" .. char .. "%2"
                )

                vim.fn.setline(position + 1, current_line)

                local index = 3

                -- Go through all children and set them recursively too
                for _ = range.row_start, range.row_end, 1 do
                    local child = node:named_child(index)

                    if child then
                        module.public.make_all(child, todo_item_type, char)
                        index = index + 1
                    else
                        break
                    end
                end
            end
        end
    end,
}

module.on_event = function(event)
    local todo_str = "core.norg.qol.todo_items.todo."

    if event.split_type[1] == "core.keybinds" then
        local node_at_cursor = module.public.get_list_item_from_cursor()

        if not node_at_cursor then
            return
        end

        if event.split_type[2] == todo_str .. "task_done" then
            module.public.make_all(node_at_cursor, "done", "x")
            module.public.update_parent(0)
        elseif event.split_type[2] == todo_str .. "task_undone" then
            module.public.make_all(node_at_cursor, "undone", " ")
            module.public.update_parent(0)
        elseif event.split_type[2] == todo_str .. "task_pending" then
            module.public.make_all(node_at_cursor, "pending", "*")
        end
    elseif vim.startswith(event.type, "core.autocommands.events.textchanged") then
        -- if module.public.get_list_item_from_cursor() then
        --     module.public.update_parent(0)
        -- end
    end
end

module.events.subscribed = {
    ["core.keybinds"] = {
        ["core.norg.qol.todo_items.todo.task_done"] = true,
        ["core.norg.qol.todo_items.todo.task_undone"] = true,
        ["core.norg.qol.todo_items.todo.task_pending"] = true,
        ["core.norg.qol.todo_items.todo.task_cycle"] = true,
    },

    ["core.autocommands"] = {
        textchanged = true,
        textchangedi = true,
    },
}

return module
