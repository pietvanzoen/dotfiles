return {
  {
    "maxmx03/solarized.nvim",
    priority = 1000,
    init = function()
      vim.o.background = "dark" -- or 'light'
      vim.cmd.colorscheme("solarized")
      -- vim.cmd.hi("Comment gui=none")
    end,
  },
}
