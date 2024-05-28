require("lazy").setup({
  "tpope/vim-obsession",
  "tpope/vim-fugitive",
  "nvim-treesitter/nvim-treesitter-context",
  "roman/golden-ratio",
  {
    "preservim/vimux",
    config = function()
      vim.g.VimuxHeight = "30"
      vim.g.VimuxOrientation = "h"
    end,
  },

  {
    "zbirenbaum/copilot.lua",
    opts = {
      panel = {
        layout = {
          position = "right",
        },
      },
      suggestion = {
        auto_trigger = true,
        keymap = {
          accept = "<Tab>",
        },
      },
      filetypes = {
        gitcommit = true,
      },
    },
  },

  "tpope/vim-sleuth", -- Detect tabstop and shiftwidth automatically

  { "numToStr/Comment.nvim", opts = {} }, -- "gc" to comment visual regions/lines

  require("kickstart/plugins/gitsigns"),

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
