-- luacheck: globals vim
function open_claude_with_buffers()
  vim.cmd("VimuxRunCommand 'claude'")
end

vim.api.nvim_set_keymap("n", "<leader>oc", ":lua open_claude_with_buffers()<CR>", { noremap = true, silent = true })

return {}
