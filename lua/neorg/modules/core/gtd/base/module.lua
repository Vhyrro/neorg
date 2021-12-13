--[[
    File: Getting-Things-Done
    Title: Base module for GTD workflow
    Summary: Manages your tasks with Neorg using the Getting Things Done methodology.
    ---
GTD ("Getting Things Done") is a system designed to make collecting and executing ideas simple.
You can read more about the GTD implementation [here](https://www.ionos.com/startupguide/productivity/getting-things-done-gtd)!

It's here where the keybinds and commands are created in order to interact with GTD stuff

- Call the command `:Neorg gtd views` to nicely show your tasks and projects
- Create a new task with `:Neorg gtd capture`
- Edit the task under the cursor with `:Neorg gtd edit`
--]]

require("neorg.modules.base")
require("neorg.events")

local module = neorg.modules.create("core.gtd.base")

module.setup = function()
    return {
        success = true,
        requires = {
            "core.norg.dirman",
            "core.keybinds",
            "core.gtd.ui",
            "core.neorgcmd",
        },
    }
end

---@class core.gtd.base.config
module.config.public = {
    -- Workspace name to use for gtd related lists
    workspace = "default",
    -- Filenames to use for default lists
    default_lists = {
        inbox = "inbox.norg",
    },
    -- You can exclude files from gtd parsing by passing them here (relative file path from workspace root)
    exclude = {},

    -- The syntax to use for gtd.
    syntax = {
        context = "#contexts",
        start = "#time.start",
        due = "#time.due",
        waiting = "#waiting.for",
    },
    -- User configurations for GTD views
    displayers = {
        projects = {
            show_completed_projects = true,
            show_projects_without_tasks = true,
        },
    },
}

module.public = {
    version = "0.0.8",
}

module.private = {
    workspace_full_path = "",
}

module.load = function()
    ---@type core.norg.dirman
    ---@diagnostic disable-next-line: unused-local
    local dirman = module.required["core.norg.dirman"]
    ---@type core.keybinds
    ---@diagnostic disable-next-line: unused-local
    local keybinds = module.required["core.keybinds"]

    -- Get workspace for gtd files and save full path in private
    local workspace = module.config.public.workspace
    module.private.workspace_full_path = dirman.get_workspace(workspace)

    -- Register keybinds
    keybinds.register_keybind(module.name, "views")
    keybinds.register_keybind(module.name, "edit")
    keybinds.register_keybind(module.name, "capture")

    -- Add neorgcmd capabilities
    -- All gtd commands start with :Neorg gtd ...
    module.required["core.neorgcmd"].add_commands_from_table({
        definitions = {
            gtd = {
                views = {},
                edit = {},
                capture = {},
            },
        },
        data = {
            gtd = {
                args = 1,
                subcommands = {
                    views = { args = 0, name = "gtd.views" },
                    edit = { args = 0, name = "gtd.edit" },
                    capture = { args = 0, name = "gtd.capture" },
                },
            },
        },
    })
end

module.on_event = function(event)
    if vim.tbl_contains({ "core.keybinds", "core.neorgcmd" }, event.split_type[1]) then
        if vim.tbl_contains({ "gtd.views", "core.gtd.base.views" }, event.split_type[2]) then
            module.required["core.gtd.ui"].show_views_popup()
        elseif vim.tbl_contains({ "gtd.edit", "core.gtd.base.edit" }, event.split_type[2]) then
            module.required["core.gtd.ui"].edit_task_at_cursor()
        elseif vim.tbl_contains({ "gtd.capture", "core.gtd.base.capture" }, event.split_type[2]) then
            module.required["core.gtd.ui"].show_capture_popup()
        end
    end
end

module.events.subscribed = {
    ["core.keybinds"] = {
        ["core.gtd.base.capture"] = true,
        ["core.gtd.base.views"] = true,
        ["core.gtd.base.edit"] = true,
    },
    ["core.neorgcmd"] = {
        ["gtd.views"] = true,
        ["gtd.edit"] = true,
        ["gtd.capture"] = true,
    },
}

---@class core.gtd.base
module.public = {}

return module
