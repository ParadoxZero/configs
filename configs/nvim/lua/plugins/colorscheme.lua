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
        transparent = true,
        varient = "auto",
        italic_comments = true,
        terminal_colors = true,
        hide_fillchars = false,
        -- saturation = 0.8
      })
      vim.cmd [[colorscheme cyberdream]]
    end,
  }
}
