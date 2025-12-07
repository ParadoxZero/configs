require("config.lazy")
require("config.keymaps")

vim.g.mapleader = " "
vim.opt.number = true

-- Tabs
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.smartindent = true

vim.opt.wrap = false

vim.opt.signcolumn = "yes"
vim.opt.colorcolumn = "80"

vim.opt.shell = 'nu'

vim.diagnostic.config({
  virtual_text = true,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true   -- optional: break on words, not characters
  end,
})
