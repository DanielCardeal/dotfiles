# Faz com que o zsh use ~/.config/zsh como local para buscar as configurações
export XDG_CONFIG_HOME="$HOME/.config/"
export ZDOTDIR=$XDG_CONFIG_HOME/zsh

# Default apps
export EDITOR="nvim"
export MANPAGER='nvim +Man!'
