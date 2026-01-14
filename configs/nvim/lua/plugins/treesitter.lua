return {
	{
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ':TSUpdate',
		config = function()
      -- require('nvim-treesitter').install{ "lua", "python", "nu", "c", "cpp", "json", "bash", "gn", "idl" }
      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'json','gn','idl', "lua", "nu" },
        callback = function(event) 
          local ft = vim.bo[event.buf].ft
          local lang = vim.treesitter.language.get_lang(ft)
          pcall(vim.treesitter.start, event.buf)
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
        end,
      })
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
	},
}
