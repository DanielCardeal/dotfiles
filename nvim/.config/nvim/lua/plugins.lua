-- Garante que o packer está instalado no sistema
local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim/'

if not vim.fn.isdirectory(install_path) then
    vim.fn.execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
end

-- Inicializa os plugins
local use = require('packer').use
require('packer').startup(function()
    -- Packer
    use 'wbthomason/packer.nvim'

    -- Edição de texto
    use 'tpope/vim-surround'
    use 'tpope/vim-commentary'
    use 'jiangmiao/auto-pairs'

    -- Tema
    use {
        'shaunsingh/nord.nvim',
        config = function()
            vim.g.nord_contrast = true
            vim.g.nord_borders = true
            vim.g.nord_disable_background = true
            vim.cmd [[ colorscheme nord ]]
        end,
    }
    use { 'itchyny/lightline.vim', config = "vim.cmd [[ let g:lightline = {'colorscheme': 'nord' } ]]" }

    -- Busca (telescope)
    use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
    use {
        'nvim-telescope/telescope.nvim',
        commit = 'd88094fbfd84b297178252230f6faf0e7d2f7650',
        lock = true,
        requires = { -- Deps
            { 'nvim-lua/plenary.nvim' },
            { 'kyazdani42/nvim-web-devicons' },
        },
        config = function()
            local t = require('telescope')
            t.setup {
                pickers = {
                    find_files = {
                        -- Mostra arquivos ocultos em <leader>ff
                        hidden = true,
                        file_ignore_patterns = { '.git' },
                    },
                    live_grep = {
                        -- Busca em arquivos oculto em <leader>sp
                        additional_args = function(opts)
                            return { '--hidden' }
                        end,
                        file_ignore_patterns = { '.git' },
                    }
                }
            }
            t.load_extension('fzf')
        end
    }

    -- Which-key
    use 'folke/which-key.nvim'

    -- Git
    use 'airblade/vim-gitgutter'

    -- LSP
    use {
        'neovim/nvim-lspconfig',
        tag = "v0.1.3",
        lock = true,
        requires = 'williamboman/nvim-lsp-installer',
        after = 'which-key.nvim',
        config = function()
            -- Função chamada quando um servidor é associado a um cliente
            local on_attach = function(client, bufnr)
                -- Configura omnifunc
                vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

                -- Mappings.
                local wk = require("which-key")
                wk.register({
                    K = { '<cmd>lua vim.lsp.buf.hover()<CR>' },
                    ['C-k'] = { '<cmd>lua vim.lsp.buf.signature_help()<CR>' },
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
            -- Instalação & configuração
            local servidores = { "sumneko_lua", "rust_analyzer", "pyright", "clangd" }
            require('nvim-lsp-installer').setup { ensure_installed = servidores }
            for _, servidor in pairs(servidores) do
                require('lspconfig')[servidor].setup { on_attach = on_attach }
            end
        end,
    }

    -- Treesitter
    use {
        'nvim-treesitter/nvim-treesitter',
        commit = "10d57b3ec14cac0b6b",
        lock = true,
        run = ':TSUpdate',
        config = function()
            require('nvim-treesitter.configs').setup {
                ensure_installed = { "lua", "rust", "python", "c", "java" },
                highlight = { enable = true },
                textobjects = {
                    select = {
                        enable = true,
                        lookahead = true,
                        keymaps = {
                            ["if"] = "@function.inner", ["af"] = "@function.outer",
                            ["ia"] = "@parameter.inner", ["aa"] = "@parameter.outer",
                            ["il"] = "@loop.inner", ["al"] = "@loop.outer",
                            ["ic"] = "@class.inner", ["ac"] = "@class.outer",
                        }
                    }
                }
            }
        end
    }
    use {
        'nvim-treesitter/nvim-treesitter-textobjects',
        commit = "094e8ad3cc839e825f",
        lock = true,
        after = 'nvim-treesitter',
    }

    -- Linguagens
    -- Kitty
    use { "fladson/vim-kitty", ft = "kitty" }
    -- R
    use {
        "jalvesaq/Nvim-R",
        branch = "stable",
        lock = true,
        setup = function()
            local g = vim.g
            g.R_assign = 2 -- mapeia __ para ->
            g.R_auto_start = 1
        end,
    }
end)
