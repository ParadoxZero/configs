return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "night",
    },
    enable = false
  },
  {
    "scottmckendry/cyberdream.nvim",
    lazy = false,
    priority = 1000,
    opts =  {
        transparent = true,
        varient = "auto",
        italic_comments = true,
        terminal_colors = true,
        hide_fillchars = false,
        saturation = 0.8
      }
  }
}
