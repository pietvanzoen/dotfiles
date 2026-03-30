-- luacheck: globals vim
-- Claude Code integration: keybinding + diff preview plugin
function open_claude_with_buffers()
  vim.cmd("VimuxRunCommand 'cc'")
end

vim.api.nvim_set_keymap("n", "<leader>oc", ":lua open_claude_with_buffers()<CR>", { noremap = true, silent = true })

return {
  {
    "Cannon07/claude-preview.nvim",
    config = function()
      require("claude-preview").setup()
    end,
  },
}
