if status is-interactive
    # Commands to run in interactive sessions can go here
end

if not type -q fisher
    echo "⚠️ fisher not installed. Run bootstrap script."
end

set -g fish_greeting ""

# Alias
alias lg lazygit
alias ld lazydocker
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
# Alias end

# Generated for envman. Do not edit.
test -s ~/.config/envman/load.fish; and source ~/.config/envman/load.fish

# This fixes the shell startup slowdown
function pyenv;
    eval "$(command pyenv init -)"

    pyenv "$argv"
; end

# Plugin config
set -g fish_theme catppuccin-mocha

# Add ~/.local/bin to PATH
if test -d "$HOME/.local/bin"
    fish_add_path $HOME/.local/bin
end

# opencode
fish_add_path /home/roberto/.opencode/bin
