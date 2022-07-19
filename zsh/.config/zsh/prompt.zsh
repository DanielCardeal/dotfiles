# prompt:
# %F => color dict
# %f => reset color
# %~ => current path
# %* => time
# %n => username
# %m => shortname host
# %(?..) => prompt conditional - %(condition.true.false)

PROMPT=$'%F{white}%~ %B%(?..%F{red}[%?]%f )%F{blue}>%f%b '
