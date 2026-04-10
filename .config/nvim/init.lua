-- init.lua -------------------------------------------------------------

-- ================================
-- 1️⃣ Bootstrap lazy.nvim
-- ================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
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

local function get_project_root()
	local cwd = vim.fn.getcwd()
	local root = vim.fs.find({ ".git" }, { upward = true })[1]
	return root and vim.fs.dirname(root) or cwd
end

-- ================================
-- 2️⃣ Vim options
-- ================================
vim.opt.swapfile = false
vim.opt.winborder = "rounded"
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.signcolumn = "number"
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
vim.opt.winbar = "%{expand('%:p')}"

-- Folding
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldlevel = 99
vim.opt.foldcolumn = "1"

-- Leader (must be set before lazy)
vim.g.mapleader = " "

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
map("n", "<Leader>tt", ":belowright split | terminal<CR>i", { desc = "Open terminal (split)" })
map("t", "<Esc>", [[<C-\><C-n>]], { desc = "Terminal → Normal mode" })

-- LSP
map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
map({ "n", "v" }, "<leader>rn", vim.lsp.buf.rename, { desc = "Rename" })
map("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
map("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
map("n", "gr", vim.lsp.buf.references, { desc = "Go to references" })
map("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
map("n", "K", vim.lsp.buf.hover, { desc = "Hover documentation" })
map("n", "gO", vim.lsp.buf.document_symbol, { desc = "Document symbols" })
map({ "n", "v", "x" }, "gl", vim.diagnostic.open_float, { desc = "Open LSP diagnostics for current line" })
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })

-- File commands
map("n", "<Leader>w", ":write<CR>", { desc = "Save file" })
map("n", "<Leader>a", ":wqa<CR>", { desc = "Save all and quit" })
map("n", "<Leader>x", ":wq<CR>", { desc = "Save and quit" })
map("n", "<Leader>q", ":q<CR>", { desc = "Close window" })
map("n", "<leader>e", "<CMD>Oil --float<CR>", { desc = "Open Oil" })
map({ "n", "v", "x" }, "<leader>rc", "<Cmd>edit $MYVIMRC<CR>", { desc = "Edit: " .. vim.fn.expand("$MYVIMRC") })

-- Copy full path to clipboard
vim.keymap.set("n", "<leader>fp", ':let @+ = expand("%:p")<CR>', { desc = "Copy full path" })

-- Copy relative path to clipboard
vim.keymap.set("n", "<leader>fr", ':let @+ = expand("%")<CR>', { desc = "Copy relative path" })

-- Copy filename only
vim.keymap.set("n", "<leader>fn", ':let @+ = expand("%:t")<CR>', { desc = "Copy filename" })

-- Telescope
map("n", "<leader>ff", function()
	require("telescope.builtin").find_files({
		cwd = get_project_root(),
	})
end, { desc = "Find files" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { desc = "Live grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "Find buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "Help tags" })
map("n", "<leader>fr", "<cmd>Telescope oldfiles<CR>", { desc = "Recent files" })
map("n", "<leader>fc", "<cmd>Telescope commands<CR>", { desc = "Commands" })
map("n", "<leader>fk", "<cmd>Telescope keymaps<CR>", { desc = "Keymaps" })

-- Clipboard
map({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank → system clipboard" })
map({ "n", "v" }, "<leader>d", '"+d', { desc = "Delete → system clipboard" })
map({ "n", "v" }, "<leader>c", '"+c', { desc = "Change → system clipboard" })
map({ "n", "v" }, "<leader>p", '"+p', { desc = "Paste from system clipboard" })

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
			"Use vim motions → try '" .. hint .. "' to go " .. direction,
			vim.log.levels.INFO,
			{ title = "No arrows club" }
		)
	end
end
map("n", "<Up>", no_arrows("up", "k"), { desc = "Disable ↑" })
map("n", "<Down>", no_arrows("down", "j"), { desc = "Disable ↓" })
map("n", "<Left>", no_arrows("left", "h"), { desc = "Disable ←" })
map("n", "<Right>", no_arrows("right", "l"), { desc = "Disable →" })

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

-- Increment/decrement (remapped because C-a/C-x used by OpenCode)
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
local plugins = {
	-- Colorscheme — must load first, never lazy
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			vim.cmd.colorscheme("tokyonight")
		end,
	},

	-- Mini plugins
	{ "echasnovski/mini.pairs", event = "InsertEnter", opts = {} },
	{
		"echasnovski/mini.indentscope",
		event = "BufReadPost",
		opts = { symbol = "│", options = { try_as_border = true } },
	},
	{ "echasnovski/mini.icons", lazy = false, opts = {} },
	{ "echasnovski/mini.surround", event = "BufReadPost", opts = {} },
	-- Telescope
	{
		"nvim-telescope/telescope.nvim",
		event = "VeryLazy",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			local telescope = require("telescope")
			local actions = require("telescope.actions")
			telescope.setup({
				defaults = {
					mappings = {
						i = {
							["<C-j>"] = actions.move_selection_next,
							["<C-k>"] = actions.move_selection_previous,
							["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
						},
					},
					borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
				},
				pickers = {
					find_files = {
						theme = "dropdown",
						previewer = false,
					},
					buffers = {
						sort_mru = true,
						sort_lastused = true,
					},
				},
			})
			-- Carica l'estensione fzf-native
			telescope.load_extension("fzf")
		end,
	},
	{
		"echasnovski/mini.clue",
		event = "VeryLazy",
		config = function()
			local clue = require("mini.clue")
			clue.setup({
				window = { delay = 200 },
				triggers = {
					{ mode = "n", keys = "<Leader>" },
					{ mode = "x", keys = "<Leader>" },
				},
				clues = {
					clue.gen_clues.builtin_completion(),
					clue.gen_clues.g(),
					clue.gen_clues.marks(),
					clue.gen_clues.registers(),
					clue.gen_clues.windows(),
					clue.gen_clues.z(),
				},
			})
		end,
	},

	-- File explorer
	{
		"stevearc/oil.nvim",
		cmd = "Oil",
		opts = {
			lsp_file_methods = { enabled = true, timeout_ms = 1000, autosave_changes = true },
			columns = { "icon" },
			float = { max_width = 0.3, max_height = 0.6 },
			-- border inherited from vim.opt.winborder
		},
	},

	-- OpenCode
	{ "nickjvandyke/opencode.nvim", lazy = true },

	-- LSP
	{ "b0o/schemastore.nvim", lazy = true },
	{ "rafamadriz/friendly-snippets", lazy = true },
	{
		"neovim/nvim-lspconfig",
		event = "BufReadPre",
		dependencies = { "b0o/schemastore.nvim" },
		config = function()
			local lsp = vim.lsp
			lsp.config("lua_ls", {})
			lsp.enable("lua_ls")
			lsp.config("basedpyright", {
				settings = { python = { analysis = { diagnosticMode = "openFilesOnly" } } },
			})
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
			lsp.enable("vtsls")
		end,
	},

	-- Completion
	{
		"saghen/blink.cmp",
		event = "InsertEnter",
		build = "cargo build --release",
		dependencies = { "rafamadriz/friendly-snippets" },
		opts = {
			keymap = {
				preset = "default",
				["<Tab>"] = { "select_and_accept", "fallback" },
				["<S-Tab>"] = { "snippet_backward", "fallback" },
				["<CR>"] = { "accept", "fallback" },
			},
			completion = { documentation = { auto_show = true } },
			-- menu border inherited from vim.opt.winborder
			sources = { default = { "lsp", "path", "snippets", "buffer" } },
			fuzzy = { implementation = "prefer_rust_with_warning" },
		},
	},

	-- Git
	{
		"lewis6991/gitsigns.nvim",
		event = "BufReadPre",
		opts = { current_line_blame = true, current_line_blame_opts = { delay = 300 } },
	},

	-- Treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		event = "BufReadPost",
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
		ft = "markdown",
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
	},

	-- Formatter
	{
		"stevearc/conform.nvim",
		event = "BufWritePre",
		opts = {
			format_on_save = { timeout_ms = 500, lsp_format = "fallback" },
			formatters_by_ft = {
				python = { "ruff_fix", "ruff_format" },
				javascript = { "biome", "prettier", stop_after_first = true },
				typescript = { "biome", "prettier", stop_after_first = true },
				lua = { "stylua" },
			},
			formatters = {
				biome = {
					require_cwd = true,
				},
				prettier = {
					require_cwd = true,
				},
			},
		},
	},

	-- Line numbers
	{ "shrynx/line-numbers.nvim", event = "BufReadPost", opts = {} },
}

require("lazy").setup(plugins, {
	install = { colorscheme = { "tokyonight" } },
	checker = { enabled = true, notify = true },
})
