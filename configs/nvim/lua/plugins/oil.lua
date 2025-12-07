return {
	{
		"stevearc/oil.nvim",
		---@module 'oil'
		---@type oil.SetupOpts
		opts = {},
		-- Optional dependencies
		dependencies = { { "nvim-mini/mini.icons", opts = {} } },
		-- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
		-- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
		lazy = false,
		config = function()
			function _G.get_oil_winbar()
				local bufnr = vim.api.nvim_win_get_buf(vim.g.statusline_winid)
				local dir = require("oil").get_current_dir(bufnr)
				if dir then
					return vim.fn.fnamemodify(dir, ":~")
				else
					-- If there is no current directory (e.g. over ssh), just show the buffer name
					return vim.api.nvim_buf_get_name(0)
				end
			end

			require("oil").setup({
				view_options = {
					show_hidden = true,
				},
				win_options = {
					winbar = "%!v:lua.get_oil_winbar()",
					signcolumn = "yes:2",
				},
				float = {
					padding = 5,
					max_width = 0.8,
					max_height = 0.6,
					border = "rounded",
					-- optionally override the oil buffers window title with custom function: fun(winid: integer): string
					get_win_title = function(_winid)
						return "Oil"
					end,
				},
			})
			local function open_oil_here()
				require("oil").open_float()
			end
			local wk = require("which-key")
			wk.add({
				{ "<Leader>e", open_oil_here, desc = "Open current folder" },
			})
		end,
	},
	{
		"refractalize/oil-git-status.nvim",

		dependencies = {
			"stevearc/oil.nvim",
		},

		config = true,
	},
}
