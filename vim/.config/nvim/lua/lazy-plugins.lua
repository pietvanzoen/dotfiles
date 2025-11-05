-- luacheck: globals vim MiniStatusline
require("lazy").setup({
  { import = "plugins" },     -- custom plugins folder
  "roman/golden-ratio",       -- Auto resize windows
  "tpope/vim-obsession",      -- Auto save session
  "tpope/vim-surround",       -- Surround text objects
  "tpope/vim-fugitive",       -- Git commands in vim
  "tpope/vim-rhubarb",        -- Github extension for fugitive
  "AndrewRadev/tagalong.vim", -- Auto close HTML tags

  {                           -- Emmet for neovim
    "olrtg/nvim-emmet",
    config = function()
      vim.keymap.set({ "n", "v" }, "<leader>xe", require("nvim-emmet").wrap_with_abbreviation)
    end,
  },

  {                  -- Manage lua dependencies
    "vhyrro/luarocks.nvim",
    priority = 1000, -- Very high priority is required, luarocks.nvim should run as the first plugin in your config.
    opts = {
      rocks = { "lunajson" },
    },
  },

  { -- Adds git related signs to the gutter, as well as utilities for managing changes
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "right_align", -- 'eol' | 'overlay' | 'right_align'
        delay = 1000,
        ignore_whitespace = false,
        virt_text_priority = 100,
      },
      current_line_blame = true,
      preview_config = {
        -- Options passed to nvim_open_win
        border = "rounded",
        style = "minimal",
        relative = "cursor",
        row = 0,
        col = 1,
      },
      current_line_blame_formatter = "<author>, <author_time:%R>: <summary>",
      on_attach = function(bufnr)
        local gitsigns = require("gitsigns")

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map("n", "]c", function()
          if vim.wo.diff then
            vim.cmd.normal({ "]c", bang = true })
          else
            gitsigns.nav_hunk("next")
          end
        end)

        map("n", "[c", function()
          if vim.wo.diff then
            vim.cmd.normal({ "[c", bang = true })
          else
            gitsigns.nav_hunk("prev")
          end
        end)

        -- Actions
        map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "[H]unk [S]tage" })
        map("n", "<leader>hr", gitsigns.reset_hunk, { desc = "[H]unk [R]eset" })
        map("v", "<leader>hs", function()
          gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, { desc = "[H]unk [S]tage" })
        map("v", "<leader>hr", function()
          gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, { desc = "[H]unk [R]eset" })
        map("n", "<leader>hS", gitsigns.stage_buffer, { desc = "[H]unk [S]tage" })
        map("n", "<leader>hu", gitsigns.undo_stage_hunk, { desc = "[H]unk [U]ndo" })
        map("n", "<leader>hR", gitsigns.reset_buffer, { desc = "[H]unk [R]eset" })
        map("n", "<leader>hp", gitsigns.preview_hunk, { desc = "[H]unk [P]review" })
        map("n", "<leader>hb", function()
          gitsigns.blame_line({ full = true })
        end, { desc = "[H]unk [B]lame" })
        map("n", "<leader>tb", gitsigns.toggle_current_line_blame, { desc = "[T]oggle [B]lame" })
        map("n", "<leader>hd", gitsigns.diffthis, { desc = "[H]unk [D]iff" })
        map("n", "<leader>hD", function()
          gitsigns.diffthis("~")
        end, { desc = "[H]unk [D]iff" })
        map("n", "<leader>td", gitsigns.toggle_deleted, { desc = "[T]oggle [D]eleted" })

        -- Text object
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
      end,
    },
  },

  { -- Open tmux splits from vim
    "preservim/vimux",
    config = function()
      vim.g.VimuxHeight = "60"
      vim.g.VimuxOrientation = "h"
    end,
  },

  { -- Quickly switch between files
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

  {                     -- Useful plugin to show you pending keybinds.
    "folke/which-key.nvim",
    event = "VimEnter", -- Sets the loading event to 'VimEnter'
    config = function()
      require("which-key").setup()
    end,
  },

  { -- Fuzzy Finder (files, lsp, etc)
    "nvim-telescope/telescope.nvim",
    event = "VimEnter",
    branch = "master",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { -- If encountering errors, see telescope-fzf-native README for installation instructions
        "nvim-telescope/telescope-fzf-native.nvim",

        -- `build` is used to run some command when the plugin is installed/updated.
        -- This is only run then, not every time Neovim starts up.
        build = "make",

        -- `cond` is a condition used to determine whether this plugin should be
        -- installed and loaded.
        cond = function()
          return vim.fn.executable("make") == 1
        end,
      },
      { "nvim-telescope/telescope-ui-select.nvim" },

      -- Useful for getting pretty icons, but requires a Nerd Font.
      { "nvim-tree/nvim-web-devicons",            enabled = vim.g.have_nerd_font },
      "debugloop/telescope-undo.nvim",
    },
    config = function()
      require("telescope").setup({
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown(),
          },
        },
      })

      -- Enable Telescope extensions if they are installed
      pcall(require("telescope").load_extension, "fzf")
      pcall(require("telescope").load_extension, "ui-select")
      pcall(require("telescope").load_extension, "undo")

      -- See `:help telescope.builtin`
      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
      vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
      vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
      vim.keymap.set("n", "<c-p>", builtin.find_files, { desc = "[S]earch [F]iles" })
      vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
      vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
      vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
      vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
      vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
      vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })
      vim.keymap.set("n", "<leader>su", "<cmd>Telescope undo<cr>", { desc = "[S]earch [U]ndo Tree" })

      -- Slightly advanced example of overriding default behavior and theme
      vim.keymap.set("n", "<leader>/", function()
        -- You can pass additional configuration to Telescope to change the theme, layout, etc.
        builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
          winblend = 10,
          previewer = false,
        }))
      end, { desc = "[/] Fuzzily search in current buffer" })

      -- It's also possible to pass additional configuration options.
      --  See `:help telescope.builtin.live_grep()` for information about particular keys
      vim.keymap.set("n", "<leader>s/", function()
        builtin.live_grep({
          grep_open_files = true,
          prompt_title = "Live Grep in Open Files",
        })
      end, { desc = "[S]earch [/] in Open Files" })

      -- Shortcut for searching your Neovim configuration files
      vim.keymap.set("n", "<leader>sn", function()
        builtin.find_files({ cwd = vim.fn.stdpath("config") })
      end, { desc = "[S]earch [N]eovim files" })
    end,
  },

  { -- Autocompletion
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
    },
    config = function()
      local cmp = require("cmp")

      cmp.setup({
        completion = { completeopt = "menu,menuone,noinsert" },

        -- For an understanding of why these mappings were
        -- chosen, you will need to read `:help ins-completion`
        --
        -- No, but seriously. Please read `:help ins-completion`, it is really good!
        mapping = cmp.mapping.preset.insert({
          -- Select the [n]ext item
          ["<C-n>"] = cmp.mapping.select_next_item(),
          -- Select the [p]revious item
          ["<C-p>"] = cmp.mapping.select_prev_item(),

          -- Scroll the documentation window [b]ack / [f]orward
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),

          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<C-Space>"] = cmp.mapping.complete({}),
        }),
        sources = {
          { name = "nvim_lsp" },
          { name = "path" },
        },
      })
    end,
  },

  { -- LSP Configuration & Plugins
    "neovim/nvim-lspconfig",
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      { "mason-org/mason.nvim" },
      { "mason-org/mason-lspconfig.nvim" },           -- same here
      { "j-hui/fidget.nvim",             opts = {} }, -- Useful status updates for LSP.

      -- `neodev` configures Lua LSP for your Neovim config, runtime and plugins
      -- used for completion, annotations and signatures of Neovim apis
      { "folke/neodev.nvim",             opts = {} },

      { -- Github Copilot integration
        "zbirenbaum/copilot.lua",
        dependencies = {
          "copilotlsp-nvim/copilot-lsp"
        },
        opts = {
          panel = {
            layout = {
              position = "right",
            },
          },
          nes = {
            enabled = true,
            keymap = {
              accept_and_goto = "<leader>p",
              accept = false,
              dismiss = "<Esc>",
            },
          },
          suggestion = {
            auto_trigger = true,
            keymap = {
              accept_line = "<tab>",
            },
          },
          filetypes = {
            gitcommit = true,
            sh = function()
              if string.match(vim.fs.basename(vim.api.nvim_buf_get_name(0)), "^%.env.*") then
                -- disable for .env files
                return false
              end
              return true
            end,
          },
        },
      },
    },
    config = function()
      --  This function gets run when an LSP attaches to a particular buffer.
      --    That is to say, every time a new file is opened that is associated with
      --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
      --    function will be executed to configure the current buffer
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          -- Jump to the definition of the word under your cursor.
          --  This is where a variable was first declared, or where a function is defined, etc.
          --  To jump back, press <C-t>.
          map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")

          -- Find references for the word under your cursor.
          map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")

          -- Jump to the implementation of the word under your cursor.
          --  Useful when your language has ways of declaring types without an actual implementation.
          map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")

          -- Jump to the type of the word under your cursor.
          --  Useful when you're not sure what type a variable is and you want to see
          --  the definition of its *type*, not where it was *defined*.
          map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")

          -- Fuzzy find all the symbols in your current document.
          --  Symbols are things like variables, functions, types, etc.
          map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")

          -- Fuzzy find all the symbols in your current workspace.
          --  Similar to document symbols, except searches over your entire project.
          map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

          -- Rename the variable under your cursor.
          --  Most Language Servers support renaming across files, etc.
          map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")

          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

          -- Opens a popup that displays documentation about the word under your cursor
          --  See `:help K` for why this keymap.
          map("K", vim.lsp.buf.hover, "Hover Documentation")

          -- WARN: This is not Goto Definition, this is Goto Declaration.
          --  For example, in C this would take you to the header.
          map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          client.server_capabilities.semanticTokensProvider = nil
          if client and client.server_capabilities.documentHighlightProvider then
            local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd("LspDetach", {
              group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
              end,
            })
          end

        end,
      })

      -- LSP servers and clients are able to communicate to each other what features they support.
      --  By default, Neovim doesn't support everything that is in the LSP specification.
      --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
      --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())
      local vue_language_server_path = vim.fn.stdpath 'data' ..
          '/mason/packages/vue-language-server/node_modules/@vue/language-server'

      local servers = {
        ts_ls    = {
          init_options = {
            plugins = {
              {
                name = "@vue/typescript-plugin",
                location = vue_language_server_path,
                languages = { "vue" },
              },
            },
          },
          filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
        },

        emmet_ls = {},

        eslint   = {
          codeAction = {
            disableRuleComment = {
              enable = true,
              location = "separateLine",
            },
            showDocumentation = {
              enable = true,
            },
          },
        },

        html     = {
          filetypes = { "html" },
        },

        cssls    = {
          filetypes = { "css", "scss", "less" },
        },

        lua_ls   = {
          settings = {
            Lua = {
              completion = {
                callSnippet = "Replace",
              },
              diagnostics = {
                enable = true,
                globals = { "vim" },
                disable = { "missing-fields" },
              },
            },
          },
        },
        vale_ls  = {
          filetypes = { "markdown" },
        },
      }

      local mason = require("mason")
      local mason_lspconfig = require("mason-lspconfig")
      mason.setup()
      mason_lspconfig.setup({
        automatic_enable = true,
        ensure_installed = vim.tbl_keys(servers),
      })

      for server_name, server in pairs(servers) do
        server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
        vim.lsp.config(server_name, server)
      end
    end,
  },

  { -- Autoformat
    "stevearc/conform.nvim",
    lazy = false,
    keys = {
      {
        "<leader>f",
        function()
          require("conform").format({ async = true, lsp_fallback = true })
        end,
        mode = "",
        desc = "[F]ormat buffer",
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        local enabled_filetypes = { lua = true }
        return {
          timeout_ms = 3000,
          lsp_fallback = not enabled_filetypes[vim.bo[bufnr].filetype],
        }
      end,
      formatters_by_ft = {
        lua = { "stylua" },
        javascript = { "eslint_d" },
        typescript = { "eslint_d" },
        vue = { "eslint_d" },
        react = { "eslint_d" },
        html = { "prettier" },
        css = { "prettier" },
        scss = { "prettier" },
        json = { "prettier" },
      },
    },
  },

  { -- Collection of various small independent plugins/modules
    "echasnovski/mini.nvim",
    version = false,
    config = function()
      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [']quote
      --  - ci'  - [C]hange [I]nside [']quote
      require("mini.ai").setup({ n_lines = 500 })

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require("mini.surround").setup()

      local CustomStatusline = {}
      require("mini.statusline").setup({
        use_icons = true,
        content = {
          inactive = function()
            local pathname = CustomStatusline.section_pathname({ trunc_width = 120 })
            return MiniStatusline.combine_groups({
              { hl = "MiniStatuslineInactive", strings = { pathname } },
            })
          end,
          active = function()
            local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
            local git = CustomStatusline.section_git({ trunc_width = 100 })
            local diagnostics = MiniStatusline.section_diagnostics({ trunc_width = 60 })
            local filetype = CustomStatusline.section_filetype({ trunc_width = 70 })
            local project = CustomStatusline.section_project({ trunc_width = 80 })
            local location = CustomStatusline.section_location({ trunc_width = 120 })
            local search = CustomStatusline.section_searchcount({ trunc_width = 80 })
            local pathname = CustomStatusline.section_pathname({
              trunc_width = 100,
            })

            return MiniStatusline.combine_groups({
              { hl = mode_hl, strings = { mode:upper() } },
              { hl = "MiniStatuslineDevinfo", strings = { git, "│", project } },
              "%<", -- Mark general truncate point
              { hl = "MiniStatuslineFilename", strings = { pathname } },
              "%=", -- End left alignment
              { hl = "MiniStatuslineFileinfo", strings = { filetype, diagnostics } },
              { hl = mode_hl,                  strings = { search .. location } },
            })
            -- stylua: ignore end
          end,
        },
      })

      local truncate_string = function(str, length)
        if #str > length then
          return string.sub(str, 1, length) .. "…"
        else
          return str
        end
      end

      CustomStatusline.section_git = function(args)
        ---@diagnostic disable-next-line: undefined-field
        local git = vim.b.gitsigns_head or ""
        if git == "" then
          return ""
        end

        git = " " .. git

        if MiniStatusline.is_truncated(args.trunc_width) then
          return truncate_string(git, 12)
        end

        return truncate_string(git, 30)
      end

      -- Utility from mini.statusline
      CustomStatusline.isnt_normal_buffer = function()
        return vim.bo.buftype ~= ""
      end

      CustomStatusline.get_filetype_icon = function()
        -- Have this `require()` here to not depend on plugin initialization order
        local has_devicons, devicons = pcall(require, "nvim-web-devicons")
        if not has_devicons then
          return ""
        end

        local file_name, file_ext = vim.fn.expand("%:t"), vim.fn.expand("%:e")
        return devicons.get_icon(file_name, file_ext, { default = true })
      end

      CustomStatusline.section_location = function(args)
        -- Use virtual column number to allow update when past last column
        if MiniStatusline.is_truncated(args.trunc_width) then
          return "%-2l│%-2v"
        end

        return "󰉸 %-2l│󱥖 %-2v"
      end

      CustomStatusline.section_filetype = function(args)
        if MiniStatusline.is_truncated(args.trunc_width) then
          return ""
        end

        local filetype = vim.bo.filetype
        if (filetype == "") or CustomStatusline.isnt_normal_buffer() then
          return ""
        end

        local icon = CustomStatusline.get_filetype_icon()
        if icon ~= "" then
          filetype = string.format("%s %s", icon, filetype)
        end

        return filetype
      end

      --- Section for current search count
      ---
      --- Show the current status of |searchcount()|. Empty output is returned if
      --- window width is lower than `args.trunc_width`, search highlighting is not
      --- on (see |v:hlsearch|), or if number of search result is 0.
      ---
      --- `args.options` is forwarded to |searchcount()|. By default it recomputes
      --- data on every call which can be computationally expensive (although still
      --- usually on 0.1 ms order of magnitude). To prevent this, supply
      --- `args.options = { recompute = false }`.
      CustomStatusline.section_searchcount = function(args)
        if vim.v.hlsearch == 0 then
          return ""
        end
        -- `searchcount()` can return errors because it is evaluated very often in
        -- statusline. For example, when typing `/` followed by `\(`, it gives E54.
        local ok, s_count = pcall(vim.fn.searchcount, (args or {}).options or { recompute = true })
        if not ok or s_count.current == nil or s_count.total == 0 then
          return ""
        end

        local icon = MiniStatusline.is_truncated(args.trunc_width) and "" or " "
        if s_count.incomplete == 1 then
          return icon .. "?/?│"
        end

        local too_many = (">%d"):format(s_count.maxcount)
        local current = s_count.current > s_count.maxcount and too_many or s_count.current
        local total = s_count.total > s_count.maxcount and too_many or s_count.total
        return ("%s%s/%s│"):format(icon, current, total)
      end

      CustomStatusline.section_project = function(args)
        args = vim.tbl_extend("force", {
          trunc_width = 80,
        }, args or {})

        local cwd = vim.fn.getcwd()
        local project_dir = vim.split(cwd, "/")[#vim.split(cwd, "/")]
        if MiniStatusline.is_truncated(args.trunc_width) then
          return project_dir
        end

        return " " .. project_dir
      end

      CustomStatusline.section_pathname = function(args)
        args = vim.tbl_extend("force", {
          trunc_width = 80,
        }, args or {})

        if vim.bo.buftype == "terminal" then
          return "%t"
        end

        local path = vim.fn.expand("%:p")
        local cwd = vim.uv.cwd() or ""
        cwd = vim.uv.fs_realpath(cwd) or ""

        if path:find(cwd, 1, true) == 1 then
          path = path:sub(#cwd + 2)
        end

        local sep = package.config:sub(1, 1)
        local parts = vim.split(path, sep)
        if require("mini.statusline").is_truncated(args.trunc_width) and #parts > 3 then
          parts = { parts[1], "…", parts[#parts - 1], parts[#parts] }
        end

        local dir = ""
        if #parts > 1 then
          dir = table.concat({ unpack(parts, 1, #parts - 1) }, sep) .. sep
        end

        local file = parts[#parts]
        local modified = ""
        if vim.bo.modified then
          modified = " " .. ""
        end

        return dir .. file .. modified
      end

      -- Indentation scope indicator
      require("mini.indentscope").setup({
        symbol = "",
      })
      vim.api.nvim_set_hl(0, "MiniIndentscopeSymbol", { fg = "#526f76" })

      -- Commenting out lines or blocks of code
      require("mini.comment").setup()

      -- ... and there is more!
      --  Check out: https://github.com/echasnovski/mini.nvim
    end,
  },

  { -- Solarized colorscheme
    "ishan9299/nvim-solarized-lua",
    priority = 1000,
    config = function()
      vim.opt.termguicolors = true
      vim.cmd.colorscheme("solarized")
    end,
  },

  { -- Highlight todo, notes, etc in comments
    "folke/todo-comments.nvim",
    event = "VimEnter",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = { signs = false },
  },

  { -- Highlight, edit, and navigate code
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
      ensure_installed = {
        "bash",
        "c",
        "diff",
        "html",
        "lua",
        "luadoc",
        "markdown",
        "vim",
        "vimdoc",
        "javascript",
        "jsdoc",
        "vue",
        "typescript",
        "css",
        "scss",
      },
      -- Autoinstall languages that are not installed
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = { enable = true },
    },
    config = function(_, opts)
      -- [[ Configure Treesitter ]] See `:help nvim-treesitter`

      -- Prefer git instead of curl in order to improve connectivity in some environments
      require("nvim-treesitter.install").prefer_git = true
      ---@diagnostic disable-next-line: missing-fields
      require("nvim-treesitter.configs").setup(opts)

      vim.api.nvim_set_hl(0, "@punctuation.bracket", { link = "Variable" })
      vim.api.nvim_set_hl(0, "@punctuation.delimiter", { link = "Variable" })
      vim.api.nvim_set_hl(0, "@keyword.function", { link = "Keyword" })
      vim.api.nvim_set_hl(0, "@include", { link = "Keyword" })

      -- Use Treesitter for folding
      vim.opt.foldmethod = "expr"
      vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
      vim.opt.foldenable = false

      -- There are additional nvim-treesitter modules that you can use to interact
      -- with nvim-treesitter. You should go explore a few and see what interests you:
      --
      --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
      --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
      --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter-context",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      enable = true,
      max_lines = 0,        -- Disable max lines limit
      trim_scope = "inner", -- Show only the inner scope
      mode = "cursor",      -- Show context at cursor position
    }
  },
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
