return {
	"folke/trouble.nvim",
  lazy = true,
	opts = {
		modes = {
			symbols = {
				desc = "document symbols",
				mode = "lsp_document_symbols",
				focus = false,
				win = { 
          position = "right", 
          width = "40%"
        },
			},
		},
	}, -- for default options, refer to the configuration section for custom setup.
	cmd = "Trouble",
	keys = {
    { "<Leader>x", group = "Trouble windows", desc = "Open trouble windows"},
		{
			"<leader>xx",
			"<cmd>Trouble diagnostics toggle<cr>",
			desc = "Diagnostics (Trouble)",
		},
		{
			"<leader>xX",
			"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
			desc = "Buffer Diagnostics (Trouble)",
		},
		{
			"<leader>cl",
			"<cmd>Trouble lsp toggle focus=true<cr>",
			desc = "LSP Definitions / references / ... (Trouble)",
		},
		{
			"<leader>xL",
			"<cmd>Trouble loclist toggle<cr>",
			desc = "Location List (Trouble)",
		},
		{
			"<leader>xQ",
			"<cmd>Trouble qflist toggle<cr>",
			desc = "Quickfix List (Trouble)",
		},
	},
  enable = false
}
