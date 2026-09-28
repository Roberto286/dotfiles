# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Structure

Single-file config: everything lives in `init.lua`. No `lua/` subdirectory. `lazy-lock.json` pins plugin versions.

Sections in `init.lua`:
1. lazy.nvim bootstrap
2. Vim options + `vim.diagnostic.config`
3. `LspAttach` autocmd (inlay hints, document highlight)
4. Keymaps
5. Plugin specs (inline `config`/`opts`)

## Plugin manager

[lazy.nvim](https://github.com/folke/lazy.nvim) — auto-bootstrapped on first launch. All plugins declared in the `plugins` table at the bottom of `init.lua`.

Update plugins: `<Leader>lu` / `:Lazy update`
Sync (install+clean): `<Leader>lx` / `:Lazy sync`

## Key plugins and roles

| Plugin | Role |
|--------|------|
| `nvim-lspconfig` | LSP client — uses `vim.lsp.config` / `vim.lsp.enable` API (Neovim 0.11+) |
| `lspsaga.nvim` | LSP UI — rename, code actions, hover, finder, peek, outline, diagnostics |
| `trouble.nvim` | Project/buffer diagnostics panel + symbols list |
| `nvim-cmp` | Completion engine |
| `LuaSnip` | Snippet engine (`make install_jsregexp` build step) |
| `conform.nvim` | Format-on-save |
| `nvim-treesitter` | Syntax / folding (`TSUpdate` build step) |
| `nvim-treesitter-context` | Current scope pinned at top of window (max 3 lines) |
| `telescope.nvim` | Fuzzy finder (fzf-native extension, `make` build) |
| `oil.nvim` | File explorer (`<Leader>e`) |
| `gitsigns.nvim` | Git decorations + inline blame |
| `opencode.nvim` | AI assistant integration (`<C-.>` toggle, `<C-a>` ask) |
| `mini.statusline` | Statusline (mode, file, git, LSP errors) |
| `mini.pairs/indentscope/icons/surround/clue` | Editor ergonomics |
| `tokyonight.nvim` | Colorscheme (loads eagerly, priority 1000) |

## LSP servers enabled

`lua_ls`, `basedpyright`, `jsonls`, `vtsls`, `eslint`, `biome`, `emmet_language_server`, `rumdl`, `wc_language_server`

All configured via `vim.lsp.config` + `vim.lsp.enable` — no mason auto-install; servers must exist in `$PATH`.

Global capabilities set via `vim.lsp.config("*", { capabilities = require("cmp_nvim_lsp").default_capabilities() })`.

`client.supports_method()` is deprecated in 0.11 — use `client.server_capabilities.<capability>` directly.

## Formatters (conform.nvim)

- Python: `ruff_fix` → `ruff_format`
- JS/TS: `biome` (prefers, requires `biome.json` in project root) → fallback `prettier` (requires config in cwd)
- Lua: `stylua`

Both `biome` and `prettier` have `require_cwd = true` — they won't run without a project config file.

## Notable keymaps

`<Leader>` = Space

**LSP (lspsaga)**
- `K` — hover doc
- `gd` — go to definition
- `gD` — go to declaration (native)
- `gr` — finder (refs + impl)
- `gpd` / `gpt` — peek definition / peek type definition
- `gO` — symbol outline
- `gl` — line diagnostics float
- `[d` / `]d` — prev/next diagnostic
- `<leader>ca` — code action
- `<leader>rn` — rename (live preview)

**Diagnostics / symbols (trouble)**
- `<leader>xx` — project diagnostics
- `<leader>xb` — buffer diagnostics
- `<leader>xs` — symbols

**Navigation**
- `<C-.>` — toggle OpenCode panel
- `<C-a>` / `<C-x>` — OpenCode ask / select action
- `+` / `-` — increment / decrement (remapped from `<C-a>`/`<C-x>`)
- `<Leader>e` — Oil float
- `<Leader>ff/fg/fb` — Telescope files / grep / buffers
- `<Leader>tt` — terminal split

## Autocmds

- Auto-save on `FocusLost`, `InsertLeave`, `TextChanged`
- Auto-read on `FocusGained`, `BufEnter`, `CursorHold`
- `LspAttach` — enables inlay hints + document highlight per buffer (checks `server_capabilities`)
- `exrc = true` — per-project `.nvim.lua` files are sourced automatically
