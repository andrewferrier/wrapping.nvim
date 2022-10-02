local M = {}

local utils = require("wrapping.utils")
local treesitter = require("wrapping.treesitter")

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
    log_path = utils.get_log_path(),
}

local VERY_LONG_TEXTWIDTH_FOR_SOFT = 999999
local opts

local function log(str)
    if opts.log_path ~= nil then
        local bufname = vim.fn.bufname()
        local datetime = os.date("%FT%H:%m:%S%z")

        if bufname == nil or bufname == "" then
            bufname = "Unknown of filetype "
                .. vim.api.nvim_buf_get_option(0, "filetype")
        end

        local fp = assert(io.open(opts.log_path, "a"))
        fp:write("[" .. datetime .. "] " .. bufname .. ": " .. str .. "\n")
        fp:close()
    end
end

local function soft_wrap_mode_quiet()
    if vim.b.wrapmode == "soft" then
        return false
    end

    -- Save prior textwidth
    vim.b.hard_textwidth = vim.api.nvim_buf_get_option(0, "textwidth")

    -- Effectively disable textwidth (setting it to 0 makes it act like 79 for gqxx)
    vim.api.nvim_buf_set_option(0, "textwidth", VERY_LONG_TEXTWIDTH_FOR_SOFT)

    vim.api.nvim_win_set_option(0, "wrap", true)

    vim.keymap.set("n", "<Up>", "g<Up>", { buffer = 0 })
    vim.keymap.set("n", "<Down>", "g<Down>", { buffer = 0 })

    vim.b.wrap_mappings_initialized = true
    vim.b.wrapmode = "soft"

    return true
end

local function hard_wrap_mode_quiet()
    if vim.b.wrapmode == "hard" then
        return false
    end

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
        M.soft_wrap_mode()
    else
        M.hard_wrap_mode()
    end
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
    log("Testing for auto heuristic...")
    local filetype = vim.api.nvim_buf_get_option(0, "filetype")
    log("Filetype: " .. filetype)

    if vim.tbl_contains(opts.auto_set_mode_filetype_denylist, filetype) then
        log("File in denylist")
        return
    elseif
        vim.tbl_count(opts.auto_set_mode_filetype_denylist) > 0
        or vim.tbl_contains(opts.auto_set_mode_filetype_allowlist, filetype)
    then
        log("About to set mode heuristically")
        M.set_mode_heuristically()
    else
        log("Skipping heuristic mode because of allow/denylist")
    end
end

M.set_mode_heuristically = function()
    local buftype = vim.api.nvim_buf_get_option(0, "buftype")

    if buftype ~= "" then
        log("Buftype is " .. buftype .. ", ignoring")
        return
    end

    local softener = get_softener()
    log("Softener is " .. vim.inspect(softener))

    if type(softener) == "function" then
        softener = softener()
    end

    if softener == true then
        log("Softener function forcing soft mode")
        M.soft_wrap_mode()
        return
    elseif softener == false then
        log("Softener function forcing hard mode")
        M.hard_wrap_mode()
        return
    end

    if likely_nontextual_language() then
        log("Likely this is a nontextual language, ignoring")
        return
    end

    if likely_textwidth_set_deliberately() then
        log("Likely that textwidth was set deliberately, forcing hard mode")
        M.hard_wrap_mode()
        return
    end

    local hard_textwidth_for_comparison

    if vim.b.hard_textwidth then
        hard_textwidth_for_comparison = vim.b.hard_textwidth
        log("Previous hard textwidth=" .. hard_textwidth_for_comparison)
    else
        hard_textwidth_for_comparison =
            vim.api.nvim_buf_get_option(0, "textwidth")
        log("Option textwidth=" .. hard_textwidth_for_comparison)
    end

    if hard_textwidth_for_comparison == 0 then
        -- 0 is effectively treated like 'infinite' line length. It's also the
        -- default, and many folks won't change it from that. Based upon that,
        -- we're deciding here that we are going to treat it like it is set to
        -- VERY_LONG_TEXTWIDTH_FOR_SOFT for the purposes of calculation.
        hard_textwidth_for_comparison = VERY_LONG_TEXTWIDTH_FOR_SOFT
        log("Forcing very long textwidth")
    end

    local tree_lines, tree_chars =
        treesitter.count_lines_of_query("(fenced_code_block) @fcb")

    local blank_lines = utils.count_blank_lines()

    log(
        "Exclusions: "
            .. tree_lines
            .. " TS lines; "
            .. tree_chars
            .. " TS chars; "
            .. blank_lines
            .. " blank lines"
    )

    local file_size = utils.get_buf_size() - tree_chars
    local average_line_length = file_size
        / (vim.fn.line("$") - blank_lines - tree_lines)

    log("Average line length: " .. vim.inspect(average_line_length))

    if (average_line_length * softener) < hard_textwidth_for_comparison then
        log("Selecting hard wrap mode")
        M.hard_wrap_mode()
    else
        log("Selecting soft wrap mode")
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
        log_path = { opts.log_path, "string" },
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
        vim.api.nvim_create_user_command("WrappingOpenLog", function()
            vim.cmd(":split " .. opts.log_path)
            vim.api.nvim_buf_set_option(0, "readonly", true)
            vim.cmd(":norm G")
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
