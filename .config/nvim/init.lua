-- init.lua -------------------------------------------------------------

-- ================================
-- 1️⃣ Bootstrap lazy.nvim
-- ================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- ================================
-- 2️⃣ Vim options
-- ================================
vim.opt.mouse = ""
vim.opt.swapfile = false
vim.opt.winborder = "rounded"
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.showtabline = 2
vim.opt.signcolumn = "yes:2"
vim.opt.wrap = true
vim.opt.cursorcolumn = false
vim.opt.ignorecase = true
vim.opt.smartindent = true
vim.opt.termguicolors = true
vim.opt.undofile = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.statuscolumn = "%s %l %r "
vim.opt.showmatch = true
vim.opt.exrc = true
vim.opt.autoread = true

-- Folding
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldlevel = 99
vim.opt.foldcolumn = "1"

-- Leader
vim.g.mapleader = " "
vim.g.format_on_save = true
vim.opt.guicursor:append("c:ver25")

-- Auto-read (external changes)
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold" }, {
	pattern = "*",
	command = "checktime",
})

-- Auto-save
vim.api.nvim_create_autocmd({ "FocusLost", "InsertLeave", "TextChanged" }, {
	command = "silent! update",
})

-- ================================
-- 3️⃣ Keymaps
-- ================================
local function map(mode, lhs, rhs, opts)
	vim.keymap.set(mode, lhs, rhs, vim.tbl_extend("force", { noremap = true, silent = true }, opts or {}))
end

-- Leader
map("n", " ", "<Nop>", { desc = "Leader noop" })
map("i", "jj", "<esc>l", { desc = "Escape insert mode" })

-- Terminal
map("n", "<Leader>tt", ":belowright split | terminal<CR>i", { desc = "Apri terminale (split)" })
map("t", "<Esc>", [[<C-\><C-n>]], { desc = "Terminal → Normal mode" })

-- LSP
map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
map({ "n", "v" }, "<leader>rn", vim.lsp.buf.rename, { desc = "Rename" })
map({ "n", "v", "x" }, "gl", vim.diagnostic.open_float, { desc = "Apri diagnostica LSP per la riga corrente" })

-- File commands
map("n", "<Leader>w", ":write<CR>", { desc = "Salva file" })
map("n", "<Leader>a", ":wqa<CR>", { desc = "Salva tutto e chiudi" })
map("n", "<Leader>x", ":wq<CR>", { desc = "Salva e chiudi" })
map("n", "<Leader>q", ":q<CR>", { desc = "Chiudi finestra" })
map("n", "<Leader>e", ":Oil --float<CR>", { desc = "Apri file explorer (Oil)" })
map({ "n", "v", "x" }, "<leader>rc", "<Cmd>edit $MYVIMRC<CR>", { desc = "Modifica: " .. vim.fn.expand("$MYVIMRC") })

-- Mini.pick
map("n", "<leader>ff", function()
	require("mini.pick").builtin.files()
end, { desc = "Find files" })
map("n", "<leader>fg", function()
	require("mini.pick").builtin.grep_live()
end, { desc = "Live grep" })
map("n", "<leader>fb", function()
	require("mini.pick").builtin.buffers()
end, { desc = "Find buffers" })

-- Clipboard
map({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank → clipboard sistema" })
map({ "n", "v" }, "<leader>d", '"+d', { desc = "Delete → clipboard sistema" })
map({ "n", "v" }, "<leader>c", '"+c', { desc = "Change → clipboard sistema" })
map({ "n", "v" }, "<leader>p", '"+p', { desc = "Paste da clipboard sistema" })

-- Gitsigns
map("n", "<leader>tb", function()
	require("gitsigns").toggle_current_line_blame()
end, { desc = "Toggle line blame" })

-- Markdown Preview
map("n", "<Leader>mp", ":MarkdownPreviewToggle<CR>", { desc = "Markdown Preview toggle" })
map("n", "<Leader>ms", ":MarkdownPreviewStop<CR>", { desc = "Markdown Preview stop" })

-- Disable arrow keys
local function no_arrows(direction, hint)
	return function()
		vim.notify(
			"Usa le vim motions, non le frecce → prova '" .. hint .. "' per andare " .. direction,
			vim.log.levels.INFO,
			{ title = "No arrows club" }
		)
	end
end
map("n", "<Up>", no_arrows("su", "k"), { desc = "Disabilita freccia ↑" })
map("n", "<Down>", no_arrows("giù", "j"), { desc = "Disabilita freccia ↓" })
map("n", "<Left>", no_arrows("a sinistra", "h"), { desc = "Disabilita freccia ←" })
map("n", "<Right>", no_arrows("a destra", "l"), { desc = "Disabilita freccia →" })

-- OpenCode
local opencode = function(action, opts)
	return function()
		require("opencode")[action](opts)
	end
end

map({ "n", "x" }, "<C-a>", opencode("ask", { prompt = "@this: ", submit = true }), { desc = "Ask opencode…" })
map({ "n", "x" }, "<C-x>", opencode("select"), { desc = "Execute opencode action…" })
map({ "n", "t" }, "<C-.>", opencode("toggle"), { desc = "Toggle opencode" })
map({ "n", "x" }, "go", function()
	return require("opencode").operator("@this ")
end, { desc = "Add range to opencode", expr = true })
map("n", "goo", function()
	return require("opencode").operator("@this ") .. "_"
end, { desc = "Add line to opencode", expr = true })
map("n", "<S-C-u>", opencode("command", "session.half.page.up"), { desc = "Scroll opencode up" })
map("n", "<S-C-d>", opencode("command", "session.half.page.down"), { desc = "Scroll opencode down" })

-- Increment/decrement (remap because C-a/C-x used by OpenCode)
map("n", "+", "<C-a>", { desc = "Increment under cursor" })
map("n", "-", "<C-x>", { desc = "Decrement under cursor" })

-- Lazy
map("n", "<Leader>L", "<Cmd>Lazy<CR>", { desc = "Show Lazy status" })
map("n", "<Leader>lc", "<Cmd>Lazy check<CR>", { desc = "Lazy check updates" })
map("n", "<Leader>lu", "<Cmd>Lazy update<CR>", { desc = "Lazy update plugins" })
map("n", "<Leader>lx", "<Cmd>Lazy sync<CR>", { desc = "Lazy sync plugins" })

-- ================================
-- 4️⃣ Plugin setup (lazy.nvim)
-- ================================
local gh = function(name)
	return "https://github.com/" .. name
end

local plugins = {
	-- Mini plugins (simple setup)
	{
		gh("nvim-mini/mini.pairs"),
		config = function()
			require("mini.pairs").setup()
		end,
	},
	{
		gh("nvim-mini/mini.indentscope"),
		config = function()
			require("mini.indentscope").setup({ symbol = "│", options = { try_as_border = true } })
		end,
	},
	{
		gh("nvim-mini/mini.icons"),
		config = function()
			require("mini.icons").setup()
		end,
	},
	{
		gh("nvim-mini/mini.surround"),
		config = function()
			require("mini.surround").setup()
		end,
	},

	-- Mini.pick with border config
	{
		gh("nvim-mini/mini.pick"),
		config = function()
			require("mini.pick").setup({ window = { config = { border = "rounded" } } })
		end,
	},

	-- Mini.clue
	{
		gh("nvim-mini/mini.clue"),
		config = function()
			require("mini.clue").setup({
				window = { delay = 200, config = { border = "rounded" } },
				triggers = { { mode = "n", keys = "<Leader>" }, { mode = "x", keys = "<Leader>" } },
				clues = {
					require("mini.clue").gen_clues.builtin_completion(),
					require("mini.clue").gen_clues.g(),
					require("mini.clue").gen_clues.marks(),
					require("mini.clue").gen_clues.registers(),
					require("mini.clue").gen_clues.windows(),
					require("mini.clue").gen_clues.z(),
				},
			})
		end,
	},

	-- Colorscheme
	{
		gh("folke/tokyonight.nvim"),
		config = function()
			vim.cmd.colorscheme("tokyonight")
		end,
	},

	-- File explorers
	{ gh("nickjvandyke/opencode.nvim") },
	{
		gh("refractalize/oil-git-status.nvim"),
		config = function()
			require("oil-git-status").setup()
		end,
	},
	{
		gh("stevearc/oil.nvim"),
		config = function()
			require("oil").setup({
				lsp_file_methods = { enabled = true, timeout_ms = 1000, autosave_changes = true },
				columns = { "icon" },
				float = { max_width = 0.3, max_height = 0.6, border = "rounded" },
				win_options = { signcolumn = "yes:2" },
			})
		end,
	},

	-- LSP & snippets
	{ gh("b0o/schemastore.nvim") },
	{ gh("rafamadriz/friendly-snippets") },
	{
		gh("neovim/nvim-lspconfig"),
		config = function()
			local lsp = vim.lsp
			lsp.config("lua_ls", {})
			lsp.enable("lua_ls")
			lsp.config("basedpyright", { settings = { python = { analysis = { diagnosticMode = "openFilesOnly" } } } })
			lsp.enable("basedpyright")
			lsp.config("jsonls", {
				settings = {
					json = { validate = { enable = true }, schemas = require("schemastore").json.schemas() },
				},
			})
			lsp.enable("jsonls")
			lsp.enable("wc_language_server")
			lsp.enable("biome")
			lsp.enable("emmet_language_server")
			lsp.enable("rumdl")
			lsp.enable("eslint")
		end,
	},

	-- Completion
	{
		gh("saghen/blink.cmp"),
		build = "cargo build --release",
		config = function()
			require("blink.cmp").setup({
				keymap = {
					preset = "default",
					["<Tab>"] = { "select_and_accept", "fallback" },
					["<S-Tab>"] = { "snippet_backward", "fallback" },
					["<CR>"] = { "accept", "fallback" },
				},
				completion = { menu = { border = "rounded" }, documentation = { auto_show = true } },
				sources = { default = { "lsp", "path", "snippets", "buffer" } },
				fuzzy = { implementation = "prefer_rust_with_warning" },
			})
		end,
	},

	-- Git
	{
		gh("lewis6991/gitsigns.nvim"),
		config = function()
			require("gitsigns").setup({ current_line_blame = true, current_line_blame_opts = { delay = 300 } })
		end,
	},

	-- Treesitter
	{
		gh("nvim-treesitter/nvim-treesitter"),
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter").setup({
				ensure_installed = { "lua", "python", "json", "markdown", "vim", "vimdoc" },
				auto_install = true,
				highlight = { enable = true },
				indent = { enable = true },
			})
		end,
	},

	-- Markdown Preview
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		ft = { "markdown" },
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
	},

	-- Formatter
	{
		gh("stevearc/conform.nvim"),
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					python = { "ruff_fix", "ruff_format" },
					javascript = { "biome", "prettier" },
					typescript = { "biome", "prettier" },
					lua = { "stylua" },
				},
			})
		end,
	},
}

require("lazy").setup(plugins, {
	defaults = { lazy = false, version = false },
	install = { colorscheme = { "tokyonight" } },
	checker = { enabled = true, notify = true },
})

-- ================================
-- 5️⃣ Format on save
-- ================================
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function(args)
		require("conform").format({ bufnr = args.buf })
	end,
})

