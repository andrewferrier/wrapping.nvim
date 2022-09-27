local M = {}

local wrapping = require("wrapping")

M.set_lines = function(lines)
    vim.cmd('new')
    vim.cmd('only')
    vim.api.nvim_buf_set_lines(0, 0, -1, true, lines)
end

M.setup = function(o)
    local opts = vim.tbl_deep_extend("keep", o or {}, {
        auto_set_mode_heuristically = false,
        notify_on_switch = false,
    })

    wrapping.setup(opts)
end


return M
