--[[
    file: Autocommands
    summary: Handles the creation and management of Neovim's autocommands.
    description: Handles the creation and management of Neovim's autocommands.
    internal: true
    ---
This internal module exposes functionality for subscribing to autocommands and performing actions based on those autocommands.

###### NOTE: This module will be soon deprecated, and it's favourable to use the `vim.api*` functions instead.

In your `module.setup()`, make sure to require `core.autocommands` (`requires = { "core.autocommands" }`)
Afterwards in a function of your choice that gets called *after* core.autocommmands gets intialized (e.g. `load()`):

```lua
module.load = function()
    module.required["core.autocommands"].enable_autocommand("VimLeavePre") -- Substitute VimLeavePre for any valid neovim autocommand
end
```

Afterwards, be sure to subscribe to the event:

```lua
module.events.subscribed = {
    ["core.autocommands"] = {
        vimleavepre = true
    }
}
```

Upon receiving an event, it will come in this format:
```lua
{
    type = "core.autocommands.events.<name of autocommand, e.g. vimleavepre>",
    broadcast = true
}
```
--]]

local neorg = require("neorg.core")
local log, modules = neorg.log, neorg.modules

local module = modules.create("core.autocommands")

--- This function gets invoked whenever a core.autocommands enabled autocommand is triggered. Note that this function should be only used internally
---@param name string #The name of the autocommand that was just triggered
---@param triggered_from_norg boolean #If true, that means we have received this event as part of a *.norg autocommand
---@param ev? table the original event data
function _neorg_module_autocommand_triggered(name, triggered_from_norg, ev)
    local event = modules.create_event(module, name, { norg = triggered_from_norg }, ev)
    assert(event)
    modules.broadcast_event(event)
end

-- A convenience wrapper around modules.define_event_event
module.private.autocmd_base = function(name)
    return modules.define_event(module, name)
end

---@class core.autocommands
module.public = {

    --- By default, all autocommands are disabled for performance reasons. To enable them, use this command. If an invalid autocmd is given nothing happens.
    ---@param autocmd string #The relative name of the autocommand to enable
    ---@param dont_isolate boolean #Defaults to false. Specifies whether the autocommand should run globally (* instead of in Neorg files (*.norg)
    enable_autocommand = function(autocmd, dont_isolate)
        dont_isolate = dont_isolate or false

        autocmd = autocmd:lower()
        local subscribed_autocommand = module.events.subscribed["core.autocommands"][autocmd]

        local group = vim.api.nvim_create_augroup("Neorg", { clear = false })

        if subscribed_autocommand ~= nil then
            if dont_isolate and vim.fn.exists("#Neorg#" .. autocmd .. "#*") == 0 then
                vim.api.nvim_create_autocmd(autocmd, {
                    group = group,
                    callback = function(ev)
                        _neorg_module_autocommand_triggered("core.autocommands.events." .. autocmd, false, ev)
                    end,
                })
            elseif vim.fn.exists("#Neorg#" .. autocmd .. "#*.norg") == 0 then
                vim.api.nvim_create_autocmd(autocmd, {
                    pattern = "*.norg",
                    group = group,
                    callback = function(ev)
                        _neorg_module_autocommand_triggered("core.autocommands.events." .. autocmd, true, ev)
                    end,
                })
            end
            module.events.subscribed["core.autocommands"][autocmd] = true
        end
    end,

    version = "0.0.8",
}

-- All the subscribeable events for core.autocommands
module.events.subscribed = {

    ["core.autocommands"] = {

        bufadd = false,
        bufdelete = false,
        bufenter = false,
        buffilepost = false,
        buffilepre = false,
        bufhidden = false,
        bufleave = false,
        bufmodifiedset = false,
        bufnew = false,
        bufnewfile = false,
        bufreadpost = false,
        bufreadcmd = false,
        bufreadpre = false,
        bufunload = false,
        bufwinenter = false,
        bufwinleave = false,
        bufwipeout = false,
        bufwrite = false,
        bufwritecmd = false,
        bufwritepost = false,
        chaninfo = false,
        chanopen = false,
        cmdundefined = false,
        cmdlinechanged = false,
        cmdlineenter = false,
        cmdlineleave = false,
        cmdwinenter = false,
        cmdwinleave = false,
        colorscheme = false,
        colorschemepre = false,
        completechanged = false,
        completedonepre = false,
        completedone = false,
        cursorhold = false,
        cursorholdi = false,
        cursormoved = false,
        cursormovedi = false,
        diffupdated = false,
        dirchanged = false,
        fileappendcmd = false,
        fileappendpost = false,
        fileappendpre = false,
        filechangedro = false,
        exitpre = false,
        filechangedshell = false,
        filechangedshellpost = false,
        filereadcmd = false,
        filereadpost = false,
        filereadpre = false,
        filetype = false,
        filewritecmd = false,
        filewritepost = false,
        filewritepre = false,
        filterreadpost = false,
        filterreadpre = false,
        filterwritepost = false,
        filterwritepre = false,
        focusgained = false,
        focuslost = false,
        funcundefined = false,
        uienter = false,
        uileave = false,
        insertchange = false,
        insertcharpre = false,
        textyankpost = false,
        insertenter = false,
        insertleavepre = false,
        insertleave = false,
        menupopup = false,
        optionset = false,
        quickfixcmdpre = false,
        quickfixcmdpost = false,
        quitpre = false,
        remotereply = false,
        sessionloadpost = false,
        shellcmdpost = false,
        signal = false,
        shellfilterpost = false,
        sourcepre = false,
        sourcepost = false,
        sourcecmd = false,
        spellfilemissing = false,
        stdinreadpost = false,
        stdinreadpre = false,
        swapexists = false,
        syntax = false,
        tabenter = false,
        tableave = false,
        tabnew = false,
        tabnewentered = false,
        tabclosed = false,
        termopen = false,
        termenter = false,
        termleave = false,
        termclose = false,
        termresponse = false,
        textchanged = false,
        textchangedi = false,
        textchangedp = false,
        user = false,
        usergettingbored = false,
        vimenter = false,
        vimleave = false,
        vimleavepre = false,
        vimresized = false,
        vimresume = false,
        vimsuspend = false,
        winclosed = false,
        winenter = false,
        winleave = false,
        winnew = false,
        winscrolled = false,
    },
}

-- All the autocommand definitions
module.events.defined = {

    bufadd = module.private.autocmd_base("bufadd"),
    bufdelete = module.private.autocmd_base("bufdelete"),
    bufenter = module.private.autocmd_base("bufenter"),
    buffilepost = module.private.autocmd_base("buffilepost"),
    buffilepre = module.private.autocmd_base("buffilepre"),
    bufhidden = module.private.autocmd_base("bufhidden"),
    bufleave = module.private.autocmd_base("bufleave"),
    bufmodifiedset = module.private.autocmd_base("bufmodifiedset"),
    bufnew = module.private.autocmd_base("bufnew"),
    bufnewfile = module.private.autocmd_base("bufnewfile"),
    bufreadpost = module.private.autocmd_base("bufreadpost"),
    bufreadcmd = module.private.autocmd_base("bufreadcmd"),
    bufreadpre = module.private.autocmd_base("bufreadpre"),
    bufunload = module.private.autocmd_base("bufunload"),
    bufwinenter = module.private.autocmd_base("bufwinenter"),
    bufwinleave = module.private.autocmd_base("bufwinleave"),
    bufwipeout = module.private.autocmd_base("bufwipeout"),
    bufwrite = module.private.autocmd_base("bufwrite"),
    bufwritecmd = module.private.autocmd_base("bufwritecmd"),
    bufwritepost = module.private.autocmd_base("bufwritepost"),
    chaninfo = module.private.autocmd_base("chaninfo"),
    chanopen = module.private.autocmd_base("chanopen"),
    cmdundefined = module.private.autocmd_base("cmdundefined"),
    cmdlinechanged = module.private.autocmd_base("cmdlinechanged"),
    cmdlineenter = module.private.autocmd_base("cmdlineenter"),
    cmdlineleave = module.private.autocmd_base("cmdlineleave"),
    cmdwinenter = module.private.autocmd_base("cmdwinenter"),
    cmdwinleave = module.private.autocmd_base("cmdwinleave"),
    colorscheme = module.private.autocmd_base("colorscheme"),
    colorschemepre = module.private.autocmd_base("colorschemepre"),
    completechanged = module.private.autocmd_base("completechanged"),
    completedonepre = module.private.autocmd_base("completedonepre"),
    completedone = module.private.autocmd_base("completedone"),
    cursorhold = module.private.autocmd_base("cursorhold"),
    cursorholdi = module.private.autocmd_base("cursorholdi"),
    cursormoved = module.private.autocmd_base("cursormoved"),
    cursormovedi = module.private.autocmd_base("cursormovedi"),
    diffupdated = module.private.autocmd_base("diffupdated"),
    dirchanged = module.private.autocmd_base("dirchanged"),
    fileappendcmd = module.private.autocmd_base("fileappendcmd"),
    fileappendpost = module.private.autocmd_base("fileappendpost"),
    fileappendpre = module.private.autocmd_base("fileappendpre"),
    filechangedro = module.private.autocmd_base("filechangedro"),
    exitpre = module.private.autocmd_base("exitpre"),
    filechangedshell = module.private.autocmd_base("filechangedshell"),
    filechangedshellpost = module.private.autocmd_base("filechangedshellpost"),
    filereadcmd = module.private.autocmd_base("filereadcmd"),
    filereadpost = module.private.autocmd_base("filereadpost"),
    filereadpre = module.private.autocmd_base("filereadpre"),
    filetype = module.private.autocmd_base("filetype"),
    filewritecmd = module.private.autocmd_base("filewritecmd"),
    filewritepost = module.private.autocmd_base("filewritepost"),
    filewritepre = module.private.autocmd_base("filewritepre"),
    filterreadpost = module.private.autocmd_base("filterreadpost"),
    filterreadpre = module.private.autocmd_base("filterreadpre"),
    filterwritepost = module.private.autocmd_base("filterwritepost"),
    filterwritepre = module.private.autocmd_base("filterwritepre"),
    focusgained = module.private.autocmd_base("focusgained"),
    focuslost = module.private.autocmd_base("focuslost"),
    funcundefined = module.private.autocmd_base("funcundefined"),
    uienter = module.private.autocmd_base("uienter"),
    uileave = module.private.autocmd_base("uileave"),
    insertchange = module.private.autocmd_base("insertchange"),
    insertcharpre = module.private.autocmd_base("insertcharpre"),
    textyankpost = module.private.autocmd_base("textyankpost"),
    insertenter = module.private.autocmd_base("insertenter"),
    insertleavepre = module.private.autocmd_base("insertleavepre"),
    insertleave = module.private.autocmd_base("insertleave"),
    menupopup = module.private.autocmd_base("menupopup"),
    optionset = module.private.autocmd_base("optionset"),
    quickfixcmdpre = module.private.autocmd_base("quickfixcmdpre"),
    quickfixcmdpost = module.private.autocmd_base("quickfixcmdpost"),
    quitpre = module.private.autocmd_base("quitpre"),
    remotereply = module.private.autocmd_base("remotereply"),
    sessionloadpost = module.private.autocmd_base("sessionloadpost"),
    shellcmdpost = module.private.autocmd_base("shellcmdpost"),
    signal = module.private.autocmd_base("signal"),
    shellfilterpost = module.private.autocmd_base("shellfilterpost"),
    sourcepre = module.private.autocmd_base("sourcepre"),
    sourcepost = module.private.autocmd_base("sourcepost"),
    sourcecmd = module.private.autocmd_base("sourcecmd"),
    spellfilemissing = module.private.autocmd_base("spellfilemissing"),
    stdinreadpost = module.private.autocmd_base("stdinreadpost"),
    stdinreadpre = module.private.autocmd_base("stdinreadpre"),
    swapexists = module.private.autocmd_base("swapexists"),
    syntax = module.private.autocmd_base("syntax"),
    tabenter = module.private.autocmd_base("tabenter"),
    tableave = module.private.autocmd_base("tableave"),
    tabnew = module.private.autocmd_base("tabnew"),
    tabnewentered = module.private.autocmd_base("tabnewentered"),
    tabclosed = module.private.autocmd_base("tabclosed"),
    termopen = module.private.autocmd_base("termopen"),
    termenter = module.private.autocmd_base("termenter"),
    termleave = module.private.autocmd_base("termleave"),
    termclose = module.private.autocmd_base("termclose"),
    termresponse = module.private.autocmd_base("termresponse"),
    textchanged = module.private.autocmd_base("textchanged"),
    textchangedi = module.private.autocmd_base("textchangedi"),
    textchangedp = module.private.autocmd_base("textchangedp"),
    user = module.private.autocmd_base("user"),
    usergettingbored = module.private.autocmd_base("usergettingbored"),
    vimenter = module.private.autocmd_base("vimenter"),
    vimleave = module.private.autocmd_base("vimleave"),
    vimleavepre = module.private.autocmd_base("vimleavepre"),
    vimresized = module.private.autocmd_base("vimresized"),
    vimresume = module.private.autocmd_base("vimresume"),
    vimsuspend = module.private.autocmd_base("vimsuspend"),
    winclosed = module.private.autocmd_base("winclosed"),
    winenter = module.private.autocmd_base("winenter"),
    winleave = module.private.autocmd_base("winleave"),
    winnew = module.private.autocmd_base("winnew"),
    winscrolled = module.private.autocmd_base("winscrolled"),
}

module.examples = {
    ["Binding to an Autocommand"] = function()
        local mymodule = modules.create("my.module")

        mymodule.setup = function()
            return {
                success = true,
                requires = {
                    "core.autocommands", -- Be sure to require the module!
                },
            }
        end

        mymodule.load = function()
            -- Enable an autocommand (in this case InsertLeave)
            module.required["core.autocommands"].enable_autocommand("InsertLeave")
        end

        -- Listen for any incoming events
        mymodule.on_event = function(event)
            -- If it's the event we're looking for then do something!
            if event.type == "core.autocommands.events.insertleave" then
                log.warn("We left insert mode!")
            end
        end

        mymodule.events.subscribed = {
            ["core.autocommands"] = {
                insertleave = true, -- Be sure to listen in for this event!
            },
        }

        return mymodule
    end,
}

return module
