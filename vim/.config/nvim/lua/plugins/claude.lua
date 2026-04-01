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
      require("claude-preview").setup({
        diff = {
          layout = "inline",
          auto_close = true,
        },
        highlights = {
          inline = {
            added = { bg = "#0d2a1a" },
            removed = { bg = "#2a0d0d" },
            added_text = { bg = "#2d6e2d", fg = "#e0f0e0" },
            removed_text = { bg = "#6e2d2d", fg = "#f0e0e0" },
          },
        },
      })
    end,
  },
}
