local module = neorg.modules.extend("core.keybinds.keybinds")

---@class core.keybinds
module.config.public = {
    keybind_presets = {
        neorg = function(keybinds)
            local leader = keybinds.leader

            -- Map all the below keybinds only when the "norg" mode is active
            keybinds.map_event_to_mode("norg", {
                n = {
                    { "gtu", "core.qol.todo_items.warn-deprecated-keybind" },
                    { "gtp", "core.qol.todo_items.warn-deprecated-keybind" },
                    { "gtd", "core.qol.todo_items.warn-deprecated-keybind" },
                    { "gth", "core.qol.todo_items.warn-deprecated-keybind" },
                    { "gtc", "core.qol.todo_items.warn-deprecated-keybind" },
                    { "gtr", "core.qol.todo_items.warn-deprecated-keybind" },
                    { "gti", "core.qol.todo_items.warn-deprecated-keybind" },
                    { "gtu", "core.qol.todo_items.warn-deprecated-keybind" },

                    -- Marks the task under the cursor as "undone"
                    -- ^mark Task as Undone
                    { leader .. "tu", "core.qol.todo_items.todo.task_undone" },

                    -- Marks the task under the cursor as "pending"
                    -- ^mark Task as Pending
                    { leader .. "tp", "core.qol.todo_items.todo.task_pending" },

                    -- Marks the task under the cursor as "done"
                    -- ^mark Task as Done
                    { leader .. "td", "core.qol.todo_items.todo.task_done" },

                    -- Marks the task under the cursor as "on_hold"
                    -- ^mark Task as on Hold
                    { leader .. "th", "core.qol.todo_items.todo.task_on_hold" },

                    -- Marks the task under the cursor as "cancelled"
                    -- ^mark Task as Cancelled
                    { leader .. "tc", "core.qol.todo_items.todo.task_cancelled" },

                    -- Marks the task under the cursor as "recurring"
                    -- ^mark Task as Recurring
                    { leader .. "tr", "core.qol.todo_items.todo.task_recurring" },

                    -- Marks the task under the cursor as "important"
                    -- ^mark Task as Important
                    { leader .. "ti", "core.qol.todo_items.todo.task_important" },

                    -- Marks the task under the cursor as "ambiguous"
                    -- ^mark Task as ambiguous
                    { leader .. "ta", "core.qol.todo_items.todo.task_ambiguous" },

                    -- Switches the task under the cursor between a select few states
                    { "<C-Space>", "core.qol.todo_items.todo.task_cycle" },

                    -- Creates a new .norg file to take notes in
                    -- ^New Note
                    { leader .. "nn", "core.dirman.new.note" },

                    -- Hop to the destination of the link under the cursor
                    { "<CR>", "core.esupports.hop.hop-link" },
                    { "gd", "core.esupports.hop.hop-link" },
                    { "gf", "core.esupports.hop.hop-link" },
                    { "gF", "core.esupports.hop.hop-link" },

                    -- Same as `<CR>`, except opens the destination in a vertical split
                    { "<M-CR>", "core.esupports.hop.hop-link", "vsplit" },

                    { ">.", "core.promo.promote" },
                    { "<,", "core.promo.demote" },

                    { ">>", "core.promo.promote", "nested" },
                    { "<<", "core.promo.demote", "nested" },

                    { leader .. "lt", "core.pivot.toggle-list-type" },
                    { leader .. "li", "core.pivot.invert-list-type" },

                    { leader .. "id", "core.tempus.insert-date" },
                },

                i = {
                    { "<C-t>", "core.promo.promote" },
                    { "<C-d>", "core.promo.demote" },
                    { "<M-CR>", "core.itero.next-iteration" },
                    { "<M-d>", "core.tempus.insert-date-insert-mode" },
                },

                -- TODO: Readd these
                -- v = {
                --     { ">>", ":<cr><cmd>Neorg keybind all core.promo.promote_range<cr>" },
                --     { "<<", ":<cr><cmd>Neorg keybind all core.promo.demote_range<cr>" },
                -- },
            }, {
                silent = true,
                noremap = true,
            })

            -- Map the below keys only when traverse-heading mode is active
            keybinds.map_event_to_mode("traverse-heading", {
                n = {
                    -- Move to the next heading in the document
                    { "j", "core.integrations.treesitter.next.heading" },

                    -- Move to the previous heading in the document
                    { "k", "core.integrations.treesitter.previous.heading" },
                },
            }, {
                silent = true,
                noremap = true,
            })

            -- Map the below keys on presenter mode
            keybinds.map_event_to_mode("presenter", {
                n = {
                    { "<CR>", "core.presenter.next_page" },
                    { "l", "core.presenter.next_page" },
                    { "h", "core.presenter.previous_page" },

                    -- Keys for closing the current display
                    { "q", "core.presenter.close" },
                    { "<Esc>", "core.presenter.close" },
                },
            }, {
                silent = true,
                noremap = true,
                nowait = true,
            })

            -- Apply the below keys to all modes
            keybinds.map_to_mode("all", {
                n = {
                    { leader .. "mn", ":Neorg mode norg<CR>" },
                    { leader .. "mh", ":Neorg mode traverse-heading<CR>" },
                    { "gO", ":Neorg toc split<CR>" },
                },
            }, {
                silent = true,
                noremap = true,
            })
        end,
    },
}

return module
