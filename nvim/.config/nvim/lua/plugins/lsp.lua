local M = {}

function M.config()
    -- Servidores configurados
    local servidores = {
        "clangd",
        "kotlin_language_server",
        "pyright",
        "rust_analyzer",
        "sumneko_lua",
    }

    -- Função chamada quando o cliente `client` é associado ao buffer de número
    -- `bufnr`.
    local on_attach = function(client, bufnr)
        -- Configura omnifunc
        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

        -- Mappings
        local wk = require("which-key")
        wk.register({
            K = { '<cmd>lua vim.lsp.buf.hover()<CR>' },
            ['<C-k>'] = { '<cmd>lua vim.lsp.buf.signature_help()<CR>' },
            g = {
                name = "goto",
                D = { '<cmd>lua vim.lsp.buf.declaration()<CR>', 'declaration' },
                d = { '<cmd>lua vim.lsp.buf.definition()<CR>', 'definition' },
                r = { '<cmd>lua vim.lsp.buf.references()<CR>', 'references' },
                i = { '<cmd>lua vim.lsp.buf.implementation()<CR>', 'implementation' },
            }
        }, { buffer = bufnr })
        wk.register({
            c = {
                name = 'code',
                r = { '<cmd>lua vim.lsp.buf.rename()<CR>', 'rename' },
                a = { '<cmd>lua vim.lsp.buf.code_action()<CR>', 'actions' },
                f = { '<cmd>lua vim.lsp.buf.formatting()<CR>', 'format' },
            }
        }, { prefix = "<leader>", buffer = bufnr })
    end

    -- Garante que todos os servidores que devem ser usados estão devidamente
    -- instalados e inicializados
    require('nvim-lsp-installer').setup { ensure_installed = servidores }
    for _, servidor in pairs(servidores) do
        require('lspconfig')[servidor].setup { on_attach = on_attach }
    end
end

return M
