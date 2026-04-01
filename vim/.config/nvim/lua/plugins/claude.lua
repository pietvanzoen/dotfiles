-- luacheck: globals vim
-- claudecode.nvim keybindings (plugin config lives in lazy-plugins.lua)
vim.api.nvim_set_keymap("n", "<leader>oc", ":VimuxRunCommand 'cc'<CR>", { noremap = true, silent = true })

-- Close the stray [No Name] window left by claudecode.nvim's inline diff + open_in_new_tab.
-- The inline diff creates a vsplit for the diff buffer but leaves the original [No Name]
-- window open. Detect this when entering the diff buffer and close that window.
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    if not vim.b.claudecode_inline_diff then return end
    local diff_win = vim.api.nvim_get_current_win()
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
      if win ~= diff_win then
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.api.nvim_buf_get_name(buf) == ""
          and not vim.api.nvim_buf_get_option(buf, "modified")
          and vim.api.nvim_buf_line_count(buf) <= 1
        then
          pcall(vim.api.nvim_win_close, win, false)
          break
        end
      end
    end
  end,
})

return {}
