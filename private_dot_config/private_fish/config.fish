if not type -q fisher
    echo "⚠️ fisher not installed. Run bootstrap script."
end

set -g fish_greeting ""

set -gx EDITOR nvim
set -gx VISUAL nvim

# Alias
alias lg lazygit
alias ld lazydocker
# Alias end


# Plugin config
set -g fish_theme catppuccin-mocha

# Add ~/.local/bin to PATH
if test -d "$HOME/.local/bin"
    fish_add_path $HOME/.local/bin
end

mise activate fish | source
zoxide init fish | source
