-- Opzioni base --------------------------------------------------------------

vim.opt.number = true                 -- Numeri di riga assoluti
vim.opt.relativenumber = true         -- Numeri relativi per movimenti rapidi
vim.opt.statuscolumn = "%s %l %r "    -- Colonna status minimale (segni + linea)
vim.g.mapleader = " "                 -- Leader su Space

local defaults = { noremap = true, silent = true }
local map = vim.keymap.set

-- Evita che lo space faccia cose strane prima del leader
map("n", " ", "<Nop>", { silent = true, remap = false })

-- Escape ergonomico in insert
map("i", "jj", "<esc>l", defaults)

-- Terminale
map("n", "<Leader>t", ":belowright split | terminal<CR>i", defaults) -- Apre il terminale in orizzontale IN INSERT MODE	
-- Doppio ESC nel terminal per tornare in normal mode
map("t", "<Esc>", [[<C-\><C-n>]], defaults)  

-- Comandi rapidi file -------------------------------------------------------

map('n', '<Leader>w', ':write<CR>', defaults)  -- Salva
map('n', '<Leader>a', ':wqa<CR>', defaults)    -- Salva tutto e chiudi
map('n', '<Leader>x', ':wq<CR>', defaults)     -- Salva e chiudi
map('n', '<Leader>q', ':q<CR>', defaults)      -- Chiudi
map('n', '<Leader>e', ':Explore<CR>', defaults)-- File explorer (netrw)

-- Clipboard di sistema ------------------------------------------------------
-- Queste sono le versioni "con apice" ( "+ ) mappate sul leader.
-- Separiamo universo Vim (registri interni) da universo sistema.

map({ "n", "v" }, "<leader>y", '"+y', defaults) -- Yank verso clipboard globale
map({ "n", "v" }, "<leader>d", '"+d', defaults) -- Delete/cut verso clipboard globale
map({ "n", "v" }, "<leader>c", '"+c', defaults) -- Change verso clipboard globale
map({ "n", "v" }, "<leader>p", '"+p', defaults) -- Paste verso clipboard globale

-- Disabilitazione frecce -----------------------------------------------------
-- Se premi le frecce, ti ricorda che esistono le vim motions.

local function no_arrows_msg(direction, hint)
  return function()
    vim.notify(
      "Usa le vim motions, non le frecce → prova '" .. hint .. "' per andare " .. direction,
      vim.log.levels.INFO,
      { title = "No arrows club" }
    )
  end
end

-- Normal mode
map("n", "<Up>",    no_arrows_msg("su",   "k"), { noremap = true })
map("n", "<Down>",  no_arrows_msg("giù",  "j"), { noremap = true })
map("n", "<Left>",  no_arrows_msg("a sinistra", "h"), { noremap = true })
map("n", "<Right>", no_arrows_msg("a destra",   "l"), { noremap = true })

-- Insert mode (ti riporta anche in normal mentalmente)
map("i", "<Up>",    no_arrows_msg("su",   "k"), { noremap = true })
map("i", "<Down>",  no_arrows_msg("giù",  "j"), { noremap = true })
map("i", "<Left>",  no_arrows_msg("a sinistra", "h"), { noremap = true })
map("i", "<Right>", no_arrows_msg("a destra",   "l"), { noremap = true })

