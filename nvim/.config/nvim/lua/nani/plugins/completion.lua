local M = {}

function M.config()
    local cmp = require('cmp')
    local luasnip = require('luasnip')
    local lspkind = require('lspkind')

    cmp.setup {
        mapping = {
            ['<c-n>'] = cmp.mapping.select_next_item(),
            ['<c-p>'] = cmp.mapping.select_prev_item(),
            ['<c-space>'] = cmp.mapping.confirm {
                behavior = cmp.ConfirmBehavior.Insert,
                select = true
            },
        },

        sources = {
            -- A ordem em que as fontes são definidas altera a prioridade com
            -- que estas são mostradas ao usuário. Quanto mais para cima dessa
            -- lista, maior a prioridade.
            { name = 'nvim_lua' },
            { name = 'nvim_lsp' },
            { name = 'path' },
            { name = 'luasnip' },
            { name = 'buffer', keyword_length = 5 },
        },

        -- Configuração fazer luasnip funcionar
        snippet = {
            expand = function(args)
                luasnip.lsp_expand(args.body)
            end
        },

        -- Adiciona ícones com lspkind
        formatting = {
            format = lspkind.cmp_format {}
        },

        -- Features experimetais
        experimental = {
            ghost_text = true,
        }
    }

    -- Específica de linguagens
    cmp.setup.filetype({ 'c', 'cpp' }, {
        sources = {
            { name = 'tags' },
            { name = 'path' },
            { name = 'luasnip' },
            { name = 'buffer', keyword_length = 5 },
        }
    })

    cmp.setup.filetype('r', {
        sources = {
            { name = 'omni' },
            { name = 'path' },
            { name = 'luasnip' },
            { name = 'buffer', keyword_length = 5 },
        }
    })

    -- Integração com nvim-autopairs
    local cmp_autopairs = require('nvim-autopairs.completion.cmp')
    cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done({ map_char = { tex = '' } }))
end

return M
