return {
	"ibhagwan/fzf-lua",
	-- optional for icon support
	dependencies = { "nvim-tree/nvim-web-devicons" },
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
	---@diagnostics enable: missing-fields
	config = function()
		local wk = require("which-key")
		wk.add({
			{ "<Leader><Leader>", ":FzfLua buffers<CR>", desc = "Search open files" },

			{ "<Leader>s", group = "Search", desc = "Search Codebase" },
			{ "<Leader>sg", ":FzfLua git_status<CR>", desc = "Search modified files" },
			{ "<Leader>sh", ":FzfLua oldfiles<CR>", desc = "Search history" },
			{ "<Leader>ss", ":FzfLua treesitter<CR>", desc = "Search symbols in current file" },
			{ "<Leader>sl", ":FzfLua lines<CR>", desc = "Search lines in buffer" },
			{ "<Leader>sf", ":FzfLua files<CR>", desc = "Search files in dir" },
			{ "<Leader>sc", ":FzfLua grep<CR>", desc = "Search string in dir" },

			{ "<Leader>c", group = "Code Actions", desc = "LSP actions associated to buffer" },
			{ "<Leader>cr", ":FzfLua lsp_references<CR>", desc = "Find all references" },
			{ "<Leader>ci", ":FzfLua lsp_implementations<CR>", desc = "Find all implementations" },
			{ "<Leader>cc", ":FzfLua lsp_incoming_calls<CR>", desc = "Find all callers" },
			{ "<Leader>ce", ":Fzflua diagnostics_document<Cr>", desc = "Document Errors" },
		})
	end,
}
