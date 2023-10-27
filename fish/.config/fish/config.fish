# --- Variáveis
set -gx EDITOR nvim

if not status is-interactive
    exit
end

fish_vi_key_bindings

# --- Aliases
# O uso do `type -q nome_do_programa` garante que esses aliases só são setados
# quando os diferentes programas estão presentes no sistema.
if type -q exa
    alias exa "exa --icons"
    abbr -a ls exa
    abbr -a la "exa -a"
    abbr -a ll "exa -l"
end

if type -q tmux
    abbr -a ta "tmux a"
    abbr -a tl "tmux ls"
    abbr -a tn "tmux new -s"
end

if type -q bat
    alias ccat cat
    alias cat bat
end

if type -q batcat
    # Bat no Debian chama batcat
    alias ccat cat
    alias cat batcat
end

# --- Programas
if type -q zoxide
    zoxide init fish | source
end

if type -q pyenv
    pyenv init - | source
end
