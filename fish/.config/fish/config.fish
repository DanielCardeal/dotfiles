# --- Variáveis
set -gx EDITOR nvim

if not status is-interactive
    return
end

fish_vi_key_bindings
zoxide init fish | source

starship init fish | source
