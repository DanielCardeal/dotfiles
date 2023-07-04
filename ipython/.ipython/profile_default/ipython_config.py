c.TerminalInteractiveShell.autoindent = True
c.TerminalInteractiveShell.colors = 'Linux'
c.TerminalInteractiveShell.emacs_bindings_in_vi_insert_mode = False
c.TerminalInteractiveShell.editing_mode = "vi"

c.TerminalIPythonApp.display_banner = False

# Carrega numpy e matplotlib automaticamente
c.InteractiveShellApp.pylab = 'auto'

# Extensões carregadas por padrão
c.InteractiveShellApp.extensions = ["autoreload"]

# Importa bibliotecas padrão
c.InteractiveShellApp.exec_lines = [
    "%autoreload 2",
]
