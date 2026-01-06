return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate", -- auto-update parsers
		config = function()
			-- require("nvim-treesitter.configs").({
			-- 	-- list of parsers to install
			-- 	ensure_installed = { "lua", "python", "nu", "c", "cpp", "json", "bash", "gn", "idl" },
			--
		-- 	-- enable syntax highlighting
			-- 	highlight = { enable = true },
			--
			-- 	-- optional features
			-- 	indent = { enable = true },
			-- 	incremental_selection = { enable = true },
			-- 	playground = { enable = true },
			-- })
      require'nvim-treesitter'.install { "lua", "python", "nu", "c", "cpp", "json", "bash", "gn", "idl" }
      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'nu', 'json','gn','idl' },
        callback = function() vim.treesitter.start() end,
      })
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
	},
}
