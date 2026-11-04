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

-- Golden ratio: give the focused block ~75% of each axis (mirrors tmux-golden-ratio).
-- Rex has no focus event, so this runs after ctrl+hjkl navigation and via
-- `rex do golden_ratio` (called by Neovim after it hands focus to Rex).
-- ponytail: mouse-click focus doesn't trigger it; hook an event if Rex adds one.
local golden = true
local GOLDEN = 0.75

local function contains(node, id)
  if node.block_id then return node.block_id == id end
  return contains(node.split.before, id) or contains(node.split.after, id)
end

-- Block touching the split border: last leaf of the before side, first of the after side.
local function edge(node, last)
  while node.split do
    node = last and node.split.after or node.split.before
  end
  return node.block_id
end

local function apply_golden()
  if not golden then return end
  local view = rex.session.view({})
  if not view then return end
  for _, win in ipairs(view.windows) do
    if win.window_id == view.active_window_id and not win.zoomed_block_id then
      for _, layer in ipairs(win.layers) do
        if layer.kind == "tiled" and contains(layer.layout, win.focused_block_id) then
          local extent = { horizontal = 1, vertical = 1 }
          local node = layer.layout
          while node.split do
            local s = node.split
            local share = math.min(0.9, math.max(0.1, GOLDEN / extent[s.direction]))
            local in_before = contains(s.before, win.focused_block_id)
            rex.session.resize_pane({
              direction = s.direction,
              before_block_id = edge(s.before, true),
              after_block_id = edge(s.after, false),
              ratio = in_before and share or 1 - share,
            })
            extent[s.direction] = extent[s.direction] * share
            node = in_before and s.before or s.after
          end
        end
      end
    end
  end
end

rex.action({ name = "golden_ratio", title = "Golden Ratio Resize", run = apply_golden })

rex.bind("ctrl+b>shift+g", function()
  golden = not golden
  rex.log("Golden ratio: " .. (golden and "ON" or "OFF"))
  apply_golden()
  return true
end)

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
    apply_golden()
    return true
  end
end

rex.bind("ctrl+h", navigate("left"))
rex.bind("ctrl+j", navigate("down"))
rex.bind("ctrl+k", navigate("up"))
rex.bind("ctrl+l", navigate("right"))
