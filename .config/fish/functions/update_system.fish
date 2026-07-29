function update_system
    echo "==> brew update & upgrade"
    brew update && brew upgrade

    echo "==> brew cleanup"
    brew cleanup

    echo "==> npm update -g"
    npm update -g

    echo "==> rustup self update"
    gtimeout 60 rustup self update

    echo "==> rustup update"
    gtimeout 120 rustup update --no-self-update

    echo "==> fisher update"
    fisher update

    echo "==> mas upgrade"
    mas upgrade

    echo "==> done"
end
