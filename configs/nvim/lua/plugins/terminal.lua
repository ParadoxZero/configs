return {
	"s1n7ax/nvim-terminal",
	config = function()
		vim.o.hidden = true
		require("nvim-terminal").setup({
			-- keymap to disable all the default keymaps
			disable_default_keymaps = true,
		})

		local wk = require("which-key")
		wk.add({
			--        {"<Leader>t", group = "Terminal", desc = "Manage Terminals"},
			{ "<Leader>t", ':lua NTGlobal["terminal"]:toggle()<cr>', desc = "Toggle Terminal" },
		})
	end,
	enabled = false,
}
