# Repository Guidelines

## Project Overview

Personal Neovim configuration (`~/.config/nvim`). Single-user editor config, not a library or application — the "product" is `init.lua` itself. Managed by `lazy.nvim`, targets Neovim 0.11+ (uses the new `vim.lsp.config`/`vim.lsp.enable` API, not `lspconfig.setup{}`).

## Architecture & Data Flow

Everything lives in **one file**, `init.lua` (673 lines), read top to bottom:

1. **Bootstrap** (`init.lua:3-23`) — clones `lazy.nvim` on first run, prepends to `rtp`. Also defines `get_project_root()` (walks up to nearest `.git`).
2. **Vim options** (`:25-57`) — `vim.opt.*` + `vim.g.mapleader = " "` (must be set before lazy loads plugins).
3. **Autocmds: auto-save / auto-read** (`:59-68`) — `checktime` on focus/buf-enter/cursor-hold; `silent! update` on focus-lost/insert-leave/text-changed. No manual `:w` needed for config edits to persist.
4. **Diagnostics config** (`:70-75`) — single `vim.diagnostic.config{}` call, not scattered per-plugin.
5. **`LspAttach` autocmd** (`:77-101`) — per-buffer inlay hints + document-highlight, gated on `client.server_capabilities.*` (NOT the deprecated `client.supports_method()`).
6. **Keymaps** (`:103-217`) — all defined via a local `map()` wrapper (`:106-108`) that force-merges `{ noremap = true, silent = true }`.
7. **Plugin specs** (`:221-668`) — one `plugins` table passed to `require("lazy").setup(plugins)`.

Data flow is linear/declarative: options → autocmds → keymaps (some reference plugin modules lazily via closures, e.g. `require("telescope.builtin")` inside a keymap function) → plugin table. There is no module system, no `lua/` subdirectory, no runtime app logic to trace — changes are additive edits to existing sections.

## Key Directories

- **root** — everything. No subdirectories matter.
- `lazy-lock.json` — commit-pinned plugin lockfile for the **active** manager, `lazy.nvim` (34 plugins).
- `nvim-pack-lock.json` — lockfile for `nvim-pack` (Neovim 0.12's built-in `vim.pack`), a **second, divergent plugin set** (21 plugins: `blink.cmp`, `fzf-lua`, `mini.pick`, `nvim-notify`, etc.) not referenced anywhere in `init.lua`. Treat as an inactive experiment/migration-in-progress, not the source of truth — don't assume its plugins are available.
- `.omp/` — OMP (this agent harness) config, unrelated to the Neovim config itself; not a build artifact of this project.

## Development Commands

There is no build, lint, or test tooling (no `Makefile`, `package.json`, `.stylua.toml`, `.editorconfig` in the repo). "Running" the project means launching Neovim itself.

| Action | Command |
|---|---|
| Apply changes | Just save `init.lua` — autocmd auto-saves/reloads on `TextChanged`/`InsertLeave`, but Lua itself only re-executes on next `nvim` launch or `:source %` |
| Validate syntax quickly | `nvim --headless -c 'luafile init.lua' -c 'qa'` |
| Install/update plugins | `<Leader>lu` or `:Lazy update` |
| Install+remove stale plugins | `<Leader>lx` or `:Lazy sync` |
| Check for plugin updates | `<Leader>lc` or `:Lazy check` |
| Lazy UI | `<Leader>L` or `:Lazy` |
| Format current buffer | handled by `conform.nvim` on save (`format_on_save`, 500ms timeout, `lsp_format = "fallback"`) |
| Edit this config from inside Neovim | `<leader>rc` (opens `$MYVIMRC`) |


## Code Conventions & Common Patterns

- **Keymaps**: always go through the local `map(mode, lhs, rhs, opts)` helper (`init.lua:106`), never bare `vim.keymap.set`, except the 3 clipboard-path maps at `:144-150` (pre-existing inconsistency — don't propagate, use `map()` for new keymaps).
- **Section banners**: numbered emoji comment blocks (`-- 1️⃣ Bootstrap lazy.nvim`) delimit major sections. New top-level concerns get a new numbered banner; don't bury unrelated setup inside an existing section.
- **Plugin table shape**: each entry is a lazy.nvim spec — prefer lazy-loading keys over `event`/`cmd`/`ft` (e.g. `oil.nvim` uses `cmd = "Oil"`, `nvim-cmp` uses `event = "InsertEnter"`, `claudecode.nvim` uses `keys = {...}` for on-demand loading). Only the colorscheme (`tokyonight.nvim`) loads eagerly (`lazy = false, priority = 1000`), by explicit comment requirement.
- **LSP server registration** (`init.lua:339-367`, inside `nvim-lspconfig`'s `config` function): pattern is `vim.lsp.config("*", { capabilities = ... })` once globally, then per-server `vim.lsp.config("<name>", {opts})` + `vim.lsp.enable("<name>")`. Servers with no special opts just call `lsp.enable("name")` directly (e.g. `wc_language_server`, `biome`, `rumdl`). **Do not** use `require("lspconfig").<server>.setup{}` — that's the old API this repo deliberately moved away from.
- **Formatters** (`conform.nvim`, `init.lua:614-618`): `formatters_by_ft` table; JS/TS entries list `{ "biome", "prettier", stop_after_first = true }` — biome wins if available, prettier is the fallback.
- **Error/no-op UX pattern**: arrow keys are remapped to `vim.notify(...)` hints instead of being silently disabled (`init.lua:194-206`, `no_arrows()` factory) — prefer a visible nudge over silent no-ops when blocking a habit.
- **State**: no custom plugin state management; state lives in individual plugin configs (e.g. `mini.clue`, `gitsigns`) via their own `opts`/`setup()` calls. No global `vim.g.*` custom flags beyond `mapleader`.
- **No dependency injection** — plugins `require()` each other directly inside `config` functions (e.g. `nvim-lspconfig`'s config requires `cmp_nvim_lsp` and `schemastore`).

## Important Files

- `init.lua` — the entire config; single source of truth.
- `lazy-lock.json` — active plugin lockfile; edit only via `:Lazy update`/`:Lazy sync`, not by hand.
- `nvim-pack-lock.json` — inactive/experimental `vim.pack` lockfile; do not wire new features against it unless explicitly migrating off `lazy.nvim`.

### Notable plugin entries (all in the `plugins` table, `init.lua:221-668`)

| Plugin | Role | Spec notes |
|---|---|---|
| `neovim/nvim-lspconfig` | LSP server registration | `event = "BufReadPre"`; see server list below |
| `nvimdev/lspsaga.nvim` | LSP UI (hover/rename/code-action/finder/outline/peek/diagnostics) | bound to `K`, `gd`, `gr`, `gO`, `gpd`, `gpt`, `gl`, `[d`/`]d`, `<leader>ca`, `<leader>rn` |
| `folke/trouble.nvim` | Diagnostics/symbols panel | `<leader>xx` project, `<leader>xb` buffer, `<leader>xs` symbols |
| `hrsh7th/nvim-cmp` | Completion | source priorities: `nvim_lsp=1000 > luasnip=750 > path=500 > buffer=100`; custom comparators deprioritize snippets and favor prefix matches over fuzzy (`init.lua:394-428`) |
| `L3MON4D3/LuaSnip` | Snippets | `build = "make install_jsregexp"`; loads VSCode-format snippets via `friendly-snippets` |
| `stevearc/conform.nvim` | Format-on-save | see table above |
| `nvim-treesitter/nvim-treesitter` | Syntax/folding | `ensure_installed` list at `init.lua:579+`; drives `foldexpr = v:lua.vim.treesitter.foldexpr()` |
| `nvim-telescope/telescope.nvim` | Fuzzy finder | `<leader>ff` uses `get_project_root()` as `cwd`, not plain cwd |
| `stevearc/oil.nvim` | File explorer | `<leader>e` opens `Oil --float`; `lsp_file_methods` enabled so LSP renames/moves follow file ops |
| `lewis6991/gitsigns.nvim` | Git gutter/blame | `<leader>tb` toggles line blame |
| `coder/claudecode.nvim` | **Claude Code CLI integration** (replaces the older `opencode.nvim` referenced in stale docs/comments — e.g. the `init.lua:208` comment still says "OpenCode", that's outdated) | all keys under `<leader>a*`: `ac` toggle, `af` focus, `ar`/`aC` resume/continue, `am` select model, `ab` add buffer, `as` send selection (visual) / add from Oil tree, `aa`/`ad` accept/deny diff |
| `echasnovski/mini.*` (clue, statusline, surround, indentscope, icons) | Editor ergonomics | `mini.clue` shows keymap hints |

### LSP servers enabled

`lua_ls`, `basedpyright` (custom `diagnosticMode = "openFilesOnly"`), `jsonls` (schemas via `schemastore.nvim`), `vtsls`, `eslint`, `biome`, `emmet_language_server`, `rumdl`, `wc_language_server`. All via `vim.lsp.enable(...)`, no mason — servers must already be on `$PATH`.

## Runtime/Tooling Preferences

- **Neovim 0.11+** required (new `vim.lsp.config`/`vim.lsp.enable` API; `vim.pack` groundwork for 0.12 present but inactive).
- **lazy.nvim** is the active plugin manager — use `:Lazy` commands, not raw `git` in the plugin dir.
- No Node/Bun/Python runtime requirement for the config itself; individual LSP servers (`vtsls`, `biome`, `eslint`, `emmet_language_server`) are external binaries expected in `$PATH`, not vendored.
- `exrc = true` is set — per-project `.nvim.lua` files in opened projects are auto-sourced. Be aware edits to `init.lua` are global defaults that a project-local `.nvim.lua` can override.

## Testing & QA

No automated test framework (see Development Commands above) — QA is manual:

1. Launch Neovim (`nvim`), check `:messages` / `:Lazy` for load errors.
2. Exercise the specific keymap/plugin changed (e.g. after touching LSP config, open a file of that filetype and confirm `K`, `gd`, `<leader>ca` work; after touching `conform.nvim`, save a file and confirm formatting applied).
3. `:checkhealth` for plugin-specific health checks (treesitter, lspconfig, telescope) when diagnosing breakage.

