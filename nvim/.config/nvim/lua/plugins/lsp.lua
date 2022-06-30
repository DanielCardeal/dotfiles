local M = {}

function M.config()
    -- Servidores configurados
    local servidores = {
        "clangd",
        "kotlin_language_server",
        "pyright",
        "rust_analyzer",
        "sumneko_lua",
        "gopls", -- Go
        "jdtls", -- Java
        "vimls", -- Vimscript
    }

    -- Função chamada quando o cliente `client` é associado ao buffer de número
    -- `bufnr`.
    local on_attach = function(client, bufnr)
        -- Configura omnifunc
        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
    end

    -- Aprimora autocomplete dependendo do server
    local capabilities = require('cmp_nvim_lsp').update_capabilities(
        vim.lsp.protocol.make_client_capabilities()
    )

    -- Garante que todos os servidores que devem ser usados estão devidamente
    -- instalados e inicializados
    require('nvim-lsp-installer').setup { automatic_installation = true }
    for _, servidor in pairs(servidores) do
        require('lspconfig')[servidor].setup {
            on_attach = on_attach,
            capabilities = capabilities,
        }
    end
end

return M
