require("lazy").setup({
  {
    "smoka7/hop.nvim",
    config = function()
      local hop = require("hop")
      hop.setup()
      -- Use `s` to trigger hop
      vim.keymap.set("", "s", function()
        hop.hint_char1({})
      end, { remap = true, desc = "Hop" })
    end,
  },
  "tpope/vim-obsession",
  "tpope/vim-fugitive",
  "roman/golden-ratio",
  {
    "preservim/vimux",
    config = function()
      vim.g.VimuxHeight = "30"
      vim.g.VimuxOrientation = "h"
    end,
  },

  "tpope/vim-sleuth", -- Detect tabstop and shiftwidth automatically

  { "numToStr/Comment.nvim", opts = {} }, -- "gc" to comment visual regions/lines

  require("kickstart/plugins/git"),

  require("kickstart/plugins/which-key"),

  require("kickstart/plugins/telescope"),

  require("kickstart/plugins/nvim-cmp"),

  require("kickstart/plugins/lsp-config"),
  require("kickstart/plugins/lint"),
  require("kickstart/plugins/format"),

  require("kickstart/plugins/colorscheme"),
  require("kickstart/plugins/mini"),

  require("kickstart/plugins/treesitter"),

  { -- Highlight todo, notes, etc in comments
    "folke/todo-comments.nvim",
    event = "VimEnter",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = { signs = false },
  },

  { import = "custom/plugins" },
}, {
  change_detection = {
    -- automatically check for config file changes and reload the ui
    enabled = true,
    notify = true, -- get a notification when changes are found
  },
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = "⌘",
      config = "🛠",
      event = "📅",
      ft = "📂",
      init = "⚙",
      keys = "🗝",
      plugin = "🔌",
      runtime = "💻",
      require = "🌙",
      source = "📄",
      start = "🚀",
      task = "📌",
      lazy = "💤 ",
    },
  },
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
