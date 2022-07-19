if type exa >/dev/null; then
    alias ls='exa'
    alias la='exa -a'
    alias ll='exa -l'
fi

if type tmux > /dev/null; then
    alias ta="tmux a"
    alias tl="tmux ls"
    alias tn="tmux new -s"
fi

if type bat > /dev/null; then
    alias ccat='cat'
    alias cat='bat'
fi
