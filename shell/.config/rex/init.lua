-- Migrated from tmux (prefix ctrl+b)
rex.bind("ctrl+b>ctrl+b", "pane.send_key", { key = "ctrl+b" })

rex.bind("ctrl+b>r", "client.config.reload")
rex.bind("ctrl+b>shift+'", "pane.split", { direction = "down" })
rex.bind("ctrl+b>shift+5", "pane.split", { direction = "right" })
rex.bind("ctrl+b>ctrl+l", "pane.send_key", { key = "ctrl+l" })
rex.bind("ctrl+b>shift+,", "pane.resize", { amount = 10, direction = "left" })
rex.bind("ctrl+b>shift+.", "pane.resize", { amount = 10, direction = "right" })
rex.bind("ctrl+b>-", "pane.resize", { amount = 10, direction = "down" })
rex.bind("ctrl+b>shift+=", "pane.resize", { amount = 10, direction = "up" })
rex.bind("ctrl+9", "session.next")
rex.bind("ctrl+0", "session.previous")

-- Seamless vim/rex pane navigation (mirrors vim-tmux-navigator in .tmux.conf)
local passthrough = { vim = true, nvim = true, view = true, vimdiff = true, nvimdiff = true, fzf = true, tmux = true }

local function navigate(direction)
  return function()
    local proc = rex.block.call("com.superlogical.terminal", "process", {})
    local fg = proc and proc.foreground
    if fg and (passthrough[fg.name] or passthrough[(fg.argv0 or ""):gsub("^-", "")]) then
      return false -- let vim/fzf/tmux handle the key
    end
    rex.session.focus_direction({ direction = direction })
    return true
  end
end

rex.bind("ctrl+h", navigate("left"))
rex.bind("ctrl+j", navigate("down"))
rex.bind("ctrl+k", navigate("up"))
rex.bind("ctrl+l", navigate("right"))
