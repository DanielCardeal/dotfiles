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

    -- Plugins simples
    use 'tpope/vim-surround'
    use 'tpope/vim-commentary'
    use 'jiangmiao/auto-pairs'
    use 'folke/which-key.nvim'

    -- Temas
    use {
        'shaunsingh/nord.nvim',
        setup = require('temas.nord').setup,
        config = "vim.cmd [[ colorscheme nord ]]"
    }
    use { 'itchyny/lightline.vim', config = "vim.cmd [[ let g:lightline = {'colorscheme': 'nord' } ]]" }

    -- Git
    use 'airblade/vim-gitgutter'

    -- LSP
    use {
        'neovim/nvim-lspconfig',
        tag = "v0.1.3",
        lock = true,
        after = { 'which-key.nvim', 'nvim-lsp-installer' },
        config = require('plugins.lsp').config,
    }
    use {
        'williamboman/nvim-lsp-installer',
        commit = 'b8a02bf2ec173c',
        lock = true,
    }


    -- Telescope
    use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
    use {
        'nvim-telescope/telescope.nvim',
        commit = 'd88094fbfd84b297178252230f6faf0e7d2f7650',
        lock = true,
        requires = {
            { 'nvim-lua/plenary.nvim' },
            { 'kyazdani42/nvim-web-devicons' },
        },
        config = require('plugins.telescope').config,
    }

    -- Treesitter
    use {
        'nvim-treesitter/nvim-treesitter',
        commit = "10d57b3ec14cac0b6b",
        lock = true,
        run = ':TSUpdate',
        config = require('plugins.treesitter').config,
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
        setup = require('ling.r').setup,
    }
end)