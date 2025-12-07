local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- example maps
map("n", "<Esc>", "<cmd>nohlsearch<CR>", opts)
map("i", "jj", "<Esc>", { noremap = true })
