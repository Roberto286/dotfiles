-- init.lua -------------------------------------------------------------

-- ================================
-- 1️⃣ Bootstrap lazy.nvim
-- ================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system(
        {
            "git",
            "clone",
            "--filter=blob:none",
            "https://github.com/folke/lazy.nvim.git",
            "--branch=stable",
            lazypath
        }
    )
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
vim.g.mapleader = " "
vim.opt.showmatch = true
vim.opt.guicursor:append("c:ver25")
vim.g.format_on_save = true
vim.opt.exrc = true

-- Folding
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldlevel = 99
vim.opt.foldcolumn = "1"

-- Auto-read changes from external tools
vim.o.autoread = true
vim.api.nvim_create_autocmd(
    {"FocusGained", "BufEnter", "CursorHold"},
    {
        pattern = "*",
        command = "checktime"
    }
)

-- Auto-save
vim.api.nvim_create_autocmd(
    {"FocusLost", "InsertLeave", "TextChanged"},
    {
        command = "silent! update"
    }
)

-- ================================
-- 3️⃣ Keymaps
-- ================================
local map = vim.keymap.set
local defaults = {noremap = true, silent = true}
local function with_desc(desc)
    return vim.tbl_extend("force", defaults, {desc = desc})
end

-- Leader
map("n", " ", "<Nop>", with_desc("Leader noop"))
map("i", "jj", "<esc>l", with_desc("Escape insert mode"))

-- Terminal
map("n", "<Leader>tt", ":belowright split | terminal<CR>i", with_desc("Apri terminale (split)"))
map("t", "<Esc>", [[<C-\><C-n>]], with_desc("Terminal → Normal mode"))

-- LSP
map({"n", "v"}, "<leader>ca", vim.lsp.buf.code_action, with_desc("Code Action"))
map({"n", "v"}, "<leader>rn", vim.lsp.buf.rename, with_desc("Rename"))

-- File commands
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

-- Edit config
map({"n", "v", "x"}, "<leader>rc", "<Cmd>edit $MYVIMRC<CR>", {desc = "Modifica: " .. vim.fn.expand("$MYVIMRC")})
map({"n", "v", "x"}, "<leader>lf", vim.lsp.buf.format, with_desc("Formatta il buffer corrente"))
map({"n", "v", "x"}, "gl", vim.diagnostic.open_float, with_desc("Apri diagnostica LSP per la riga corrente"))

-- System clipboard
map({"n", "v"}, "<leader>y", '"+y', with_desc("Yank → clipboard sistema"))
map({"n", "v"}, "<leader>d", '"+d', with_desc("Delete → clipboard sistema"))
map({"n", "v"}, "<leader>c", '"+c', with_desc("Change → clipboard sistema"))
map({"n", "v"}, "<leader>p", '"+p', with_desc("Paste da clipboard sistema"))

-- Gitsigns
map(
    "n",
    "<leader>tb",
    function()
        require("gitsigns").toggle_current_line_blame()
    end,
    with_desc("Toggle line blame")
)

-- Disable arrow keys
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

-- OpenCode
map(
    {"n", "x"},
    "<C-a>",
    function()
        require("opencode").ask("@this: ", {submit = true})
    end,
    with_desc("Ask opencode…")
)
map(
    {"n", "x"},
    "<C-x>",
    function()
        require("opencode").select()
    end,
    with_desc("Execute opencode action…")
)
map(
    {"n", "t"},
    "<C-.>",
    function()
        require("opencode").toggle()
    end,
    with_desc("Toggle opencode")
)
map(
    {"n", "x"},
    "go",
    function()
        return require("opencode").operator("@this ")
    end,
    vim.tbl_extend("force", defaults, {desc = "Add range to opencode", expr = true})
)
map(
    "n",
    "goo",
    function()
        return require("opencode").operator("@this ") .. "_"
    end,
    vim.tbl_extend("force", defaults, {desc = "Add line to opencode", expr = true})
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

-- Increment/decrement (remap because C-a/C-x used by OpenCode)
map("n", "+", "<C-a>", with_desc("Increment under cursor"))
map("n", "-", "<C-x>", with_desc("Decrement under cursor"))

-- ================================
-- 4️⃣ Plugin setup (lazy.nvim)
-- ================================
local gh = function(name)
    return "https://github.com/" .. name
end
local plugins = {
    {gh("nvim-mini/mini.pairs"), config = function()
            require("mini.pairs").setup()
        end},
    {gh("folke/tokyonight.nvim"), config = function()
            vim.cmd.colorscheme("tokyonight")
        end},
    {gh("nvim-mini/mini.indentscope"), config = function()
            require("mini.indentscope").setup({symbol = "│", options = {try_as_border = true}})
        end},
    {
        gh("nvim-mini/mini.clue"),
        config = function()
            require("mini.clue").setup(
                {
                    window = {delay = 200, config = {border = "rounded"}},
                    triggers = {{mode = "n", keys = "<Leader>"}, {mode = "x", keys = "<Leader>"}},
                    clues = {
                        require("mini.clue").gen_clues.builtin_completion(),
                        require("mini.clue").gen_clues.g(),
                        require("mini.clue").gen_clues.marks(),
                        require("mini.clue").gen_clues.registers(),
                        require("mini.clue").gen_clues.windows(),
                        require("mini.clue").gen_clues.z()
                    }
                }
            )
        end
    },
    {gh("nvim-mini/mini.icons"), config = function()
            require("mini.icons").setup()
        end},
    {gh("nvim-mini/mini.pick"), config = function()
            require("mini.pick").setup({window = {config = {border = "rounded"}}})
        end},
    {gh("nickjvandyke/opencode.nvim")},
    {
        gh("stevearc/oil.nvim"),
        config = function()
            require("oil").setup(
                {
                    lsp_file_methods = {enabled = true, timeout_ms = 1000, autosave_changes = true},
                    columns = {"icon"},
                    float = {max_width = 0.3, max_height = 0.6, border = "rounded"},
                    win_options = {signcolumn = "yes:2"}
                }
            )
        end
    },
    {gh("refractalize/oil-git-status.nvim"), config = function()
            require("oil-git-status").setup()
        end},
    {gh("b0o/schemastore.nvim")},
    {
        gh("neovim/nvim-lspconfig"),
        config = function()
            local lsp = vim.lsp
            lsp.config("lua_ls", {})
            lsp.enable("lua_ls")
            lsp.config("basedpyright", {{settings = {python = {analysis = {diagnosticMode = "openFilesOnly"}}}}})
            lsp.enable("basedpyright")
            lsp.config(
                "jsonls",
                {settings = {json = {validate = {enable = true}, schemas = require("schemastore").json.schemas()}}}
            )
            lsp.enable("jsonls")
            lsp.enable("wc_language_server")
            lsp.enable("biome")
            lsp.enable("emmet_language_server")
            lsp.enable("rumdl")
        end
    },
    {gh("rafamadriz/friendly-snippets")},
    {
        gh("saghen/blink.cmp"),
        build = "cargo build --release",
        config = function()
            require("blink.cmp").setup(
                {
                    keymap = {
                        preset = "default",
                        ["<Tab>"] = {"select_and_accept", "fallback"},
                        ["<S-Tab>"] = {"snippet_backward", "fallback"},
                        ["<CR>"] = {"accept", "fallback"}
                    },
                    completion = {menu = {border = "rounded"}, documentation = {auto_show = true}},
                    sources = {default = {"lsp", "path", "snippets", "buffer"}},
                    fuzzy = {implementation = "prefer_rust_with_warning"}
                }
            )
        end
    },
    {gh("lewis6991/gitsigns.nvim"), config = function()
            require("gitsigns").setup({current_line_blame = true, current_line_blame_opts = {delay = 300}})
        end},
    {gh("nvim-mini/mini.surround"), config = function()
            require("mini.surround").setup()
        end},
    {
        gh("nvim-treesitter/nvim-treesitter"),
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter").setup(
                {
                    ensure_installed = {"lua", "python", "json", "markdown", "vim", "vimdoc"},
                    auto_install = true,
                    highlight = {enable = true},
                    indent = {enable = true}
                }
            )
        end
    }
}

require("lazy").setup(
    plugins,
    {
        defaults = {lazy = false, version = false},
        install = {colorscheme = {"tokyonight"}},
        checker = {enabled = true, notify = true}
    }
)

-- ================================
-- 5️⃣ Format on save
-- ================================
vim.api.nvim_create_autocmd(
    "LspAttach",
    {
        group = vim.api.nvim_create_augroup("lsp", {clear = true}),
        callback = function(args)
            vim.api.nvim_create_autocmd(
                "BufWritePre",
                {
                    buffer = args.buf,
                    callback = function()
                        vim.lsp.buf.format {async = false, id = args.data.client_id}
                    end
                }
            )
        end
    }
)

