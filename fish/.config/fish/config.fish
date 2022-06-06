# --- Variáveis
set -gx EDITOR nvim
fish_vi_key_bindings

if status is-interactive
    # Inicializa zoxide (https://github.com/ajeetdsouza/zoxide)
    zoxide init fish | source
    # Inicializa starship (deve ficar no fim do arquivo)
    starship init fish | source
end
