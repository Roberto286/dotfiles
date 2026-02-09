if status is-interactive
    # Commands to run in interactive sessions can go here
end
set -g fish_greeting ""


# pnpm
set -gx PNPM_HOME "$HOME/Library/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end

zoxide init fish | source

# Alias
alias cd z
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
