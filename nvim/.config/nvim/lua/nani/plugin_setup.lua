-- Garante que o packer está instalado no sistema
local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim/'

if not vim.fn.isdirectory(install_path) then
    vim.fn.execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
end

-- Inicializa os plugins
local use = require('packer').use
require('packer').startup(function()
    -- Package management
    use 'wbthomason/packer.nvim'
    use {
        'williamboman/mason.nvim',
        config = function()
            require("mason").setup()
        end
    }

    -- Plugins simples
    use 'folke/which-key.nvim'
    use 'gpanders/editorconfig.nvim'

    -- Mini plugins
    -- NOTE: mini.nvim é uma coleção de vários "mini plugins", que resolvem
    -- problemas diferentes. No meu caso, eu uso:
    --  * MiniBufremove
    --  * MiniIndentscope
    --  * MiniComment
    use {
        'echasnovski/mini.nvim',
        branch = 'stable',
        lock = true,
        config = require('nani.plugins.mini_nvim').config,
    }

    -- Pairs
    use 'tpope/vim-surround'
    use {
        'windwp/nvim-autopairs',
        config = function()
            require('nvim-autopairs').setup {}
        end
    }

    -- Temas
    use {
        'marko-cerovac/material.nvim',
        setup = function() require('nani.temas.material').setup('deep ocean') end,
        config = require('nani.temas.material').config,
    }

    use {
        'folke/tokyonight.nvim',
        disable = true,
        config = require('nani.temas.tokyonight').config,
    }

    use {
        'sainnhe/everforest',
        disable = true,
        setup = require('nani.temas.everforest').setup,
        config = function() vim.cmd [[colorscheme everforest]] end,
    }

    use {
        'sainnhe/gruvbox-material',
        disable = true,
        config = function() vim.cmd [[colorscheme gruvbox-material]] end,
    }

    -- StatusLine
    use {
        'nvim-lualine/lualine.nvim',
        requires = 'kyazdani42/nvim-web-devicons',
        event = 'BufEnter',
        config = require('nani.plugins.statusline').config,
    }

    -- TODO em comentários
    use {
        "folke/todo-comments.nvim",
        requires = "nvim-lua/plenary.nvim",
        config = function() require("todo-comments").setup {} end,
    }

    -- Remove trailing whitespace
    use {
        "DanielCardeal/trimmy",
        config = function()
            require('trimmy').setup()
        end
    }

    -- Git
    use {
        'lewis6991/gitsigns.nvim',
        tag = 'release',
        lock = true,
        after = 'which-key.nvim',
        config = require('nani.plugins.git').config,
    }

    use {
        'sindrets/diffview.nvim',
        requires = { 'nvim-lua/plenary.nvim', 'kyazdani42/nvim-web-devicons' },
        cmd = { 'DiffviewOpen', 'DiffviewFileHistory' },
        config = require('nani.plugins.diffview').config,
    }

    -- LSP
    use {
        'neovim/nvim-lspconfig',
        tag = "*",
        lock = true,
        after = { 'which-key.nvim', 'mason.nvim', 'nvim-cmp' },
        config = require('nani.plugins.lsp').config,
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
        config = require('nani.plugins.null-ls').config,
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
        config = require('nani.plugins.telescope').config,
    }

    if vim.fn.executable('z') then
        -- Integração com zoxide
        use {
            'jvgrootveld/telescope-zoxide',
            requires = {
                'nvim-lua/plenary.nvim',
                'nvim-lua/popup.nvim',
                'nvim-telesocope/telescope.nvim',
            }
        }
    end

    -- Treesitter
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
        event = 'BufEnter',
        config = require('nani.plugins.treesitter').config,
    }
    use {
        'nvim-treesitter/nvim-treesitter-textobjects',
        after = 'nvim-treesitter',
    }
    use { 'nvim-treesitter/nvim-treesitter-context', after = 'nvim-treesitter' }
    use {
        'nvim-treesitter/playground',
        after = 'nvim-treesitter',
        cmd = 'TSPlaygroundToggle'
    }

    -- Trouble
    use {
        "folke/trouble.nvim",
        requires = "kyazdani42/nvim-web-devicons",
        config = require('nani.plugins.trouble').config,
    }

    -- File explorer
    use {
        'kyazdani42/nvim-tree.lua',
        requires = 'kyazdani42/nvim-web-devicons',
        cmd = { 'NvimTreeFocus', 'NvimTreeClose' },
        config = require('nani.plugins.nvim-tree').config,
    }

    -- Snippets
    use {
        'L3MON4D3/LuaSnip',
        requires = 'rafamadriz/friendly-snippets',
        config = require('nani.plugins.snippets').config,
    }

    -- Autocomplete
    use {
        'hrsh7th/nvim-cmp',
        requires = {
            -- ícones
            'onsails/lspkind.nvim',
            -- completion sources
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-emoji',
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-nvim-lua',
            'hrsh7th/cmp-omni',
            'hrsh7th/cmp-path',
            'quangnguyen30192/cmp-nvim-tags',
            'saadparwaiz1/cmp_luasnip',
        },
        after = { 'LuaSnip', 'nvim-autopairs' },
        config = require('nani.plugins.completion').config,
    }

    -- CTags/Universal Tags
    use {
        "ludovicchabant/vim-gutentags",
        ft = { "c", "cpp" },
    }

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
        setup = require('nani.plugins.nvim-r').setup,
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

    -- ASP
    use 'rkaminsk/vim-syntax-clingo'

    -- Org mode
    use {
        'nvim-orgmode/orgmode',
        requires = 'nvim-treesitter/nvim-treesitter',
        after = "nvim-treesitter",
        config = require('nani.plugins.orgmode').config,
    }
end)
