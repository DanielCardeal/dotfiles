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
	use {'itchyny/lightline.vim', config = "vim.cmd [[ let g:lightline = {'colorscheme': 'nord' } ]]"}

	-- Busca (telescope)
    use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
    use {
        'nvim-telescope/telescope.nvim',
        commit = 'd88094fbfd84b297178252230f6faf0e7d2f7650',
        lock = true,
        requires = { -- Deps
            {'nvim-lua/plenary.nvim'},
            {'kyazdani42/nvim-web-devicons'},
        },
        config = function()
            local t = require('telescope')
            t.load_extension('fzf')
        end
    }

    -- FIXME: ainda precisam ser configurados direito
	use  "folke/which-key.nvim"

    -- Treesitter
    -- use {
    --     disable = true,
    --     'nvim-treesitter/nvim-treesitter',
    --     run = ':TSUpdate',
    --     config = function()
    --        require('nvim-treesitter.configs').setup {
    --             ensure_installed = "maintained",
    --             highlight = { enable = true },
    --             textobjects = {
    --                 select = {
    --                     enable = true,
    --                     lookahead = true,
    --                     keymaps = {
    --                         ["if"] = "@function.inner", ["af"] = "@function.outer",
    --                         ["ia"] = "@parameter.inner", ["aa"] = "@parameter.outer",
    --                         ["il"] = "@loop.inner", ["al"] = "@loop.outer",
    --                         ["ic"] = "@class.inner", ["ac"] = "@class.outer",
    --                     }
    --                 }
    --             }
    --         }
    --     end
    -- }
    -- use 'nvim-treesitter/nvim-treesitter-textobjects'

    -- -- LSP
    use {
        'neovim/nvim-lspconfig',
        requires = {{'williamboman/nvim-lsp-installer'}},
        config = function()
            local servidores = { "sumneko_lua", "rust_analyzer", "pyright" }
            require("nvim-lsp-installer").setup {
                -- Garante que os servidores estão instalados
                ensure_installed = servidores
            }
            for _, servidor in ipairs(servidores) do
                 -- Configura servidores
                require('lspconfig')[servidor].setup {}
            end
        end,
    }

    -- Linguagens
    -- Kitty
    use { "fladson/vim-kitty", ft = "kitty" }
    -- R
    use {
        "jalvesaq/Nvim-R",
        branch = "stable",
        lock = true,
        setup = function ()
            local g = vim.g
            g.R_assign = 2  -- mapeia __ para ->
            g.R_auto_start = 1
        end,
    }
end)
