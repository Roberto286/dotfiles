# dotfiles

Dotfiles managed via [chezmoi](https://www.chezmoi.io/).

## Quick Start

```bash
chezmoi init --apply https://github.com/Roberto286/dotfiles.git
```

This will initialize chezmoi with this repo and apply the configuration to your home directory.

## What's Managed

- **Fish shell** (`~/.config/fish/`) — shell config, functions, plugins
- **Neovim** (`~/.config/nvim/`) — editor config and plugin setup
- **Zed** (`~/.config/zed/`) — settings, keymaps, tasks
- **Tmux** (`~/.tmux.conf`) — terminal multiplexer config
- **OpenCode** (`~/.config/opencode/`) — custom editor config
- **Git identity split** (`.gitconfig*`) — separate personal and dotfiles repo configs

## What's NOT Here

**Hyprland/Desktop configuration** is NOT managed by this repo. It lives in the [fawos](https://github.com/Roberto286/fawos) OS image repo alongside the custom Lua DSL desktop build.

The `.config/hypr/` and `.config/noctalia/` directories were removed in the migration to chezmoi; they are superseded by fawos's own Hyprland/DMS build.

## Source Layout

Files prefixed with `dot_` in the source repo map to a leading `.` in your home directory:
- `dot_config/` → `~/.config/`
- `dot_gitconfig` → `~/.gitconfig`
- `dot_tmux.conf` → `~/.tmux.conf`

See [chezmoi's source state attributes](https://www.chezmoi.io/reference/source-state-attributes/) for details on the naming convention.
