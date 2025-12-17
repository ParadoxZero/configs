return {
	{
		"ojroques/vim-oscyank",
		branch = "main",
    lazy = false,
		config = function()
			local wk = require("which-key")
			wk.add({
				{ "<leader>y", "<Plug>OSCYankOperator", desc = "Copy to system Clipboard" },
				-- vim.keymap.set('n', '<leader>cc', '<leader>c_', {remap = true})
				{ "<leader>y", "<Plug>OSCYankVisual", desc = "Copy to system Clipboard", mode = "v" },
			})
		end,
	},
	{
		"j-hui/fidget.nvim",
    enabled = false,
		opts = {
			-- options
		},
	},
	{
		"lewis6991/gitsigns.nvim",
    enabled = true,
	},
	{
		"MeanderingProgrammer/render-markdown.nvim",
		-- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.nvim' }, -- if you use the mini.nvim suite
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.icons" }, -- if you use standalone mini plugins
		-- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
		---@module 'render-markdown'
		---@type render.md.UserConfig
		opts = {
			render_modes = { "n", "c", "t" },
			code = {
				conceal_delimiters = false,
				render_modes = false,
				language = false,
				language_icon = false,
				language_name = false,
				language_info = false,
				language_info = false,
				disable_background = true,
				border = "thin",
			},
		},
	},
}
