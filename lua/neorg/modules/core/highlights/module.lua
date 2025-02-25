--[[
    file: Core-Highlights
    title: No Colour Means no Productivity
    summary: Manages your highlight groups with this module.
    internal: true
    ---
`core.highlights` maps all possible highlight groups available throughout
Neorg under a single tree of highlights: `@neorg.*`.
--]]

local neorg = require("neorg.core")
local lib, log, modules = neorg.lib, neorg.log, neorg.modules

local module = modules.create("core.highlights")

--[[
--]]
module.config.public = {
    -- The TS highlights for each Neorg type.
    --
    -- The `highlights` table is a large collection of nested trees. At the leaves of each of these
    -- trees is the final highlight to apply to that tree. For example: `"+@comment"` tells Neorg to
    -- link to an existing highlight group `@comment` (denoted by the `+` prefix). When no prefix is
    -- found, the string is treated as arguments passed to `:highlight`, for example: `gui=bold
    -- fg=#000000`.
    --
    -- Nested trees concatenate, thus:
    -- ```lua
    -- tags = {
    --     ranged_verbatim = {
    --         begin = "+@comment",
    --     },
    -- }
    -- ```
    -- matches the highlight group:
    -- ```lua
    -- @neorg.tags.ranged_verbatim.begin
    -- ```
    -- and converts into the following command:
    -- ```vim
    -- highlight! link @neorg.tags.ranged_verbatim.begin @comment
    -- ```
    highlights = {
        -- Highlights displayed in Neorg selection window popups.
        selection_window = {
            heading = "+@annotation",
            arrow = "+@none",
            key = "+@module",
            keyname = "+@constant",
            nestedkeyname = "+@string",
        },

        -- Highlights displayed in all sorts of tag types.
        --
        -- These include: `@`, `.`, `|`, `#`, `+` and `=`.
        tags = {
            -- Highlights for the `@` verbatim tags.
            ranged_verbatim = {
                begin = "+@keyword",

                ["end"] = "+@keyword",

                name = {
                    [""] = "+@none",
                    delimiter = "+@none",
                    word = "+@keyword",
                },

                parameters = "+@type",

                document_meta = {
                    key = "+@variable.member",
                    value = "+@string",
                    number = "+@number",
                    trailing = "+@keyword.repeat",
                    title = "+@markup.heading",
                    description = "+@label",
                    authors = "+@annotation",
                    categories = "+@keyword",
                    created = "+@number.float",
                    updated = "+@number.float",
                    version = "+@number.float",

                    object = {
                        bracket = "+@punctuation.bracket",
                    },

                    array = {
                        bracket = "+@punctuation.bracket",
                        value = "+@none",
                    },
                },
            },

            -- Highlights for the carryover (`#`, `+`) tags.
            carryover = {
                begin = "+@label",

                name = {
                    [""] = "+@none",
                    word = "+@label",
                    delimiter = "+@none",
                },

                parameters = "+@string",
            },

            -- Highlights for the content of any tag named `comment`.
            --
            -- Most prominent use case is for the `#comment` carryover tag.
            comment = {
                content = "+@comment",
            },
        },

        -- Highlights for each individual heading level.
        headings = {
            ["1"] = {
                title = "+@attribute",
                prefix = "+@attribute",
            },
            ["2"] = {
                title = "+@label",
                prefix = "+@label",
            },
            ["3"] = {
                title = "+@constant",
                prefix = "+@constant",
            },
            ["4"] = {
                title = "+@string",
                prefix = "+@string",
            },
            ["5"] = {
                title = "+@label",
                prefix = "+@label",
            },
            ["6"] = {
                title = "+@constructor",
                prefix = "+@constructor",
            },
        },

        -- In case of errors in the syntax tree, use the following highlight.
        error = "+Error",

        -- Highlights for definitions (`$ Definition`).
        definitions = {
            prefix = "+@punctuation.delimiter",
            suffix = "+@punctuation.delimiter",
            title = "+@markup.strong",
            content = "+@markup.italic",
        },

        -- Highlights for footnotes (`^ My Footnote`).
        footnotes = {
            prefix = "+@punctuation.delimiter",
            suffix = "+@punctuation.delimiter",
            title = "+@markup.strong",
            content = "+@markup.italic",
        },

        -- Highlights for TODO items.
        --
        -- This strictly covers the `( )` component of any detached modifier. In other words, these
        -- highlights only bother with highlighting the brackets and the content within, but not the
        -- object containing the TODO item itself.
        todo_items = {
            undone = "+@punctuation.delimiter",
            pending = "+@module",
            done = "+@string",
            on_hold = "+@comment.note",
            cancelled = "+NonText",
            urgent = "+@comment.error",
            uncertain = "+@boolean",
            recurring = "+@keyword.repeat",
        },

        -- Highlights for all the possible levels of ordered and unordered lists.
        lists = {
            unordered = { prefix = "+@markup.list" },

            ordered = { prefix = "+@keyword.repeat" },
        },

        -- Highlights for all the possible levels of quotes.
        quotes = {
            ["1"] = {
                prefix = "+@punctuation.delimiter",
                content = "+@punctuation.delimiter",
            },
            ["2"] = {
                prefix = "+Blue",
                content = "+Blue",
            },
            ["3"] = {
                prefix = "+Yellow",
                content = "+Yellow",
            },
            ["4"] = {
                prefix = "+Red",
                content = "+Red",
            },
            ["5"] = {
                prefix = "+Green",
                content = "+Green",
            },
            ["6"] = {
                prefix = "+Brown",
                content = "+Brown",
            },
        },

        -- Highlights for the anchor syntax: `[name]{location}`.
        anchors = {
            declaration = {
                [""] = "+@markup.link.label",
                delimiter = "+NonText",
            },
            definition = {
                delimiter = "+NonText",
            },
        },

        links = {
            description = {
                [""] = "+@markup.link.url",
                delimiter = "+NonText",
            },

            file = {
                [""] = "+@comment",
                delimiter = "+NonText",
            },

            location = {
                delimiter = "+NonText",

                url = "+@markup.link.url",

                generic = {
                    [""] = "+@type",
                    prefix = "+@type",
                },

                external_file = {
                    [""] = "+@label",
                    prefix = "+@label",
                },

                marker = {
                    [""] = "+@neorg.markers.title",
                    prefix = "+@neorg.markers.prefix",
                },

                definition = {
                    [""] = "+@neorg.definitions.title",
                    prefix = "+@neorg.definitions.prefix",
                },

                footnote = {
                    [""] = "+@neorg.footnotes.title",
                    prefix = "+@neorg.footnotes.prefix",
                },

                heading = {
                    ["1"] = {
                        [""] = "+@neorg.headings.1.title",
                        prefix = "+@neorg.headings.1.prefix",
                    },

                    ["2"] = {
                        [""] = "+@neorg.headings.2.title",
                        prefix = "+@neorg.headings.2.prefix",
                    },

                    ["3"] = {
                        [""] = "+@neorg.headings.3.title",
                        prefix = "+@neorg.headings.3.prefix",
                    },

                    ["4"] = {
                        [""] = "+@neorg.headings.4.title",
                        prefix = "+@neorg.headings.4.prefix",
                    },

                    ["5"] = {
                        [""] = "+@neorg.headings.5.title",
                        prefix = "+@neorg.headings.5.prefix",
                    },

                    ["6"] = {
                        [""] = "+@neorg.headings.6.title",
                        prefix = "+@neorg.headings.6.prefix",
                    },
                },
            },
        },

        -- Highlights for inline markup.
        --
        -- This is all the highlights like `bold`, `italic` and so on.
        markup = {
            bold = {
                [""] = "+@markup.strong",
                delimiter = "+NonText",
            },
            italic = {
                [""] = "+@markup.italic",
                delimiter = "+NonText",
            },
            underline = {
                [""] = "+@markup.underline",
                delimiter = "+NonText",
            },
            strikethrough = {
                [""] = "+@markup.strikethrough",
                delimiter = "+NonText",
            },
            spoiler = {
                [""] = "+@comment.error",
                delimiter = "+NonText",
            },
            subscript = {
                [""] = "+@label",
                delimiter = "+NonText",
            },
            superscript = {
                [""] = "+@number",
                delimiter = "+NonText",
            },
            variable = {
                [""] = "+@function.macro",
                delimiter = "+NonText",
            },
            verbatim = {
                delimiter = "+NonText",
            },
            inline_comment = {
                delimiter = "+NonText",
            },
            inline_math = {
                [""] = "+@markup.math",
                delimiter = "+NonText",
            },

            free_form_delimiter = "+NonText",
        },

        -- Highlights for all the delimiter types. These include:
        -- - `---` - the weak delimiter
        -- - `===` - the strong delimiter
        -- - `___` - the horizontal rule
        delimiters = {
            strong = "+@punctuation.delimiter",
            weak = "+@punctuation.delimiter",
            horizontal_line = "+@punctuation.delimiter",
        },

        -- Inline modifiers.
        --
        -- This includes:
        -- - `~` - the trailing modifier
        -- - All link characters (`{`, `}`, `[`, `]`, `<`, `>`)
        -- - The escape character (`\`)
        modifiers = {
            link = "+NonText",
            escape = "+@type",
        },

        -- Rendered Latex, this will dictate the foreground color of math images rendered via
        -- core.math.renderer
        rendered = {
            math = "+Normal",
        },
    },

    -- Handles the dimming of certain highlight groups.
    --
    -- It sometimes is favourable to use an existing highlight group,
    -- but to dim or brighten it a little bit.
    --
    -- To do so, you may use this table, which, similarly to the `highlights` table,
    -- will concatenate nested trees to form a highlight group name.
    --
    -- The difference is, however, that the leaves of the tree are a table, not a single string.
    -- This table has three possible fields:
    -- - `reference` - which highlight to use as reference for the dimming.
    -- - `percentage` - by how much to darken the reference highlight. This value may be between
    --   `-100` and `100`, where negative percentages brighten the reference highlight, whereas
    --   positive values dim the highlight by the given percentage.
    dim = {
        tags = {
            ranged_verbatim = {
                code_block = {
                    reference = "Normal",
                    percentage = 15,
                    affect = "background",
                },
            },
        },

        markup = {
            verbatim = {
                reference = "Normal",
                percentage = 20,
            },

            inline_comment = {
                reference = "Normal",
                percentage = 40,
            },
        },
    },
}

module.setup = function()
    return { success = true, requires = { "core.autocommands" } }
end

module.load = function()
    module.required["core.autocommands"].enable_autocommand("BufEnter")
    module.required["core.autocommands"].enable_autocommand("FileType")
    module.required["core.autocommands"].enable_autocommand("ColorScheme", true)

    module.public.trigger_highlights()

    vim.api.nvim_create_autocmd({ "FileType", "ColorScheme" }, {
        callback = module.public.trigger_highlights,
    })
end

---@class core.highlights
module.public = {

    --- Reads the highlights configuration table and applies all defined highlights
    trigger_highlights = function()
        -- NOTE(vhyrro): This code was added here to work around oddities related to nvim-treesitter.
        -- This code, with modern nvim-treesitter versions, will probably not break as harshly.
        -- This code should be removed as soon as possible.
        --
        -- do
        --     local query = require("nvim-treesitter.query")

        --     if not query.has_highlights("norg") then
        --         query.invalidate_query_cache()

        --         if not query.has_highlights("norg") then
        --             log.error(
        --                 "nvim-treesitter has no available highlights for norg! Ensure treesitter is properly loaded in your config."
        --             )
        --         end
        --     end

        --     if vim.bo.filetype == "norg" then
        --         require("nvim-treesitter.highlight").attach(vim.api.nvim_get_current_buf(), "norg")
        --     end
        -- end

        --- Recursively descends down the highlight configuration and applies every highlight accordingly
        ---@param highlights table #The table of highlights to descend down
        ---@param callback fun(hl_name: string, highlight: table, prefix: string): boolean? #A callback function to be invoked for every highlight. If it returns true then we should recurse down the table tree further ---@diagnostic disable-line -- TODO: type error workaround <pysan3>
        ---@param prefix string #Should be only used by the function itself, acts as a "savestate" so the function can keep track of what path it has descended down
        local function descend(highlights, callback, prefix)
            -- Loop through every highlight defined in the provided table
            for hl_name, highlight in pairs(highlights) do
                -- If the callback returns true then descend further down the table tree
                if callback(hl_name, highlight, prefix) then
                    descend(highlight, callback, prefix .. "." .. hl_name)
                end
            end
        end

        -- Begin the descent down the public highlights configuration table
        descend(module.config.public.highlights, function(hl_name, highlight, prefix)
            -- If the type of highlight we have encountered is a table
            -- then recursively descend down it as well
            if type(highlight) == "table" then
                return true
            end

            -- Trim any potential leading and trailing whitespace
            highlight = vim.trim(highlight)

            -- Check whether we are trying to link to an existing hl group
            -- by checking for the existence of the + sign at the front
            local is_link = highlight:sub(1, 1) == "+"

            local full_highlight_name = "@neorg" .. prefix .. (hl_name:len() > 0 and ("." .. hl_name) or "")
            local does_hl_exist = lib.inline_pcall(vim.api.nvim_exec, "highlight " .. full_highlight_name, true) ---@diagnostic disable-line -- TODO: type error workaround <pysan3>

            -- If we are dealing with a link then link the highlights together (excluding the + symbol)
            if is_link then
                -- If the highlight already exists then assume the user doesn't want it to be
                -- overwritten
                if does_hl_exist and does_hl_exist:len() > 0 and not does_hl_exist:match("xxx%s+cleared") then
                    return
                end

                vim.api.nvim_set_hl(0, full_highlight_name, {
                    link = highlight:sub(2),
                })
            else -- Otherwise simply apply the highlight options the user provided
                -- If the highlight already exists then assume the user doesn't want it to be
                -- overwritten
                if does_hl_exist and does_hl_exist:len() > 0 then
                    return
                end

                -- We have to use vim.cmd here
                vim.cmd({
                    cmd = "highlight",
                    args = { full_highlight_name, highlight },
                    bang = true,
                })
            end
        end, "")

        -- Begin the descent down the dimming configuration table
        descend(module.config.public.dim, function(hl_name, highlight, prefix)
            -- If we don't have a percentage value then keep traversing down the table tree
            if not highlight.percentage then
                return true
            end

            local full_highlight_name = "@neorg" .. prefix .. (hl_name:len() > 0 and ("." .. hl_name) or "")
            local does_hl_exist = lib.inline_pcall(vim.api.nvim_exec, "highlight " .. full_highlight_name, true) ---@diagnostic disable-line -- TODO: type error workaround <pysan3>

            -- If the highlight already exists then assume the user doesn't want it to be
            -- overwritten
            if does_hl_exist and does_hl_exist:len() > 0 and not does_hl_exist:match("xxx%s+cleared") then
                return
            end

            -- Apply the dimmed highlight
            vim.api.nvim_set_hl(0, full_highlight_name, {
                [highlight.affect == "background" and "bg" or "fg"] = module.public.dim_color(
                    module.public.get_attribute(
                        highlight.reference or full_highlight_name,
                        highlight.affect or "foreground"
                    ),
                    highlight.percentage
                ),
            })
        end, "")
    end,

    --- Takes in a table of highlights and applies them to the current buffer
    ---@param highlights table #A table of highlights
    add_highlights = function(highlights)
        module.config.public.highlights =
            vim.tbl_deep_extend("force", module.config.public.highlights, highlights or {})
        module.public.trigger_highlights()
    end,

    --- Takes in a table of items to dim and applies the dimming to them
    ---@param dim table #A table of items to dim
    add_dim = function(dim)
        module.config.public.dim = vim.tbl_deep_extend("force", module.config.public.dim, dim or {})
        module.public.trigger_highlights()
    end,

    --- Assigns all Neorg* highlights to `clear`
    clear_highlights = function()
        --- Recursively descends down the highlight configuration and clears every highlight accordingly
        ---@param highlights table #The table of highlights to descend down
        ---@param prefix string #Should be only used by the function itself, acts as a "savestate" so the function can keep track of what path it has descended down
        local function descend(highlights, prefix)
            -- Loop through every defined highlight
            for hl_name, highlight in pairs(highlights) do
                -- If it is a table then recursively traverse down it!
                if type(highlight) == "table" then
                    descend(highlight, hl_name)
                else -- Otherwise we're dealing with a string
                    -- Hence we should clear the highlight
                    vim.cmd("highlight! clear Neorg" .. prefix .. hl_name)
                end
            end
        end

        -- Begin the descent
        descend(module.config.public.highlights, "")
    end,

    -- NOTE: Shamelessly taken and tweaked a little from akinsho's nvim-bufferline:
    -- https://github.com/akinsho/nvim-bufferline.lua/blob/fec44821eededceadb9cc25bc610e5114510a364/lua/bufferline/colors.lua
    -- <3
    get_attribute = function(name, attribute)
        -- Attempt to get the highlight
        local success, hl = pcall(vim.api.nvim_get_hl_by_name, name, true) ---@diagnostic disable-line -- TODO: type error workaround <pysan3>

        -- If we were successful and if the attribute exists then return it
        if success and hl[attribute] then
            return bit.tohex(hl[attribute], 6)
        else -- Else log the message in a regular info() call, it's not an insanely important error
            log.info("Unable to grab highlight for attribute", attribute, " - full error:", hl)
        end

        return "NONE"
    end,

    hex_to_rgb = function(hex_colour)
        return tonumber(hex_colour:sub(1, 2), 16), tonumber(hex_colour:sub(3, 4), 16), tonumber(hex_colour:sub(5), 16)
    end,

    dim_color = function(colour, percent)
        if colour == "NONE" then
            return colour
        end

        local function alter(attr)
            return math.floor(attr * (100 - percent) / 100)
        end

        local r, g, b = module.public.hex_to_rgb(colour)

        if not r or not g or not b then
            return "NONE"
        end

        return string.format("#%02x%02x%02x", math.min(alter(r), 255), math.min(alter(g), 255), math.min(alter(b), 255))
    end,

    -- END of shamelessly ripped off akinsho code
}

module.events.subscribed = {
    ["core.autocommands"] = {
        colorscheme = true,
        bufenter = true,
    },
}

return module
