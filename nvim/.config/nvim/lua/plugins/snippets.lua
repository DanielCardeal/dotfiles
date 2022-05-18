local M = {}

function M.config()
    -- Carrega snippets do pacote 'rafamadriz/friendly-snippets'
    require('luasnip.loaders.from_vscode').lazy_load()
end

return M
