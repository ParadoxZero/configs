return {
	{
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ':TSUpdate',
		config = function()
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
