local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- example maps
map("n", "<c-l>", "<cmd>nohlsearch<CR>", opts)
map("i", "jj", "<Esc>", { noremap = true })
