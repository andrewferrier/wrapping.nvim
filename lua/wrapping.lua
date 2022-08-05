local M = {}

local OPTION_DEFAULTS = {
    softener = {
        default = 1.0,
        gitcommit = false, -- Based on https://stackoverflow.com/a/2120040/27641
    },
    create_commands = true,
    create_keymaps = true,
    auto_set_mode_heuristically = true,
    auto_set_mode_filetype_allowlist = {
        "asciidoc",
        "gitcommit",
        "mail",
        "markdown",
        "text",
        "tex",
    },
    auto_set_mode_filetype_denylist = {},
    notify_on_switch = true,
}

local VERY_LONG_TEXTWIDTH_FOR_SOFT = 999999
local opts

local function get_buf_size()
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, true)

    local count = 0
    for _, line in pairs(lines) do
        count = count + #line
    end

    return count
end

local function soft_wrap_mode_quiet()
    if vim.b.wrapmode ~= "soft" then
        -- Save prior textwidth
        vim.b.hard_textwidth = vim.api.nvim_buf_get_option(0, "textwidth")

        -- Effectively disable textwidth (setting it to 0 makes it act like 79 for gqxx)
        vim.api.nvim_buf_set_option(
            0,
            "textwidth",
            VERY_LONG_TEXTWIDTH_FOR_SOFT
        )

        vim.api.nvim_win_set_option(0, "wrap", true)

        vim.keymap.set("n", "<Up>", "g<Up>", { buffer = 0 })
        vim.keymap.set("n", "<Down>", "g<Down>", { buffer = 0 })

        vim.b.wrap_mappings_initialized = true

        vim.b.wrapmode = "soft"

        return true
    end

    return false
end

local function hard_wrap_mode_quiet()
    if vim.b.wrapmode ~= "hard" then
        if vim.b.hard_textwidth then
            vim.api.nvim_buf_set_option(0, "textwidth", vim.b.hard_textwidth)
            vim.b.hard_textwidth = nil
        end

        vim.api.nvim_win_set_option(0, "wrap", false)

        if vim.b.wrap_mappings_initialized == true then
            vim.keymap.del("n", "<Up>", { buffer = 0 })
            vim.keymap.del("n", "<Down>", { buffer = 0 })
        end
        vim.b.wrap_mappings_initialized = false

        vim.b.wrapmode = "hard"

        return true
    end

    return false
end

M.soft_wrap_mode = function()
    if soft_wrap_mode_quiet() and opts.notify_on_switch then
        vim.notify("Soft wrap mode.")
    end
end

M.hard_wrap_mode = function()
    if hard_wrap_mode_quiet() and opts.notify_on_switch then
        vim.notify("Hard wrap mode.")
    end
end

M.toggle_wrap_mode = function()
    if M.get_current_mode() == "hard" then
        soft_wrap_mode_quiet()
        if opts.notify_on_switch then
            vim.notify("Soft wrap mode.")
        end
    else
        hard_wrap_mode_quiet()
        if opts.notify_on_switch then
            vim.notify("Hard wrap mode.")
        end
    end
end

local function count_blank_lines()
    local svpos = vim.fn.winsaveview()
    vim.b.blankline_count = 0
    -- silent is needed to ensure that even if there are no matches, we don't show an error.
    vim.cmd("silent g/^\\s*$/let b:blankline_count += 1")
    vim.fn.winrestview(svpos)
    return vim.b.blankline_count
end

local function get_softener()
    local filetype = vim.api.nvim_buf_get_option(0, "filetype")
    local value = vim.tbl_get(opts.softener, filetype)

    if value ~= nil then
        return value
    else
        return opts.softener.default
    end
end

local function likely_nontextual_language()
    -- If an LSP provider supports these capabilities it's almost certainly not
    -- a textual language, and therefore we should use hard wrapping

    for _, client in pairs(vim.lsp.buf_get_clients(0)) do
        if client.definitionProvider or client.signatureHelpProvider then
            return true
        end
    end

    return false
end

local function likely_textwidth_set_deliberately()
    local textwidth_global = vim.api.nvim_get_option("textwidth")
    local textwidth_buffer = vim.api.nvim_buf_get_option(0, "textwidth")

    if textwidth_global ~= textwidth_buffer then
        -- textwidth has probably been set by a modeline, autocmd or
        -- filetype/x.{lua.vim} deliberately
        return true
    end

    return false
end

local function auto_heuristic()
    local filetype = vim.api.nvim_buf_get_option(0, "filetype")

    if vim.tbl_contains(opts.auto_set_mode_filetype_denylist, filetype) then
        return
    elseif
        vim.tbl_count(opts.auto_set_mode_filetype_denylist) > 0
        or vim.tbl_contains(opts.auto_set_mode_filetype_allowlist, filetype)
    then
        M.set_mode_heuristically()
    end
end

M.set_mode_heuristically = function()
    local buftype = vim.api.nvim_buf_get_option(0, "buftype")

    if buftype ~= "" then
        -- We shouldn't really try to handle anything that isn't a regular buffer
        return
    end

    local softener = get_softener()

    if type(softener) == "function" then
        softener = softener()
    end

    if softener == true then
        M.soft_wrap_mode()
        return
    elseif softener == false then
        M.hard_wrap_mode()
        return
    end

    if likely_nontextual_language() then
        return
    end

    if likely_textwidth_set_deliberately() then
        M.hard_wrap_mode()
        return
    end

    local hard_textwidth_for_comparison

    if vim.b.hard_textwidth then
        hard_textwidth_for_comparison = vim.b.hard_textwidth
    else
        hard_textwidth_for_comparison =
            vim.api.nvim_buf_get_option(0, "textwidth")
    end

    if hard_textwidth_for_comparison == 0 then
        -- 0 is effectively treated like 'infinite' line length. It's also the
        -- default, and many folks won't change it from that. Based upon that,
        -- we're deciding here that we are going to treat it like it is set to
        -- VERY_LONG_TEXTWIDTH_FOR_SOFT for the purposes of calculation.
        hard_textwidth_for_comparison = VERY_LONG_TEXTWIDTH_FOR_SOFT
    end

    local file_size = get_buf_size()
    local average_line_length = file_size
        / (vim.fn.line("$") - count_blank_lines())

    if (average_line_length * softener) < hard_textwidth_for_comparison then
        M.hard_wrap_mode()
    else
        M.soft_wrap_mode()
    end
end

M.get_current_mode = function()
    if vim.b.wrapmode then
        return vim.b.wrapmode
    else
        return nil
    end
end

M.setup = function(o)
    opts = vim.tbl_deep_extend("force", OPTION_DEFAULTS, o or {})

    vim.validate({
        softener = { opts.softener, "table" },
        create_commands = { opts.create_commands, "boolean" },
        create_keymaps = { opts.create_commands, "boolean" },
        auto_set_mode_heuristically = {
            opts.auto_set_mode_heuristically,
            "boolean",
        },
        auto_set_mode_filetype_allowlist = {
            opts.auto_set_mode_filetype_allowlist,
            "table",
        },
        auto_set_mode_filetype_denylist = {
            opts.auto_set_mode_filetype_denylist,
            "table",
        },
        notify_on_switch = { opts.notify_on_switch, "boolean" },
    })

    if
        vim.tbl_count(opts.auto_set_mode_filetype_allowlist) > 0
        and vim.tbl_count(opts.auto_set_mode_filetype_denylist) > 0
    then
        vim.notify(
            "wrapping.lua: both auto_set_mode_filetype_allowlist and auto_set_mode_filetype_denylist have entries; "
                .. "they are mutually exclusive and only one must be set.",
            vim.log.levels.ERROR
        )
        return
    end

    vim.opt.linebreak = true
    vim.opt.wrap = false

    if opts.create_commands then
        vim.api.nvim_create_user_command("SoftWrapMode", function()
            M.soft_wrap_mode()
        end, {
            desc = "Set wrap mode to 'soft'",
        })
        vim.api.nvim_create_user_command("HardWrapMode", function()
            M.hard_wrap_mode()
        end, {
            desc = "Set wrap mode to 'hard'",
        })
        vim.api.nvim_create_user_command("ToggleWrapMode", function()
            M.toggle_wrap_mode()
        end, {
            desc = "Toggle wrap mode",
        })
    end

    if opts.create_keymaps then
        vim.keymap.set("n", "[ow", function()
            M.soft_wrap_mode()
        end)
        vim.keymap.set("n", "]ow", function()
            M.hard_wrap_mode()
        end)
        vim.keymap.set("n", "yow", function()
            M.toggle_wrap_mode()
        end)
    end

    if opts.auto_set_mode_heuristically then
        -- We use BufWinEnter as it is fired after modelines are processed, so
        -- we can use what's in there.
        vim.api.nvim_create_autocmd("BufWinEnter", {
            group = vim.api.nvim_create_augroup("wrapping", {}),
            callback = auto_heuristic,
        })
    end
end

return M
