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
    use 'folke/which-key.nvim'
    use 'gpanders/editorconfig.nvim'

    -- Pairs
    use 'tpope/vim-surround'
    use {
        'windwp/nvim-autopairs',
        config = function()
            require('nvim-autopairs').setup {}
        end
    }

    -- Comentarios
    use {
        'numToStr/Comment.nvim',
        config = require("plugins.comment").config,
    }

    -- Temas
    use {
        'marko-cerovac/material.nvim',
        setup = function() require('temas.material').setup('deep ocean') end,
        config = require('temas.material').config,
    }

    use {
        'folke/tokyonight.nvim',
        disable = true,
        config = require('temas.tokyonight').config,
    }

    -- Buffers
    use {
        'kazhala/close-buffers.nvim',
        cmd = "BDelete",
    }

    -- StatusLine
    use {
        'nvim-lualine/lualine.nvim',
        requires = 'kyazdani42/nvim-web-devicons',
        event = 'BufEnter',
        config = require('plugins.statusline').config,
    }

    -- Notificações (UI)
    use {
        'rcarriga/nvim-notify',
        config = function() vim.notify = require("notify") end
    }

    -- Remove trailing whitespace
    use {
        "DanielCardeal/trimmy",
        config = function()
            require('trimmy').setup()
        end
    }

    -- TODOs coloridos
    use {
        "folke/todo-comments.nvim",
        requires = "nvim-lua/plenary.nvim",
        event = "BufEnter",
        config = function()
            require("todo-comments").setup {}
        end,
    }

    -- Hop
    use {
        'phaazon/hop.nvim',
        tag = '*',
        lock = true,
        config = require('plugins.hop').config,
    }

    -- Git
    use {
        'lewis6991/gitsigns.nvim',
        tag = 'release',
        lock = true,
        after = 'which-key.nvim',
        config = require('plugins.git').config,
    }

    use {
        'sindrets/diffview.nvim',
        requires = { 'nvim-lua/plenary.nvim', 'kyazdani42/nvim-web-devicons' },
        cmd = { 'DiffviewOpen', 'DiffviewFileHistory' },
        config = require('plugins.diffview').config,
    }

    -- LSP
    use {
        'neovim/nvim-lspconfig',
        tag = "*",
        lock = true,
        after = { 'which-key.nvim', 'nvim-lsp-installer', 'nvim-cmp' },
        config = require('plugins.lsp').config,
    }
    use {
        'williamboman/nvim-lsp-installer',
        event = 'BufEnter',
    }
    use {
        'j-hui/fidget.nvim',
        after = 'nvim-lspconfig',
        config = function() require('fidget').setup {} end,
    }

    -- Null-ls
    use {
        'jose-elias-alvarez/null-ls.nvim',
        after = 'nvim-lspconfig',
        requires = 'nvim-lua/plenary.nvim',
        config = require('plugins.null-ls').config,
    }

    -- Telescope
    use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
    use 'nvim-telescope/telescope-ui-select.nvim'
    use {
        'nvim-telescope/telescope.nvim',
        requires = {
            'nvim-lua/plenary.nvim',
            'kyazdani42/nvim-web-devicons',
        },
        cmd = 'Telescope',
        config = require('plugins.telescope').config,
    }

    -- Treesitter
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
        event = 'BufEnter',
        config = require('plugins.treesitter').config,
    }
    use {
        'nvim-treesitter/nvim-treesitter-textobjects',
        after = 'nvim-treesitter',
    }
    use { 'nvim-treesitter/nvim-treesitter-context', after = 'nvim-treesitter' }

    -- Trouble
    use {
        "folke/trouble.nvim",
        requires = "kyazdani42/nvim-web-devicons",
        config = require('plugins.trouble').config,
    }

    -- File explorer
    use {
        'kyazdani42/nvim-tree.lua',
        requires = 'kyazdani42/nvim-web-devicons',
        cmd = { 'NvimTreeFocus', 'NvimTreeClose' },
        config = require('plugins.nvim-tree').config,
    }

    -- Snippets
    use {
        'L3MON4D3/LuaSnip',
        requires = 'rafamadriz/friendly-snippets',
        config = require('plugins.snippets').config,
    }

    -- Autocomplete
    use {
        'hrsh7th/nvim-cmp',
        requires = {
            -- ícones
            'onsails/lspkind.nvim',
            -- completion sources
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-nvim-lua',
            'hrsh7th/cmp-path',
            'saadparwaiz1/cmp_luasnip',
        },
        after = { 'LuaSnip', 'nvim-autopairs' },
        config = require('plugins.completion').config,
    }

    -- Linguagens
    -- Markdown
    use {
        "iamcco/markdown-preview.nvim",
        run = function() vim.fn["mkdp#util#install"]() end,
        ft = "markdown",
    }
    -- Kitty
    use { "fladson/vim-kitty", ft = "kitty" }
    -- R
    use {
        "jalvesaq/Nvim-R",
        branch = "stable",
        lock = true,
        ft = 'r',
        setup = require('ling.r').setup,
    }

    -- Rust
    use {
        'simrat39/rust-tools.nvim',
        requires = {
            'nvim-lua/plenary.nvim',
            'neovim/nvim-lspconfig',
        },
        ft = 'rust',
        config = function() require('rust-tools').setup {} end
    }
end)
