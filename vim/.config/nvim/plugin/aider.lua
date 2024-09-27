local function get_open_buffers_in_current_window()
    local current_tabpage = vim.api.nvim_get_current_tabpage()
    local windows = vim.api.nvim_tabpage_list_wins(current_tabpage)
    local buffers = {}

    for _, win in ipairs(windows) do
        local buf = vim.api.nvim_win_get_buf(win)
        local buf_name = vim.api.nvim_buf_get_name(buf)
        table.insert(buffers, buf_name)
    end

    return buffers
end

-- Example usage: print the buffer numbers
print(vim.inspect(get_open_buffers_in_current_window()))
