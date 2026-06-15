function update_system
    echo "==> brew update & upgrade"
    brew update && brew upgrade

    echo "==> brew cleanup"
    brew cleanup

    echo "==> npm update -g"
    npm update -g

    echo "==> rustup self update"
    rustup self update

    echo "==> rustup update"
    rustup update --no-self-update

    echo "==> fisher update"
    fisher update

    echo "==> mas upgrade"
    mas upgrade

    echo "==> done"
end
