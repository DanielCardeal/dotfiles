-- Setup do VimTeX
vim.g.vimtex_view_general_viewer = 'evince'

-- Configuração de autocomplete
require('cmp').setup.filetype { 'tex', {
    sources = {
        { name = 'omni' },
        { name = 'path' },
        { name = 'luasnip' },
        { name = 'buffer', keyword_length = 5 },
    },
}
}
