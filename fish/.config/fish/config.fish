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
    abbr -a ls exa
    abbr -a la "exa -a"
    abbr -a ll "exa -l --git"
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

# --- Programas
if type -q zoxide
    zoxide init fish | source
end

# --- Terminal do Neovim
# Configuração para melhorar a utilização do terminal integrado do neovim por
# meio do programa `neovim-remote`. Mais informação disponível na página do
# github: https://github.com/mhinz/neovim-remote
if set -q NVIM_LISTEN_ADDRESS
    or set -q NVIM # Compatibilidade com NVIM 0.7.2
    if not type -q nvr
        echo "ERRO: neovim-remote não está instalado!"
        return
    end
    alias nvim "nvr -l"
else
    alias nvim "nvim --listen /tmp/nvimsocket"
end
