-- Opzioni base --------------------------------------------------------------

vim.cmd([[set mouse=]])
vim.cmd([[set noswapfile]])
vim.cmd([[hi @lsp.type.number gui=italic]])
vim.opt.winborder = "rounded"
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.showtabline = 2
vim.opt.signcolumn = "yes:2"
vim.opt.wrap = false
vim.opt.cursorcolumn = false
vim.opt.ignorecase = true
vim.opt.smartindent = true
vim.opt.termguicolors = true
vim.opt.undofile = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.statuscolumn = "%s %l %r "
vim.g.mapleader = " "
vim.opt.showmatch = true
vim.opt.guicursor:append("c:ver25")
vim.g.format_on_save = true
vim.opt.wrap = true
vim.opt.exrc = true

-- Folding
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldlevel = 99
vim.opt.foldcolumn = "1"

-- Questo permette a nvim di leggere le modifiche fatte da OpenCode o altri agenti in "real-time"
vim.o.autoread = true

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold" }, {
	pattern = "*",
	command = "checktime",
})
-- Keymaps -------------------------------------------------------------------

local map = vim.keymap.set
local defaults = { noremap = true, silent = true }

-- Helper per aggiungere desc senza ripetere defaults
local function with_desc(desc)
	return vim.tbl_extend("force", defaults, { desc = desc })
end

-- Evita che lo space faccia cose strane prima del leader
map("n", " ", "<Nop>", { silent = true, remap = false, desc = "Leader noop" })

-- Escape ergonomico in insert
map("i", "jj", "<esc>l", with_desc("Escape insert mode"))

-- Terminale
map("n", "<Leader>tt", ":belowright split | terminal<CR>i", with_desc("Apri terminale (split orizzontale)"))

map("t", "<Esc>", [[<C-\><C-n>]], with_desc("Terminal → Normal mode"))

-- Apri le code actions in modalità normale o visual
map({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, with_desc("Code Action"))

-- Rename con LSP
map({ "n", "v" }, "<leader>rn", vim.lsp.buf.rename, with_desc("Rename"))

-- Comandi rapidi file -------------------------------------------------------

map("n", "<Leader>w", ":write<CR>", with_desc("Salva file"))

map("n", "<Leader>a", ":wqa<CR>", with_desc("Salva tutto e chiudi"))

map("n", "<Leader>x", ":wq<CR>", with_desc("Salva e chiudi"))

map("n", "<Leader>q", ":q<CR>", with_desc("Chiudi finestra"))

map("n", "<Leader>e", ":Oil --float<CR>", with_desc("Apri file explorer (Oil)"))

map(
	"n",
	"<leader>ff",
	function()
		require("mini.pick").builtin.files()
	end,
	with_desc("Find files")
)

map(
	"n",
	"<leader>fg",
	function()
		require("mini.pick").builtin.grep_live()
	end,
	with_desc("Live grep")
)

map(
	"n",
	"<leader>fb",
	function()
		require("mini.pick").builtin.buffers()
	end,
	with_desc("Find buffers")
)

-- Permette di aprire la mia config in modo rapido
map({ "n", "v", "x" }, "<leader>rc", "<Cmd>edit $MYVIMRC<CR>", { desc = "Modifica: " .. vim.fn.expand("$MYVIMRC") })

map({ "n", "v", "x" }, "<leader>lf", vim.lsp.buf.format, with_desc("Formatta il buffer corrente"))
map({ "n", "v", "x" }, "gl", vim.diagnostic.open_float, with_desc("Apri la diagnostica lsp per la riga corrente"))
-- Clipboard di sistema ------------------------------------------------------

map({ "n", "v" }, "<leader>y", '"+y', with_desc("Yank → clipboard sistema"))

map({ "n", "v" }, "<leader>d", '"+d', with_desc("Delete → clipboard sistema"))

map({ "n", "v" }, "<leader>c", '"+c', with_desc("Change → clipboard sistema"))

map({ "n", "v" }, "<leader>p", '"+p', with_desc("Paste da clipboard sistema"))

-- gitsigns
map({ "n" }, "<leader>tb", function()
	require('gitsigns').toggle_current_line_blame()
end, with_desc("Toggle line blame"))

-- Disabilitazione frecce -----------------------------------------------------

local function no_arrows_msg(direction, hint)
	return function()
		vim.notify(
			"Usa le vim motions, non le frecce → prova '" .. hint .. "' per andare " .. direction,
			vim.log.levels.INFO,
			{ title = "No arrows club" }
		)
	end
end

map("n", "<Up>", no_arrows_msg("su", "k"), with_desc("Disabilita freccia ↑"))

map("n", "<Down>", no_arrows_msg("giù", "j"), with_desc("Disabilita freccia ↓"))

map("n", "<Left>", no_arrows_msg("a sinistra", "h"), with_desc("Disabilita freccia ←"))

map("n", "<Right>", no_arrows_msg("a destra", "l"), with_desc("Disabilita freccia →"))

-- OpenCode ------------------------------------------------------------------

map(
	{ "n", "x" },
	"<C-a>",
	function()
		require("opencode").ask("@this: ", { submit = true })
	end,
	with_desc("Ask opencode…")
)

map(
	{ "n", "x" },
	"<C-x>",
	function()
		require("opencode").select()
	end,
	with_desc("Execute opencode action…")
)

map(
	{ "n", "t" },
	"<C-.>",
	function()
		require("opencode").toggle()
	end,
	with_desc("Toggle opencode")
)

map(
	{ "n", "x" },
	"go",
	function()
		return require("opencode").operator("@this ")
	end,
	vim.tbl_extend("force", defaults, { desc = "Add range to opencode", expr = true })
)

map(
	"n",
	"goo",
	function()
		return require("opencode").operator("@this ") .. "_"
	end,
	vim.tbl_extend("force", defaults, { desc = "Add line to opencode", expr = true })
)

map(
	"n",
	"<S-C-u>",
	function()
		require("opencode").command("session.half.page.up")
	end,
	with_desc("Scroll opencode up")
)

map(
	"n",
	"<S-C-d>",
	function()
		require("opencode").command("session.half.page.down")
	end,
	with_desc("Scroll opencode down")
)

-- Remap increment/decrement dato che <C-a> e <C-x> sono usati da opencode
map("n", "+", "<C-a>", with_desc("Increment under cursor"))

map("n", "-", "<C-x>", with_desc("Decrement under cursor"))

-- Plugins -------------------------------------------------------------------
local gh = function(name)
	return "https://github.com/" .. name
end

-- Tabella dei plugin
local plugins = {
	{
		repo = gh("nvim-mini/mini.pairs"),
		callback = function()
			require("mini.pairs").setup()
		end
	},
	{
		repo = gh("folke/tokyonight.nvim"),
		callback = function()
			vim.cmd.colorscheme("tokyonight")
		end
	},
	{
		repo = gh("nvim-mini/mini.indentscope"),
		callback = function()
			require("mini.indentscope").setup({
				symbol = "│",
				options = { try_as_border = true },
			})
		end
	},
	{
		repo = gh("nvim-mini/mini.clue"),
		callback = function()
			local miniclue = require('mini.clue')
			miniclue.setup({
				window = {
					delay = 200,
					config = { border = "rounded" },
				},
				triggers = {
					{ mode = 'n', keys = '<Leader>' },
					{ mode = 'x', keys = '<Leader>' },
				},
				clues = {
					miniclue.gen_clues.builtin_completion(),
					miniclue.gen_clues.g(),
					miniclue.gen_clues.marks(),
					miniclue.gen_clues.registers(),
					miniclue.gen_clues.windows(),
					miniclue.gen_clues.z(),
				},
			})
		end
	},
	{
		repo = gh("nvim-mini/mini.icons"),
		callback = function()
			require("mini.icons").setup()
		end
	},
	{
		repo = gh("nvim-mini/mini.pick"),
		callback = function()
			require("mini.pick").setup({
				window = {
					config = {
						border = "rounded",
					},
				},
			})
		end
	},
	{
		repo = gh("nickjvandyke/opencode.nvim")
	},
	{
		repo = gh("stevearc/oil.nvim"),
		callback = function()
			require("oil").setup({
				lsp_file_methods = {
					enabled = true,
					timeout_ms = 1000,
					autosave_changes = true,
				},
				columns = {
					"icon",
				},
				float = {
					max_width = 0.3,
					max_height = 0.6,
					border = "rounded",
				},
				win_options = {
					signcolumn = "yes:2",
				},
			})
		end
	},
	{
		repo = gh("refractalize/oil-git-status.nvim"),
		callback = function()
			require("oil-git-status").setup()
		end
	},
	{
		repo = gh("b0o/schemastore.nvim"),
	},
	{
		repo = gh("neovim/nvim-lspconfig"),
		callback = function()
			-- LSP Lua
			vim.lsp.config("lua_ls", {})
			vim.lsp.enable("lua_ls")

			-- LSP Python
			vim.lsp.config("basedpyright", { {
				settings = {
					python = {
						analysis = {
							diagnosticMode = "openFilesOnly",
						}
					}
				}
			} })
			vim.lsp.enable("basedpyright")

			-- LSP json
			vim.lsp.config("jsonls", {
				settings = {
					json = {
						validate = { enable = true },
						schemas = require('schemastore').json.schemas(),
					},
				},
			})
			vim.lsp.enable("jsonls")

			vim.lsp.enable('wc_language_server')

			vim.lsp.enable("biome")

			vim.lsp.enable("emmet_language_server")

			vim.lsp.enable("rumdl")
		end
	},
	{
		repo = gh("rafamadriz/friendly-snippets")
	},
	{
		repo = gh("saghen/blink.cmp"),
		callback = function()
			require("blink.cmp").setup({
				keymap = {
					preset = "default",

					-- Tab fa *select_and_accept* (prende voce selezionata)
					["<Tab>"] = { "select_and_accept", "fallback" },

					-- Shift+Tab torna indietro nelle snippet
					["<S-Tab>"] = { "snippet_backward", "fallback" },

					-- Enter (CR) conferma come in VSCode
					["<CR>"] = { "accept", "fallback" },
				},

				completion = {
					menu = {
						border = "rounded",
					},
					documentation = {
						auto_show = true,
					},
				},

				sources = {
					default = { 'lsp', 'path', 'snippets', 'buffer' },
				},

				fuzzy = {
					implementation = "prefer_rust_with_warning",
				}
			})
		end
	},
	{
		repo = gh("lewis6991/gitsigns.nvim"),
		callback = function()
			require('gitsigns').setup({
				current_line_blame = true,
				current_line_blame_opts = {
					delay = 300,
				},
			})
		end
	},
	{
		repo = gh("nvim-mini/mini.surround"),
		callback = function()
			require('mini.surround').setup()
		end
	},
	{
		repo = gh("nvim-treesitter/nvim-treesitter"),
		callback = function()
			require('nvim-treesitter').setup({
				ensure_installed = { "lua", "python", "json", "markdown", "vim", "vimdoc" },
				auto_install = true,
				highlight = {
					enable = true,
				},
				indent = {
					enable = true,
				},
			})
		end
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

-- Format on save

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp", { clear = true }),
	callback = function(args)
		vim.api.nvim_create_autocmd("BufWritePre", {
			buffer = args.buf,
			callback = function()
				vim.lsp.buf.format { async = false, id = args.data.client_id }
			end,
		})
	end
})

-- Auto save
vim.api.nvim_create_autocmd({ "FocusLost", "InsertLeave", "TextChanged" }, {
	command = "silent! update",
})
