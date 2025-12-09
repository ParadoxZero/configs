local map = vim.keymap.set
local opts = { noremap = true, silent = true }

map("n", "<c-l>", "<cmd>nohlsearch<CR>", opts)
map("i", "jj", "<Esc>", { noremap = true })

vim.api.nvim_create_autocmd("FileType", {
  pattern = "oil",
  callback = function(ev)
    local opts = { buffer = ev.buf, silent = true }
    vim.keymap.set("n", "q", "<cmd>close<CR>", opts)
    vim.keymap.set("n", "<Esc>", "<cmd>close<CR>", opts)
  end,
})

