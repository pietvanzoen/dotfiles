return {
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
}
