local M = {}

vim.o.hidden = true
vim.o.swapfile = false

local wrapping = require("wrapping")

M.set_lines = function(lines)
    vim.cmd("new")
    vim.cmd("only")
    vim.api.nvim_buf_set_lines(0, 0, -1, true, lines)
end

M.setup = function(o)
    local opts = vim.tbl_deep_extend("keep", o or {}, {
        auto_set_mode_heuristically = false,
        notify_on_switch = false,
    })

    wrapping.setup(opts)
end

M.teardown = function()
    -- Try to delete default keymaps (they may not exist if create_keymaps was false)
    pcall(vim.keymap.del, "n", "yow")
    pcall(vim.keymap.del, "n", "[ow")
    pcall(vim.keymap.del, "n", "]ow")

    -- Try to delete <Plug> mappings (use pcall in case setup() failed or wasn't called)
    pcall(vim.keymap.del, "n", "<Plug>(wrapping-soft-wrap-mode)")
    pcall(vim.keymap.del, "n", "<Plug>(wrapping-hard-wrap-mode)")
    pcall(vim.keymap.del, "n", "<Plug>(wrapping-toggle-wrap-mode)")
end

return M
