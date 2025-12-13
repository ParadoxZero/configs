return {
	"folke/which-key.nvim",
	opts = {
		-- your configuration comes here
		-- or leave it empty to use the default settings
		-- refer to the configuration section below
	},
	lazy = false,
	keys = {
		{
			"<leader>?",
			function()
				require("which-key").show({ global = false })
			end,
			desc = "Buffer Local Keymaps (which-key)",
		},
	},
	config = function()
		require("which-key").add({
			{ "<Leader>c", group = "Code Actions", desc = "LSP actions associated to buffer" },
			{ "<Leader>s", group = "Search", desc = "Search Codebase" },
			{ "<Leader>g", group = "Git", desc = "Git related function" },
		})
	end,
}
