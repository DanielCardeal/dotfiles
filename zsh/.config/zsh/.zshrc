# --- Aliases
source "$ZDOTDIR/aliases.zsh"

# --- Prompt
source "$ZDOTDIR/prompt.zsh"

# --- Qualidade de vida
# Alarmes
unsetopt BEEP

# Vi mode
bindkey -v

# História
export HISTFILE="$ZDOTDIR/.zhistory"
export HISTSIZE=10000
export SAVEHIST=10000
setopt HIST_SAVE_NO_DUPS

# --- Extras
# Syntax highlighting
[ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] &&
    source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Completion parecida com o fish
[ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ] &&
    source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
