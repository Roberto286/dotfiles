function dev
    set session "dev"

    # Don't create a duplicate session
    if tmux has-session -t $session 2>/dev/null
        tmux attach-session -t $session
        return
    end

    # Create session and first window: nvim
    tmux new-session -d -s $session -n editor -x 220 -y 50
    tmux send-keys -t $session:editor "nvim" Enter

    # lazygit
    tmux new-window -t $session -n git
    tmux send-keys -t $session:git "lazygit" Enter

    # claude
    tmux new-window -t $session -n claude 
    tmux send-keys -t $session:claude "claude" Enter

    # plain shell — land here on attach
    tmux new-window -t $session -n shell

    # Focus editor on attach
    tmux select-window -t $session:editor

    tmux attach-session -t $session
end
