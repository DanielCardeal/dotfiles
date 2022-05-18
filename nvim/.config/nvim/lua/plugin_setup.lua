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
        disabled = true, -- NOTE: desabilitado
        setup = require('temas.nord').setup,
    }
    use {
        "catppuccin/nvim",
        as = "catppuccin",
        config = "vim.cmd [[ colorscheme catppuccin ]]"
    }

    -- StatusLine
    use {
        'feline-nvim/feline.nvim',
        requires = 'kyazdani42/nvim-web-devicons',
        after = 'catppuccin',
        config = require('plugins.feline').config,
    }

    -- Hop
    use {
        'phaazon/hop.nvim',
        tag = 'v1.3.0',
        lock = true,
        config = require('plugins.hop').config,
    }

    -- Git
    use {
        'lewis6991/gitsigns.nvim',
        tag = 'release',
        lock = 'true',
        after = 'which-key.nvim',
        config = require('plugins.git').config,
    }

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
        commit = 'b38dae44fb47a42d6588115928084b498c4c7b78',
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

    -- File explorer
    use {
        'kyazdani42/nvim-tree.lua',
        commit = '9d26594b6caf3caee46dc12ceae62b5dcbbc28d6',
        lock = true,
        requires = 'kyazdani42/nvim-web-devicons',
        opt = false,
        setup = require('plugins.nvim-tree').setup,
        config = require('plugins.nvim-tree').config,
    }

    -- Snippets
    use {
        'L3MON4D3/LuaSnip',
        requires = 'rafamadriz/friendly-snippets',
        config = require('plugins.snippets').config,
    }

    -- Goyo
    use {
        'junegunn/goyo.vim',
        after = 'which-key.nvim',
        config = require('plugins.goyo').config,
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
