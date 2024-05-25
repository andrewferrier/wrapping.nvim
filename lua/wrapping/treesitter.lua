local M = {}

---@param module_name string
local function try_to_load(module_name)
    local function requiref(module)
        require(module)
    end

    local ts_utils_test = pcall(requiref, module_name)

    if not ts_utils_test then
        return nil
    else
        return require(module_name)
    end
end

-- FIXME: This is technically inaccurate right now as it only looks at lines and
-- not starting/ending chars
---@param start_line integer
---@param end_line integer
local function get_character_count(start_line, end_line)
    local lines = vim.api.nvim_buf_get_lines(0, start_line, end_line, true)

    local count = 0
    for _, line in pairs(lines) do
        count = count + #line
    end

    return count
end

---@param language string
---@param query string
---@return integer, integer
M.count_lines_of_query = function(language, query)
    local total_lines = 0
    local total_chars = 0

    local parsers = try_to_load("nvim-treesitter.parsers")

    if parsers == nil then
        return total_lines, total_chars
    end

    local buf = vim.api.nvim_win_get_buf(0)
    local status, root_lang_tree = pcall(parsers.get_parser, buf)

    if not status or not root_lang_tree then
        return total_lines, total_chars
    end

    local tree_root
    for _, tree in ipairs(root_lang_tree:trees()) do
        -- FIXME: I'm not 100% sure this is correct; why would there be more
        -- than one tree?
        tree_root = tree:root()
    end

    if tree_root ~= nil then
        local query_result

        if vim.treesitter.query.parse then
            -- This is only supported in NeoVim 0.9+, and parse_query is
            -- deprecated.
            query_result = vim.treesitter.query.parse(language, query)
        else
            query_result = vim.treesitter.query.parse_query(language, query)
        end

        for _, node, _ in query_result:iter_captures(tree_root, buf, nil, nil) do
            local row1, _, row2, _ = node:range()

            if row2 == row1 then
                -- Some queries (e.g. for markdown) only cover one line (i.e. no
                -- CR), but in practice we want to treat them as if they have a
                -- CR in them.
                row2 = row1 + 1
            end

            total_lines = total_lines + (row2 - row1)
            total_chars = total_chars + get_character_count(row1, row2)
        end
    end

    return total_lines, total_chars
end

return M
