return {
	"kevinhwang91/nvim-ufo",
	dependencies = {
		"kevinhwang91/promise-async",
	},
	event = "VeryLazy",
	config = function()
		vim.o.foldcolumn = "1" -- '0' is not bad
		vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
		vim.o.foldlevelstart = 99
		vim.o.foldenable = true
		require("ufo").setup({
			provider_selector = function(_bufnr, _filetype, _buftype)
				return { "lsp", "indent" }
			end,
		})
		require("which-key").add({
			{ "zR", mode = { "n" }, require("ufo").openAllFolds, desc = "Open All Folds" },
			{ "zM", mode = { "n" }, require("ufo").closeAllFolds, desc = "Close all Folds" },
			{
				"K",
				mode = { "n" },
				function()
					local winid = require("ufo").peekFoldedLinesUnderCursor()
					if not winid then
						vim.lsp.buf.hover()
					end
				end,
				desc = "Peak Fold",
			},
		})
	end,
}
