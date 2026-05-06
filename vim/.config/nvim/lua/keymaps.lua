-- luacheck: globals vim
-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous [D]iagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next [D]iagnostic message" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')


vim.keymap.set("n", "<leader>h", ":let @/ = ''<CR>", { desc = "Disable search highlighting" })

vim.keymap.set("n", "<leader>z", "1z=", { desc = "Replace bad spelling with first suggestion" })

vim.keymap.set("v", "//", 'y/<C-R>"<CR>', { desc = "Search for currently selected text" })

local function yank_path(with_lines)
  local git_root = vim.trim(vim.fn.system("git rev-parse --show-toplevel"))
  local file = vim.fn.expand("%:p")
  local relative = file:sub(#git_root + 2)
  if with_lines then
    local start_line = vim.fn.line("v")
    local end_line = vim.fn.line(".")
    if start_line > end_line then start_line, end_line = end_line, start_line end
    relative = start_line == end_line and (relative .. "#L" .. start_line) or (relative .. "#L" .. start_line .. "-" .. end_line)
  end
  vim.fn.setreg("+", relative)
  vim.notify("Copied: " .. relative)
end

vim.keymap.set("n", "<leader>yp", function() yank_path(false) end, { desc = "Copy file path relative to git root" })
vim.keymap.set("v", "<leader>yp", function() yank_path(true) end, { desc = "Copy file path with line numbers relative to git root" })

-- vim: ts=2 sts=2 sw=2 et
