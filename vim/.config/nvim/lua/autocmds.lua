-- [[ Basic Autocommands ]]
-- luacheck: globals vim
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank({
      timeout = 500,
    })
  end,
})

vim.api.nvim_create_autocmd({ "VimEnter", "InsertLeave" }, {
  desc = "set relativenumber",
  group = vim.api.nvim_create_augroup("set_relativenumber", { clear = true }),
  pattern = "*.*",
  command = "set relativenumber",
})

vim.api.nvim_create_autocmd({ "InsertEnter" }, {
  desc = "set number",
  group = vim.api.nvim_create_augroup("set_number", { clear = true }),
  pattern = "*",
  command = "set number norelativenumber",
})

-- vim: ts=2 sts=2 sw=2 et
