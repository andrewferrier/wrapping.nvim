local M = {}

-- FIXME: There may be a more efficient way to do this
M.get_buf_size = function()
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, true)

    local count = 0
    for _, line in pairs(lines) do
        count = count + #line
    end

    return count
end

-- FIXME: There may be a more efficient way to do this
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

M.get_log_path = function()
    local log_path = vim.fn.stdpath("log")
    local LOG_SUFFIX = "/wrapping.nvim.log"

    if log_path ~= nil then
        return log_path .. LOG_SUFFIX
    else
        return vim.fn.stdpath("cache") .. LOG_SUFFIX
    end
end

return M
