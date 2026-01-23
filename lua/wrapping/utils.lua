local M = {}

---@return integer
M.get_buf_size = function()
    local lcount = vim.api.nvim_buf_line_count(0)
    return vim.fn.line2byte(lcount + 1) - 1 - lcount
end

-- FIXME: There may be a more efficient way to do this
---@return integer
M.count_blank_lines = function()
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, true)

    local count = 0
    for _, line in pairs(lines) do
        if string.match(line, "^%s*$") then
            count = count + 1
        end
    end

    return count
end

---@return string
M.get_log_path = function()
    return vim.fn.stdpath("log") .. "/wrapping.nvim.log"
end

return M
