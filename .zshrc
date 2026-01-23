# if [[ ! -d ~/.zplug ]]; then
#     echo "zplug is not installed, installing it now..."
#     curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
# fi

source ~/.zplug/init.zsh

# Plugins
# zplug "lukechilds/zsh-nvm"
zplug "hlissner/zsh-autopair", defer:2
zplug "zpm-zsh/colorize"
zplug carloscuesta/materialshell, use:materialshell.zsh, from:github, as:theme

# Auto install plugins
if ! zplug check; then
    zplug install
fi

zplug load

# Aliases
alias dotfiles="/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"

export PATH="$PATH:/opt/homebrew/bin"
