function update_system
    # Chiedi la password sudo UNA volta.
    sudo -v
    set -x HOMEBREW_NO_ENV_HINTS 1

    # Rinfresca il ticket sudo ogni 50s finche' la funzione gira,
    # cosi' download lunghi (cask grossi) non lo fanno scadere.
    fish -c 'while sudo -n true 2>/dev/null; sleep 50; end' &
    set -l sudo_keepalive $last_pid

    # Gruppi indipendenti in parallelo. Ogni catena interna resta sequenziale.
    # Output mischiato: e' il prezzo del parallelismo.

    begin
        echo "==> brew update & upgrade"
        brew update && brew upgrade </dev/null
        echo "==> brew cleanup"
        brew cleanup
    end &

    begin
        echo "==> rustup self update"
        gtimeout 60 rustup self update
        echo "==> rustup update"
        gtimeout 120 rustup update --no-self-update
    end &

    begin
        echo "==> gem update"
        gem update
    end &

    begin
        echo "==> tldr update"
        tldr --update
    end &

    begin
        echo "==> gh extension upgrade --all"
        gh extension upgrade --all
    end &

    begin
        echo "==> fisher update"
        fisher update
    end &

    begin
        echo "==> mise upgrade"
        mise upgrade
    end &

    begin
        echo "==> mas upgrade"
        mas upgrade
    end &

    wait

    # sudo gia' in cache: nessun prompt. --agree-to-license evita la conferma.
    echo "==> softwareupdate (macOS)"
    sudo softwareupdate --install --all --agree-to-license

    # Ferma il keep-alive del ticket sudo.
    kill $sudo_keepalive 2>/dev/null

    echo "==> done"
end
