
-- Opzioni base --------------------------------------------------------------

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.statuscolumn = "%s %l %r "
vim.g.mapleader = " "
vim.opt.showmatch = true

-- Keymaps -------------------------------------------------------------------

local map = vim.keymap.set
local defaults = {noremap = true, silent = true}

-- Helper per aggiungere desc senza ripetere defaults
local function with_desc(desc)
    return vim.tbl_extend("force", defaults, {desc = desc})
end

-- Evita che lo space faccia cose strane prima del leader
map("n", " ", "<Nop>", {silent = true, remap = false, desc = "Leader noop"})

-- Escape ergonomico in insert
map("i", "jj", "<esc>l", with_desc("Escape insert mode"))

-- Terminale
map("n", "<Leader>t", ":belowright split | terminal<CR>i", with_desc("Apri terminale (split orizzontale)"))

map("t", "<Esc>", [[<C-\><C-n>]], with_desc("Terminal → Normal mode"))

-- Comandi rapidi file -------------------------------------------------------

map("n", "<Leader>w", ":write<CR>", with_desc("Salva file"))

map("n", "<Leader>a", ":wqa<CR>", with_desc("Salva tutto e chiudi"))

map("n", "<Leader>x", ":wq<CR>", with_desc("Salva e chiudi"))

map("n", "<Leader>q", ":q<CR>", with_desc("Chiudi finestra"))

map("n", "<Leader>e", ":Explore<CR>", with_desc("Apri file explorer (netrw)"))

-- Clipboard di sistema ------------------------------------------------------

map({"n", "v"}, "<leader>y", '"+y', with_desc("Yank → clipboard sistema"))

map({"n", "v"}, "<leader>d", '"+d', with_desc("Delete → clipboard sistema"))

map({"n", "v"}, "<leader>c", '"+c', with_desc("Change → clipboard sistema"))

map({"n", "v"}, "<leader>p", '"+p', with_desc("Paste da clipboard sistema"))

-- Disabilitazione frecce -----------------------------------------------------

local function no_arrows_msg(direction, hint)
    return function()
        vim.notify(
            "Usa le vim motions, non le frecce → prova '" .. hint .. "' per andare " .. direction,
            vim.log.levels.INFO,
            {title = "No arrows club"}
        )
    end
end

map("n", "<Up>", no_arrows_msg("su", "k"), with_desc("Disabilita freccia ↑"))

map("n", "<Down>", no_arrows_msg("giù", "j"), with_desc("Disabilita freccia ↓"))

map("n", "<Left>", no_arrows_msg("a sinistra", "h"), with_desc("Disabilita freccia ←"))

map("n", "<Right>", no_arrows_msg("a destra", "l"), with_desc("Disabilita freccia →"))

-- Plugins -------------------------------------------------------------------

vim.pack.add(
    {
        "https://github.com/nvim-mini/mini.pairs",
        "https://github.com/folke/tokyonight.nvim",
        "https://github.com/lukas-reineke/indent-blankline.nvim",
        "https://github.com/folke/which-key.nvim"
    }
)

require("mini.pairs").setup()
vim.cmd.colorscheme("tokyonight")
require("ibl").setup()

