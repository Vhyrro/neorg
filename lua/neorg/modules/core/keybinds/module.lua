--[[
    file: User-Keybinds
    title: The Language of Neorg
    description: `core.keybinds` manages mappings for operations on or in `.norg` files.
    summary: Module for managing keybindings with Neorg mode support.
    ---
The keybind module acts as both an interface to the user and as an interface to other modules.
External modules can ask `core.keybinds` to reserve a specific keybind name, after which
`core.keybinds` passes control to you (the user) to specify what key this should be bound to.

### Disabling Default Keybinds
By default when you load the `core.keybinds` module all keybinds will be enabled.
If you would like to change this, be sure to set `default_keybinds` to `false`:
```lua
["core.keybinds"] = {
    config = {
        default_keybinds = false,
    }
}
```

### Changing keybinds
To change keybinds you can use the `overwrite` field in the config which is a table.
To look at the default keybinds and also the structure of this table you should refer to
[this file](https://github.com/nvim-neorg/neorg/blob/main/lua/neorg/modules/core/keybinds/keybinds.lua).
To disable a keybinding set it's value in the table to `nil` or an empty table (`{}`).
To add a new keybinding provide a function. This can either be the first value in a table
where you can also provide an `opts` field or just the value of the field directly.

If you use a string that will be interpreted as an argument to the neorg keybind command
`:Neorg keybind <mode> <the command string><CR>`.
```lua
["core.keybinds"] = {
    config = {
        overwrite = {
            norg = {
                n = {
                    -- Disable <M-CR> keybinding
                    ["<M-CR>"] = nil,

                    -- Create a new keybinding to tangle the current file
                    [",TC"] = {
                        function()
                            vim.cmd.Neorg({ args = { "tangle", "current-file" } })
                        end,
                        opts = { desc = "Tangle current file" },
                    },
                }
            }
        }
    }
}
```
--]]

local neorg = require("neorg.core")
local lib, log, modules = neorg.lib, neorg.log, neorg.modules

local module = modules.create("core.keybinds", { "keybinds" })

module.setup = function()
    return {
        success = true,
        requires = { "core.neorgcmd", "core.mode", "core.autocommands" },
    }
end

module.load = function()
    module.required["core.autocommands"].enable_autocommand("BufEnter")
    module.required["core.autocommands"].enable_autocommand("BufLeave")
    if
        module.config.public.default_keybinds
        and module.imported["core.keybinds.keybinds"].config.public.keybind_presets[module.config.public.keybind_preset]
    then
        module.private.keybinds =
            module.imported["core.keybinds.keybinds"].config.public.keybind_presets[module.config.public.keybind_preset]({
                leader = module.config.public.neorg_leader,
                overwrite = module.config.public.overwrite,
            })
    end
end

module.config.public = {
    -- Whether to use the default keybinds provided [here](https://github.com/nvim-neorg/neorg/blob/main/lua/neorg/modules/core/keybinds/keybinds.lua).
    default_keybinds = true,

    -- The prefix to use for all Neorg keybinds.
    --
    -- By default, this is the local leader key, which you must bind manually.
    neorg_leader = "<LocalLeader>",

    -- Keybinds which will be overwritten
    overwrite = {},

    -- The keybind preset to use.
    --
    -- This is only partially supported, and will be fully applicable in a future rewrite.
    -- For now it is recommended not to touch this setting.
    keybind_preset = "neorg",

    -- An array of functions, each one corresponding to a separate preset.
    --
    -- Also currently partially supported, should not be touched.
    keybind_presets = {},
}

---@class core.keybinds
module.public = {

    -- Define neorgcmd autocompletions and commands
    neorg_commands = {
        keybind = {
            min_args = 2,
            name = "core.keybinds.trigger",

            complete = {
                {},
                {},
            },
        },
    },

    version = "0.0.9",

    -- Adds a new keybind to the database of known keybinds
    -- @param module_name string #the name of the module that owns the keybind. Make sure it's an absolute path.
    -- @param name string  #the name of the keybind. The module_name will be prepended to this string to form a unique name.
    register_keybind = function(module_name, name)
        -- Create the full keybind name
        local keybind_name = module_name .. "." .. name

        -- If that keybind is not defined yet then define it
        if not module.events.defined[keybind_name] then
            module.events.defined[keybind_name] = modules.define_event(module, keybind_name)

            -- Define autocompletion for core.neorgcmd
            table.insert(module.public.neorg_commands.keybind.complete[2], keybind_name)
        end

        -- Update core.neorgcmd's internal tables
        module.required["core.neorgcmd"].add_commands_from_table(module.public.neorg_commands)
    end,

    --- Like register_keybind(), except registers a batch of them
    ---@param module_name string #The name of the module that owns the keybind. Make sure it's an absolute path.
    ---@param names any #list of strings - a list of strings detailing names of the keybinds. The module_name will be prepended to each one to form a unique name. ---@diagnostic disable-line -- TODO: type error workaround <pysan3>
    register_keybinds = function(module_name, names)
        -- Loop through each name from the names argument
        for _, name in ipairs(names) do
            -- Create the full keybind name
            local keybind_name = module_name .. "." .. name

            -- If that keybind is not defined yet then define it
            if not module.events.defined[keybind_name] then
                module.events.defined[keybind_name] = modules.define_event(module, keybind_name)

                -- Define autocompletion for core.neorgcmd
                table.insert(module.public.neorg_commands.keybind.complete[2], keybind_name)
            end
        end

        -- Update core.neorgcmd's internal tables
        module.required["core.neorgcmd"].add_commands_from_table(module.public.neorg_commands)
    end,

    bind_all = function(buf, action, for_mode)
        local current_mode = for_mode or module.required["core.mode"].get_mode()

        if
            module.config.public.default_keybinds
            and module.imported["core.keybinds.keybinds"].config.public.keybind_presets[module.config.public.keybind_preset]
        then
            for neorg_mode, neovim_modes in pairs(module.private.keybinds) do
                if neorg_mode == "all" or neorg_mode == current_mode then
                    for mode, keys in pairs(neovim_modes) do
                        for key, data in pairs(keys) do
                            local ok, error = pcall(function()
                                if data == nil or #data == 0 then
                                    return
                                end
                                local rhs
                                if type(data) == "function" then
                                    rhs = data
                                elseif type(data) == "string" then
                                    rhs = data
                                elseif type(data) == "table" then
                                    rhs = data[1]
                                end
                                if type(rhs) == "string" and type(data) == "table" then
                                    rhs = function()
                                        vim.api.nvim_cmd({
                                            cmd = "Neorg",
                                            args = vim.list_extend({
                                                "keybind",
                                                neorg_mode,
                                            }, vim.list_slice(data, 1)),
                                        }, {})
                                    end
                                end
                                if action then
                                    action(buf, mode, key, rhs, data.opts or {})
                                else
                                    local opts = data.opts or {}
                                    opts.buffer = buf

                                    if opts.desc and not vim.startswith(opts.desc, "[neorg]") then
                                        opts.desc = "[neorg] " .. opts.desc
                                    end

                                    vim.keymap.set(mode, key, rhs, opts)
                                end
                            end)

                            if not ok then
                                log.trace(
                                    string.format(
                                        "An error occurred when trying to bind key '%s' in mode '%s' in neorg mode '%s' - %s",
                                        key,
                                        mode,
                                        current_mode,
                                        error
                                    )
                                )
                            end
                        end
                    end
                end
            end
        end
    end,

    --- Updates the list of known modes and keybinds for easy autocompletion. Invoked automatically during neorg_post_load().
    sync = function()
        -- Update the first parameter with the new list of modes
        -- NOTE(vhyrro): Is there a way to prevent copying? Can you "unbind" a reference to a table?
        module.public.neorg_commands.keybind.complete[1] = vim.deepcopy(module.required["core.mode"].get_modes())
        table.insert(module.public.neorg_commands.keybind.complete[1], "all")

        -- Update core.neorgcmd's internal tables
        module.required["core.neorgcmd"].add_commands_from_table(module.public.neorg_commands)
    end,
}

module.private = {
    keybinds = {},
}

module.neorg_post_load = module.public.sync

module.on_event = function(event)
    lib.match(event.type)({
        ["core.neorgcmd.events.core.keybinds.trigger"] = function()
            -- Query the current mode and the expected mode (the one passed in by the user)
            local expected_mode = event.content[1]
            local current_mode = module.required["core.mode"].get_mode()

            -- If the modes don't match then don't execute the keybind
            if expected_mode ~= current_mode and expected_mode ~= "all" then
                return
            end

            -- Get the event path to the keybind
            local keybind_event_path = event.content[2]

            -- If it is defined then broadcast the event
            if module.events.defined[keybind_event_path] then
                modules.broadcast_event(
                    modules.create_event(
                        module,
                        "core.keybinds.events." .. keybind_event_path,
                        vim.list_slice(event.content, 3)
                    )
                )
            else -- Otherwise throw an error
                log.error("Unable to trigger keybind", keybind_event_path, "- the keybind does not exist")
            end
        end,
        ["core.mode.events.mode_created"] = neorg.lib.wrap(module.public.sync),
        ["core.mode.events.mode_set"] = function()
            -- If a new mode has been set then reset all of our keybinds
            module.public.bind_all(event.buffer, function(buf, mode, key)
                vim.api.nvim_buf_del_keymap(buf, mode, key)
            end, event.content.current)
            module.public.bind_all(event.buffer)
        end,
        ["core.autocommands.events.bufenter"] = function()
            if not event.content.norg then
                return
            end

            -- If a new mode has been set then reset all of our keybinds
            module.public.bind_all(event.buffer, function(buf, mode, key)
                vim.api.nvim_buf_del_keymap(buf, mode, key)
            end, module.required["core.mode"].get_previous_mode())
            module.public.bind_all(event.buffer)
        end,
    })
end

module.events.defined = {
    enable_keybinds = modules.define_event(module, "enable_keybinds"),
}

module.events.subscribed = {
    ["core.neorgcmd"] = {
        ["core.keybinds.trigger"] = true,
    },

    ["core.autocommands"] = {
        bufenter = true,
        bufleave = true,
    },

    ["core.mode"] = {
        mode_created = true,
        mode_set = true,
    },
}

module.examples = {
    ["Create keybinds in your module"] = function()
        -- The process of defining a keybind is only a tiny bit more involved than defining e.g. an autocommand. Let's see what differs in creating a keybind rather than creating an autocommand:
        local test = modules.create("test.module")

        test.setup = function()
            return { success = true, requires = { "core.keybinds" } } -- Require the keybinds module
        end

        test.load = function()
            module.required["core.keybinds"].register_keybind(test.name, "my_keybind")

            -- It is also possible to mass initialize keybindings via the public register_keybinds function. It can be used like so:
            -- This should stop redundant calls to the same function or loops within module code.
            module.required["core.keybinds"].register_keybinds(test.name, { "second_keybind", "my_other_keybind" })
        end

        test.on_event = function(event)
            -- The event.split_type field is the type field except split into two.
            -- The split point is .events., meaning if the event type is e.g. "core.keybinds.events.test.module.my_keybind" the value of split_type will be { "core.keybinds", "test.module.my_keybind" }.
            if event.split_type[2] == "test.module.my_keybind" then
                log.info("Keybind my_keybind has been pressed!")
            end
        end

        test.events.subscribed = {

            ["core.keybinds"] = {
                -- The event path is a bit different here than it is normally.
                -- Whenever you receive an event, you're used to the path looking like this: <module_path>.events.<event_name>.
                -- Here, however, the path looks like this: <module_path>.events.test.module.<event_name>.
                -- Why is that? Well, the module operates a bit differently under the hood.
                -- In order to create a unique name for every keybind we use the module's name as well.
                -- Meaning if your module is called test.module you will receive an event of type <module_path>.events.test.module.<event_name>.
                ["test.module.my_keybind"] = true, -- Subscribe to the event
            },
        }
    end,

    ["Attach some keys to the create keybind"] = function()
        -- To invoke a keybind, we can then use :Neorg keybind norg test.module.my_keybind.
        -- :Neorg keybind tells core.neorgcmd to invoke a keybind, and the next argument (norg) is the mode that the keybind should be executed in.
        -- Modes are a way to isolate different parts of the neorg environment easily, this includes keybinds too.
        -- core.mode, the module designed to manage modes, is explaned in this own page (see the wiki sidebar).
        -- Just know that by default neorg launches into the norg mode, so you'd most likely want to bind to that.
        -- After the mode you can find the path to the keybind we want to trigger. Soo let's bind it! You should have already read the user keybinds document that details where and how to bind keys, the below code snippet is an extension of that:

        -- (Somewhere in your config)
        -- Require the user callbacks module, which allows us to tap into the core of Neorg
        local neorg_callbacks = require("neorg.callbacks")

        -- Listen for the enable_keybinds event, which signals a "ready" state meaning we can bind keys.
        -- This hook will be called several times, e.g. whenever the Neorg Mode changes or an event that
        -- needs to reevaluate all the bound keys is invoked
        neorg_callbacks.on_event("core.keybinds.events.enable_keybinds", function(_, keybinds)
            -- All your other keybinds

            -- Map all the below keybinds only when the "norg" mode is active
            keybinds.map_event_to_mode("norg", {
                n = {
                    { "<Leader>o", "test.module.my_keybind" },
                },
            }, { silent = true, noremap = true })
        end)

        -- To change the current mode as a user of neorg you can run :Neorg set-mode <mode>.
        -- If you try changing the current mode into a non-existent mode (like :Neorg set-mode a-nonexistent-mode) you will see that all the keybinds you bound to the norg mode won't work anymore!
        -- They'll start working again if you reset the mode back via :Neorg set-mode norg.
    end,
}

return module
