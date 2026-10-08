#!/usr/bin/env sh
# Dotfiles bootstrap (bare repo) for macOS (branch "mac"), Arch (branch "arch")
# and fawos/bootc (branch "fawos").
# Usage: sh -c "$(curl -fsSL https://raw.githubusercontent.com/Roberto286/dotfiles/master/bootstrap.sh)"
# Override the branch with DOTFILES_BRANCH=<name>. Safe to re-run.
# --no-install: skip package installation (image already provides the tools).
set -eu

REPO_HTTPS="https://github.com/Roberto286/dotfiles.git" # clone without SSH keys
REPO_SSH="git@github.com:Roberto286/dotfiles.git"      # push once keys exist
DOTFILES_DIR="$HOME/.dotfiles"
BACKUP_DIR="$HOME/.dotfiles-backup"

log() { printf ':: %s\n' "$*"; }
has() { command -v "$1" >/dev/null 2>&1; }
dotfiles() { git --git-dir="$DOTFILES_DIR" --work-tree="$HOME" "$@"; }

NO_INSTALL=0
[ "${1:-}" = "--no-install" ] && NO_INSTALL=1

# 1. Package manager
OS="$(uname -s)"
case "$OS" in
  Darwin)
    BRANCH="${DOTFILES_BRANCH:-mac}"
    if ! has brew; then
      log "Installing Homebrew..."
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    [ -x /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)"
    pkg_install() { brew install "$@"; }
    ;;
  Linux)
    if has pacman; then
      BRANCH="${DOTFILES_BRANCH:-arch}"
      pkg_install() { sudo pacman -S --needed --noconfirm "$@"; }
    elif has rpm-ostree || has bootc; then
      # bootc image (e.g. fawos): packages are baked into the Containerfile,
      # dnf5 at runtime doesn't persist across reboots.
      BRANCH="${DOTFILES_BRANCH:-fawos}"
      NO_INSTALL=1
      pkg_install() { :; }
    else
      echo "Linux: Arch (pacman) or fawos (bootc) only" >&2; exit 1
    fi
    ;;
  *) echo "Unsupported OS: $OS" >&2; exit 1 ;;
esac

[ "$NO_INSTALL" = 1 ] && pkg_install() { :; }

# 2. Tools (command:package), only the missing ones: some live outside the package manager
log "Checking tools..."
missing=""
for pair in git:git curl:curl fish:fish nvim:neovim rg:ripgrep fd:fd fzf:fzf \
            lazygit:lazygit tmux:tmux mise:mise; do
  has "${pair%%:*}" || missing="$missing ${pair#*:}"
done
# lazydocker is AUR-only on Arch
[ "$OS" = Darwin ] && ! has lazydocker && missing="$missing lazydocker"
if [ -n "$missing" ]; then
  if [ "$NO_INSTALL" = 1 ]; then
    log "Missing (not installing, --no-install):$missing"
  else
    log "Installing:$missing"
    # shellcheck disable=SC2086 # word splitting intended
    pkg_install $missing
  fi
fi

# 3. Bare repo
if [ ! -d "$DOTFILES_DIR" ]; then
  log "Cloning dotfiles..."
  git clone --bare "$REPO_HTTPS" "$DOTFILES_DIR"
  dotfiles remote set-url origin "$REPO_SSH"
  # --bare skips the fetch refspec: without it `dotfiles fetch` never updates origin/*
  dotfiles config remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*'
fi

# 4. First checkout: move pre-existing files out of the way
if [ -z "$(dotfiles ls-files)" ]; then
  log "Checking out $BRANCH..."
  dotfiles ls-tree -r --name-only "$BRANCH" | while IFS= read -r f; do
    [ -e "$HOME/$f" ] || continue
    mkdir -p "$BACKUP_DIR/$(dirname "$f")"
    mv "$HOME/$f" "$BACKUP_DIR/$f"
    log "Backed up ~/$f"
  done
  dotfiles checkout "$BRANCH"
fi

# 5. Plugins and runtimes
log "Installing fish plugins..."
fish -c 'type -q fisher || curl -fsSL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source; fisher update'

if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
  log "Installing tpm..."
  git clone --depth 1 https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi

log "Installing mise tools..."
mise install

FISH="$(command -v fish)"
if [ "${SHELL:-}" != "$FISH" ]; then
  log "Setting fish as default shell..."
  grep -qx "$FISH" /etc/shells || echo "$FISH" | sudo tee -a /etc/shells >/dev/null
  chsh -s "$FISH"
fi

printf '\nBootstrap done. Run: exec fish (tmux plugins: prefix + I)\n'
