return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
  },
  {
    "scottmckendry/cyberdream.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("cyberdream").setup({
        transparent = false,
        varient = "auto",
        saturation = 0.8
      })
      vim.cmd [[colorscheme cyberdream]]
    end,
  }
}
