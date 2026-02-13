#!/usr/bin/env sh
set -eu

DOTFILES_REPO="https://github.com/Roberto286/dotfiles"
DOTFILES_DIR="$HOME/.dotfiles"

# -----------------------------
# Flags
# -----------------------------
DRY_RUN=0
VERBOSE=0

while getopts "nv" opt; do
  case "$opt" in
    n) DRY_RUN=1 ;;
    v) VERBOSE=1 ;;
    *) echo "Usage: $0 [-n] [-v]"; echo "  -n  Dry run (no changes)"; echo "  -v  Verbose output"; exit 1 ;;
  esac
done

# -----------------------------
# Helpers
# -----------------------------
log()     { printf ":: %s\n" "$*"; }
verbose() { [ "$VERBOSE" -eq 1 ] && printf "   %s\n" "$*"; }

command_exists() { command -v "$1" >/dev/null 2>&1; }

run() {
  if [ "$DRY_RUN" -eq 1 ]; then
    printf "[dry-run] %s\n" "$*"
  else
    "$@"
  fi
}

install_pkg() {
  if command_exists brew; then run brew install "$1"
  elif command_exists apt-get; then run sudo apt-get install -y "$1"
  elif command_exists pacman; then run sudo pacman -S --noconfirm "$1"
  else echo "No supported package manager"; exit 1
  fi
}

ensure_cmd() {
  _cmd="$1"
  _pkg="${2:-$1}"
  if command_exists "$_cmd"; then
    verbose "$_cmd already installed, skipping"
  else
    log "Installing $_pkg..."
    install_pkg "$_pkg"
  fi
}

# -----------------------------
# 1. Base dependencies
# -----------------------------
log "Checking base dependencies..."
for cmd in git curl; do
  ensure_cmd "$cmd"
done

# -----------------------------
# 2. Clone bare repo
# -----------------------------
log "Setting up dotfiles..."
if [ -d "$DOTFILES_DIR" ]; then
  verbose "Dotfiles repo already cloned, skipping"
else
  log "Cloning dotfiles bare repo..."
  run git clone --bare "$DOTFILES_REPO" "$DOTFILES_DIR"
fi

dotfiles() { git --git-dir="$DOTFILES_DIR" --work-tree="$HOME" "$@"; }

# -----------------------------
# 3. Checkout dotfiles
# -----------------------------
log "Checking out dotfiles..."
if [ "$DRY_RUN" -eq 1 ]; then
  printf "[dry-run] dotfiles checkout\n"
elif ! dotfiles checkout 2>/dev/null; then
  log "Backing up conflicting files..."
  backup_dir="$HOME/.dotfiles-backup"
  mkdir -p "$backup_dir"
  dotfiles checkout 2>&1 | grep -E "^\s+" | awk '{print $1}' | while read -r f; do
    target_dir="$(dirname "$backup_dir/$f")"
    mkdir -p "$target_dir"
    mv "$HOME/$f" "$backup_dir/$f"
    verbose "Backed up $f -> $backup_dir/$f"
  done
  dotfiles checkout
  log "Conflicting files moved to $backup_dir"
fi

dotfiles config --local status.showUntrackedFiles no 2>/dev/null || true

# -----------------------------
# 4. Fish shell + fisher
# -----------------------------
log "Setting up fish shell..."
ensure_cmd fish

if [ "$DRY_RUN" -eq 1 ]; then
  printf "[dry-run] install fisher\n"
elif ! fish -c "type -q fisher" 2>/dev/null; then
  log "Installing fisher..."
  fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher"
else
  verbose "fisher already installed, skipping"
fi

# -----------------------------
# 5. Install fish plugins
# -----------------------------
log "Updating fish plugins..."
if [ -f "$HOME/.config/fish/fish_plugins" ]; then
  if [ "$DRY_RUN" -eq 1 ]; then
    printf "[dry-run] fisher update\n"
  else
    fish -c "fisher update"
  fi
else
  verbose "No fish_plugins file found, skipping"
fi

# -----------------------------
# 6. Optional tools
# -----------------------------
log "Checking optional tools..."
ensure_cmd nvim neovim
ensure_cmd rg ripgrep
if command_exists fd; then
  verbose "fd already installed, skipping"
elif command_exists fdfind; then
  verbose "fd (as fdfind) already installed, skipping"
else
  log "Installing fd..."
  install_pkg fd
fi
ensure_cmd lazygit

# -----------------------------
# 7. Dev tools (from config)
# -----------------------------
log "Checking dev tools..."

# fzf (required by fzf-lua nvim plugin)
ensure_cmd fzf

# lazydocker (aliased as 'ld' in config.fish)
ensure_cmd lazydocker

# pnpm (PATH configured in config.fish)
if command_exists pnpm; then
  verbose "pnpm already installed, skipping"
elif [ "$DRY_RUN" -eq 1 ]; then
  printf "[dry-run] install pnpm via corepack or standalone script\n"
else
  log "Installing pnpm..."
  if command_exists corepack; then
    corepack enable
    corepack prepare pnpm@latest --activate
  else
    curl -fsSL https://get.pnpm.io/install.sh | sh -
  fi
fi

echo ""
echo "Bootstrap done. Run: exec fish"
