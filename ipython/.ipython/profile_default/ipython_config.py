c.TerminalInteractiveShell.emacs_bindings_in_vi_insert_mode = False
c.TerminalInteractiveShell.editing_mode = "vi"

# Extensões carregadas por padrão
c.InteractiveShellApp.extensions = ["autoreload"]

# Importa bibliotecas padrão
c.InteractiveShellApp.exec_lines = [
    "%autoreload 2",
    "import numpy as np",
    "import pandas as pd",
    "import matplotlib.pyplot as plt",
]
