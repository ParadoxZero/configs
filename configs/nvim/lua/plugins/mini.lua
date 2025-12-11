return {
	{
		"nvim-mini/mini.animate",
		version = "*",
    enabled = false,
		config = function()
			require("mini.animate").setup({
        scroll = {
          enable = false
        }
      })
		end,
	},
	{
		"nvim-mini/mini.indentscope",
		version = "*",
		config = function()
			require("mini.indentscope").setup()
		end,
	},
	{
		"nvim-mini/mini.cursorword",
		version = "*",
		config = function()
			require("mini.cursorword").setup()
			vim.api.nvim_set_hl(0, "MiniCursorword", { underline = true, bg = "NONE" })
			vim.api.nvim_set_hl(0, "MiniCursorwordCurrent", { underline = true, bg = "NONE" })
		end,
	},
}
