local defaults = { noremap = true, silent = true }
local map = vim.keymap.set

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.statuscolumn = "%s %l %r "
vim.g.mapleader = " "

map("n", " ", "<Nop>", { silent = true, remap = false })
map("i", "jj", "<esc>l", defaults)
map('n', '<Leader>w', ':write<CR>')
map('n', '<Leader>a', ':wqa<CR>')
map('n', '<Leader>x', ':wq<CR>')
map('n', '<Leader>q', ':q<CR>')
map('n', '<Leader>e', ':Explore<CR>')

