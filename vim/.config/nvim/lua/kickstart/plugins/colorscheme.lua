return {
  {
    "ishan9299/nvim-solarized-lua",
    priority = 1000,
    config = function()
      vim.opt.termguicolors = true
      vim.cmd.colorscheme("solarized")
    end,
  },
}
