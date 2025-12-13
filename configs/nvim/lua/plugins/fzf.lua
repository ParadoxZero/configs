return {
	"ibhagwan/fzf-lua",
	-- optional for icon support
	dependencies = { "nvim-tree/nvim-web-devicons" },
	lazy = true,
	-- or if using mini.icons/mini.nvim
	-- dependencies = { "nvim-mini/mini.icons" },
	---@module "fzf-lua"
	---@type fzf-lua.Config|{}
	---@diagnostics disable: missing-fields
	opts = {
		keymap = {
			builtin = {
				-- move selection
				["<up>"] = "up",
				["<down>"] = "down",
			},
		},
		grep = {
			rg_opts = table.concat({
				"--column",
				"--line-number",
				"--no-heading",
				"--color=always",
				"--smart-case",
				"--max-columns=4096",
				"",
			}, " "),
		},
	},
	keys = {
		{ "<Leader><Tab>", ":FzfLua buffers<CR>", desc = "Search open files" },

		{ "<Leader>sg", ":FzfLua git_status<CR>", desc = "Search modified files" },
		{ "<Leader>sh", ":FzfLua oldfiles<CR>", desc = "Search history" },
		{ "<Leader>ss", ":FzfLua treesitter<CR>", desc = "Search symbols in current file" },
		{ "<Leader>sl", ":FzfLua blines<CR>", desc = "Search lines in buffer" },
		{ "<Leader>sf", ":FzfLua files<CR>", desc = "Search files in dir" },
		{ "<Leader>sc", ":FzfLua grep<CR>", desc = "Search string in dir" },

		{ "<Leader>cr", ":FzfLua lsp_finder<CR>", desc = "Find all references" },
		{ "<Leader>ci", ":FzfLua lsp_implementations<CR>", desc = "Find all implementations" },
		{ "<Leader>cc", ":FzfLua lsp_incoming_calls<CR>", desc = "Find all callers" },
		{ "<Leader>ce", ":Fzflua diagnostics_document<Cr>", desc = "Document Errors" },
	},
	config = function()
	end,
}
