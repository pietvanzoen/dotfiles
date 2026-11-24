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

-- Live-reload buffers changed on disk (Claude in auto mode edits without a diff prompt).
-- gitsigns/mini.diff then mark the changed lines.
vim.o.autoread = true
vim.fn.timer_start(1000, function()
  if vim.fn.getcmdwintype() == "" then vim.cmd("silent! checktime") end
end, { ["repeat"] = -1 })
vim.api.nvim_create_autocmd("FileChangedShellPost", {
  callback = function(ev)
    vim.notify("Reloaded " .. vim.fn.fnamemodify(ev.file, ":~:."), vim.log.levels.INFO)
  end,
})

-- Auto-open files Claude edits. The claude-log-edit PostToolUse hook appends "path:line"
-- to <project>/.claude/edits.log; open the file at that line if it isn't already loaded.
-- Only in git repos, so nvim doesn't scatter .claude/ dirs everywhere.
-- Toggle with :ClaudeFollowToggle / <leader>af (log is still consumed while off).
vim.g.claude_follow = true
vim.api.nvim_create_user_command("ClaudeFollowToggle", function()
  vim.g.claude_follow = not vim.g.claude_follow
  vim.notify("Claude follow " .. (vim.g.claude_follow and "on" or "off"))
end, {})
vim.keymap.set("n", "<leader>af", "<cmd>ClaudeFollowToggle<cr>", { desc = "Toggle Claude follow" })

-- Log path must match claude-log-edit: <macOS user temp dir>/claude-edits/<cwd with / as ->.log
-- (not sandbox-writable, so sandboxed commands can't swap it for a symlink; macOS cleans it up).
if vim.fn.isdirectory(".git") == 0 then return {} end
local edits_dir = vim.trim(vim.fn.system({ "getconf", "DARWIN_USER_TEMP_DIR" })) .. "claude-edits"
local edits_log = edits_dir .. "/" .. vim.fn.getcwd():gsub("/", "-") .. ".log"
vim.fn.mkdir(edits_dir, "p")
-- Create if missing (fs_event needs the file); start at the end so old entries are skipped.
if vim.fn.filereadable(edits_log) == 0 then vim.fn.writefile({}, edits_log) end
local offset = vim.fn.getfsize(edits_log)
local watcher = vim.uv.new_fs_event()
watcher:start(edits_log, {}, vim.schedule_wrap(function()
  local size = vim.fn.getfsize(edits_log)
  if size < offset then offset = 0 end -- log truncated
  local fd = io.open(edits_log, "r")
  if not fd then return end
  fd:seek("set", offset)
  local chunk = fd:read("*a")
  fd:close()
  offset = size
  if not vim.g.claude_follow then return end
  for entry in chunk:gmatch("[^\n]+") do
    local path, line = entry:match("^(.*):(%d+)$")
    if path and vim.fn.bufloaded(path) == 0 then
      vim.cmd.drop(vim.fn.fnameescape(path))
      pcall(vim.api.nvim_win_set_cursor, 0, { tonumber(line), 0 })
      vim.cmd("normal! zz")
    end
  end
end))

return {}
