return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "marilari88/neotest-vitest",
    },
    keys = {
      { "<leader>tt", function() require("neotest").run.run() end, desc = "Test nearest" },
      { "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Test file" },
      { "<leader>ts", function() require("neotest").summary.toggle() end, desc = "Test summary" },
      { "<leader>to", function() require("neotest").output_panel.toggle() end, desc = "Test output panel" },
      { "<leader>tp", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "Test output popup" },
      { "<leader>tl", function() require("neotest").run.run_last() end, desc = "Test last" },
      { "<leader>tw", function() require("neotest").watch.toggle(vim.fn.expand("%")) end, desc = "Test watch file" },
      { "]t", function() require("neotest").jump.next({ status = "failed" }) end, desc = "Next failing test" },
      { "[t", function() require("neotest").jump.prev({ status = "failed" }) end, desc = "Prev failing test" },
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-vitest")({
            is_test_file = function(file_path)
              for _, x in ipairs({ "e2e", "spec", "test", "vitest" }) do
                for _, ext in ipairs({ "js", "jsx", "ts", "tsx" }) do
                  if file_path:match("%." .. x .. "%." .. ext .. "$") then
                    return true
                  end
                end
              end
              return false
            end,
            env = {
              ENV_MODE = "development",
              LOG_LEVEL = "fatal",
              AWS_SDK_JS_SUPPRESS_MAINTENANCE_MODE_MESSAGE = "1",
            },
          }),
        },
      })
    end,
  },
}
