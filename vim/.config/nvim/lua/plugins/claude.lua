-- luacheck: globals vim
local function get_git_branch()
  local handle = io.popen("git branch --show-current 2>/dev/null")
  if handle then
    local branch = handle:read("*a"):gsub("%s+", "")
    handle:close()
    return branch ~= "" and branch or "main"
  end
  return "main"
end

function open_claude_with_buffers()
  local branch = get_git_branch()
  vim.cmd("VimuxRunCommand 'claude code --session-id " .. branch .. "'")
end

vim.api.nvim_set_keymap("n", "<leader>oc", ":lua open_claude_with_buffers()<CR>", { noremap = true, silent = true })

return {}
