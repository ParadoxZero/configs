return {
	"dmtrKovalenko/fff.nvim",
	build = function()
		-- this will download prebuild binary or try to use existing rustup toolchain to build from source
		-- (if you are using lazy you can use gb for rebuilding a plugin if needed)
		require("fff.download").download_or_build_binary()
	end,
	-- if you are using nixos
	-- build = "nix run .#release",
	opts = { -- (optional)
		debug = {
			enabled = true, -- we expect your collaboration at least during the beta
			show_scores = true, -- to help us optimize the scoring system, feel free to share your scores!
		},
	},
	-- No need to lazy-load with lazy.nvim.
	-- This plugin initializes itself lazily.
	lazy = false,
	keys = {
		{
			"fff", -- try it if you didn't it is a banger keybinding for a picker
			function()
				require("fff").find_files()
			end,
			desc = "FFFind files from current dir",
		},
		{
			"ffg", -- try it if you didn't it is a banger keybinding for a picker
			function()
				require("fff").find_in_git_root()
			end,
			desc = "FFFind files from git root",
		},
		{
			"ffr", -- try it if you didn't it is a banger keybinding for a picker
			function()
				if vim.g.my_root_dir == nil then
					return
				else
					require("fff").find_files_in_dir(vim.g.my_root_dir)
				end
			end,
			desc = "FFFind files from root",
		},
		{
			"<leader>r",
			function()
				vim.g.my_root_dir = require("oil").get_current_dir()
			end,
			desc = "Set the root find directory",
		},
	},
}
