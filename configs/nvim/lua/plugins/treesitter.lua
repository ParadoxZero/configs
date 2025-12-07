return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate", -- auto-update parsers
		config = function()
			require("nvim-treesitter.configs").setup({
				-- list of parsers to install
				ensure_installed = { "lua", "python", "nu", "c", "cpp", "json", "bash" },

				-- enable syntax highlighting
				highlight = { enable = true },

				-- optional features
				indent = { enable = true },
				incremental_selection = { enable = true },
				playground = { enable = true },
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
	},
}
