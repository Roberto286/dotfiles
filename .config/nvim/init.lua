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

map("n", "<Leader>e", ":30 Lexplore<CR>", with_desc("Apri file explorer (netrw)"))

map("n", "<leader>ff", function() require('fzf-lua').files() end,
  with_desc("Find files"))

map("n", "<leader>fg", function() require('fzf-lua').live_grep() end,
  with_desc("Live grep"))

map("n", "<leader>fb", function() require('fzf-lua').buffers() end,
  with_desc("Find buffers"))


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

-- OpenCode ------------------------------------------------------------------

map({"n", "x"}, "<C-a>", function() require("opencode").ask("@this: ", { submit = true }) end, with_desc("Ask opencode…"))

map({"n", "x"}, "<C-x>", function() require("opencode").select() end, with_desc("Execute opencode action…"))

map({"n", "t"}, "<C-.>", function() require("opencode").toggle() end, with_desc("Toggle opencode"))

map({"n", "x"}, "go", function() return require("opencode").operator("@this ") end,
  vim.tbl_extend("force", defaults, {desc = "Add range to opencode", expr = true}))

map("n", "goo", function() return require("opencode").operator("@this ") .. "_" end,
  vim.tbl_extend("force", defaults, {desc = "Add line to opencode", expr = true}))

map("n", "<S-C-u>", function() require("opencode").command("session.half.page.up") end, with_desc("Scroll opencode up"))

map("n", "<S-C-d>", function() require("opencode").command("session.half.page.down") end, with_desc("Scroll opencode down"))

-- Remap increment/decrement dato che <C-a> e <C-x> sono usati da opencode
map("n", "+", "<C-a>", with_desc("Increment under cursor"))

map("n", "-", "<C-x>", with_desc("Decrement under cursor"))


-- Plugins -------------------------------------------------------------------
local gh = function(name) return "https://github.com/" .. name end

-- Tabella dei plugin
local plugins = {
  {
    repo = gh("nvim-mini/mini.pairs"),
    callback = function() require("mini.pairs").setup() end,
  },
  {
    repo = gh("folke/tokyonight.nvim"),
    callback = function() vim.cmd.colorscheme("tokyonight") end,
  },
  {
    repo = gh("lukas-reineke/indent-blankline.nvim"),
    callback = function() require('ibl').setup() end,
  },
  {
    repo = gh("folke/which-key.nvim"),
    callback = function() require("which-key").setup({}) end,
  },
  {
    repo = gh("nvim-mini/mini.icons"),
    callback = function() require('mini.icons').setup() end,
  },
  {
    repo = gh("ibhagwan/fzf-lua"),
    callback = function() require('fzf-lua').setup() end, 
  },
  {
    repo = gh("nickjvandyke/opencode.nvim"),
  }
}

-- Ciclo su tutti i plugin
for _, plugin in ipairs(plugins) do
  local ok, err = pcall(vim.pack.add, { plugin.repo })
  if not ok then
    vim.notify("Errore caricamento " .. plugin.repo .. ": " .. err, vim.log.levels.WARN)
  elseif plugin.callback then
    ok, err = pcall(plugin.callback)
    if not ok then
      vim.notify("Errore setup " .. plugin.repo .. ": " .. err, vim.log.levels.WARN)
    end
  end
end

