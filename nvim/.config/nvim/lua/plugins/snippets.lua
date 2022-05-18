local M = {}

function M.config()
    -- Carrega snippets do pacote 'rafamadriz/friendly-snippets'
    require('luasnip.loaders.from_vscode').lazy_load()

    -- Mappings
    local ls = require('luasnip')
    -- <c-j> para próximo campo do snippet
    vim.keymap.set({ "i", "s" }, "<c-j>", function()
        if ls.expand_or_jumpable() then
            ls.expand_or_jump()
        end
    end, { silent = true })
    -- <c-k> para campo anterior do snippet
    vim.keymap.set({ "i", "s" }, "<c-k>", function()
        if ls.jumpable(-1) then
            ls.jump(-1)
        end
    end, { silent = true })
end

return M
