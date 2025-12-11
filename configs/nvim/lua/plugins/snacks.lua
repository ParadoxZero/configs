return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	---@type snacks.Config
	opts = {
		-- your configuration comes here
		-- or leave it empty to use the default settings
		-- refer to the configuration section below
		animate = { enabled = true },
		dashboard = { enabled = true },
		input = { enabled = true },
		quickfile = { enabled = true },
		notifier = { enabled = true },
		scope = { enabled = true },
		scroll = {
			enabled = true,
			folds = {
				open = true, -- show open  icons
				git_hl = true, -- use Git Signs hl for fold icons
			},
		},
		statuscolumn = { enabled = true },
		words = { enabled = true },
		gitbrowse = {
			open = function(url)
				vim.cmd({ cmd = "OSCYank", args = { url } })
			end,
		},
	},
	keys = {
		{ "<Leader>g", group = "Git", desc = "Git related function" },
		{
			"<Leader>gb",
			function()
				require("snacks").git.blame_line()
			end,
			desc = "Git blame current line",
		},
		{
			"<Leader>gr",
			function()
				require("snacks").gitbrowse()
			end,
			desc = "Copy remote url",
		},
	},
}
