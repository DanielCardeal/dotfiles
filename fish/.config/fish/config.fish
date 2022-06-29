# --- Variáveis
set -gx EDITOR nvim

if not status is-interactive
    return
end

fish_vi_key_bindings

# --- Aliases
# O uso do `type -q nome_do_programa` garante que esses aliases só são setados
# quando os diferentes programas estão presentes no sistema.
if type -q exa
    alias exa "exa --icons"
    alias ls "exa"
    alias la "exa -a"
    alias ll "exa -l --git"
end

if type -q tmux
    alias ta "tmux a"
    alias tl "tmux ls"
    alias tn "tmux new -s"
end

if type -q bat
    alias ccat "cat"
    alias cat  "bat"
end

# --- Programas
if type -q zoxide
    zoxide init fish | source
end

if type -q starship
    # NOTE: para funcionar corretamente, essa deve ser a última linha do script
    starship init fish | source
end
