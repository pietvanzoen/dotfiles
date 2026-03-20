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

-- Set filetype for extensionless scripts based on shebang
vim.api.nvim_create_autocmd({ "BufNewFile", "BufReadPost" }, {
  desc = "Detect javascript filetype from node/deno shebang",
  group = vim.api.nvim_create_augroup("shebang-filetype", { clear = true }),
  callback = function()
    if vim.bo.filetype ~= "" then return end
    local first_line = (vim.fn.getline(1) or "")
    if first_line:match("deno") then
      vim.bo.filetype = "typescript"
    elseif first_line:match("node") then
      vim.bo.filetype = "javascript"
    end
  end,
})

-- vim: ts=2 sts=2 sw=2 et
