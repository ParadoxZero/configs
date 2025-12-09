return {
	{
		"ojroques/vim-oscyank",
		branch = "main",
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
		opts = {
			-- options
		},
	},
	{
		"lewis6991/gitsigns.nvim",
	},
	{
		"MeanderingProgrammer/render-markdown.nvim",
		-- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.nvim' }, -- if you use the mini.nvim suite
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.icons" }, -- if you use standalone mini plugins
		-- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
		---@module 'render-markdown'
		---@type render.md.UserConfig
		opts = {},
	},
	{
		"luukvbaal/statuscol.nvim",
		config = function()
			local builtin = require("statuscol.builtin")
			require("statuscol").setup({
				-- configuration goes here, for example:
				relculright = true,
				-- segments = {
				-- 	{ text = { builtin.foldfunc }, click = "v:lua.ScFa" },
				-- },
			})
		end,
	},
}
