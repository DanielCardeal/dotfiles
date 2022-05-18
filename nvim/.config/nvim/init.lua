-- Importa os módulos de configuração
require('settings')
require('plugin_setup')
require('mappings')

-- Carrega o tema configurado
vim.cmd(
    string.format('colorscheme %s', vim.g.nani_theme or '')
)
