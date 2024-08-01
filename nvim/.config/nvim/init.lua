---@diagnostic disable: lowercase-global
-- ######################
--    GENERAL SETTINGS
-- ######################
vim.g.mapleader = " "

local set = {
    termguicolors = true,
    background = "dark",

    undofile = true,
    swapfile = false,
    backup = false,
    writebackup = false,

    ignorecase = true,
    smartcase = true,
    incsearch = true,
    inccommand = "split",

    scrolloff = 5,
    clipboard = { "unnamed", "unnamedplus" },

    wrap = true,
    breakindent = true,
    textwidth = 0,
    smartindent = true,
    linebreak = true,

    list = true,
    listchars = {
        tab = "» ",
        trail = "·",
        -- eol = "¬",
    },
    showbreak = "↳",

    updatetime = 250,
    timeoutlen = 500,

    laststatus = 3,

    tabstop = 4,
    shiftwidth = 0,
    expandtab = true,

    relativenumber = true,
    number = true,
    cursorline = true,
    signcolumn = "yes",
    fillchars = { diff = "╱", eob = " " },

    spellsuggest = "best,9",
    spelllang = { "pt_br", "en" },

    splitright = true,
    splitbelow = true,

    conceallevel = 2,
    concealcursor = "c",

    foldmethod = "expr",
    foldexpr = "nvim_treesitter#foldexpr()",
    foldlevel = 20,
}
for k, v in pairs(set) do
    vim.opt[k] = v
end

-- Wrapper around vim.keymap.set
function map(mode, lhs, rhs, desc, ft)
    if ft then
        desc = ft .. ": " .. desc
    end
    vim.keymap.set(mode, lhs, rhs, { desc = desc })
end

-- Binds a normal mode keymap
function nmap(lhs, rhs, desc, ft)
    return map("n", lhs, rhs, desc, ft)
end

-- ###############
--    BOOTSTRAP
-- ###############
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- #############
--    PLUGINS
-- #############
require('lazy').setup({
    -- ###################
    --    DEPENDÊNCIAS
    -- ###################
    { 'nvim-tree/nvim-web-devicons', opts = {},  priority = 2000 },
    { 'nvim-lua/plenary.nvim',       lazy = true },

    -- ###############
    --    TELESCOPE
    -- ###############
    {
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        cmd = 'Telescope',
        dependencies = {
            { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make', },
            { 'jemag/telescope-diff.nvim' },
        },
        keys = {
            { '<leader><leader>', "<cmd>Telescope git_files<cr>",              desc = 'find git file' },
            { '<leader>ff',       "<cmd>Telescope find_files hidden=true<cr>", desc = 'find file' },
            { '<leader>fr',       "<cmd>Telescope oldfiles<cr>",               desc = 'find recent' },
            { '<leader>fb',       "<cmd>Telescope buffers<cr>",                desc = 'find buffer' },
            {
                '<leader>fd',
                function() require('telescope').extensions.diff.diff_current { hidden = true } end,
                desc = 'diff this file'
            },
            {
                '<leader>fD',
                function() require('telescope').extensions.diff.diff_files { hidden = true } end,
                desc = 'diff files'
            },
            { '<leader>ss', "<cmd>Telescope current_buffer_fuzzy_find<cr>",  desc = 'search buffer' },
            { '<leader>sp', "<cmd>Telescope live_grep<cr>",                  desc = 'search project' },
            { '<leader>st', "<cmd>TodoTelescope<cr>",                        desc = "search todo's" },
            { '<leader>ht', "<cmd>Telescope colorscheme<cr>",                desc = 'search themes' },
            { '<leader>hh', "<cmd>Telescope help_tags<cr>",                  desc = 'help vim' },
            { '<leader>hm', "<cmd>Telescope man_pages<cr>",                  desc = 'help manpages' },
            { '<leader>hb', "<cmd>Telescope keymaps<cr>",                    desc = 'help keymaps' },
            { '<leader>zC', '<cmd>Telescope spell_suggest theme=cursor<cr>', desc = 'spell suggest' },
        },
        config = function()
            require('telescope').setup {
                defaults = {
                    prompt_prefix = "  ",
                    vimgrep_arguments = {
                        'rg',
                        '--color=never',
                        '--no-heading',
                        '--with-filename',
                        '--line-number',
                        '--column',
                        '--smart-case',
                        '--hidden', -- busca em dirs ocultos
                    }
                },
            }
            require('telescope').load_extension('fzf')
            require('telescope').load_extension('diff')
        end,
    },

    -- #########
    --    LSP
    -- #########
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            -- Instalação automática de language servers
            { 'williamboman/mason.nvim', build = ':MasonUpdate' },
            'williamboman/mason-lspconfig.nvim',
            -- UI
            { 'j-hui/fidget.nvim',       enabled = false,       tag = 'legacy', event = 'VeryLazy', opts = {} },
        },
        config = function()
            -- NOTE: extensões do pylsp precisam ser instaladas manualmente
            -- usando o comando PylspInstall:
            -- >> PylspInstall python-lsp-black pyls-isort pylsp-rope pylsp-mypy
            local lspconfig = require('lspconfig')
            local default_servers = { 'clangd', 'rust_analyzer', 'pyright', 'lua_ls', 'texlab', 'ltex' }
            if IS_TABLET then
                default_servers = { 'pyright' }
            end
            require('mason').setup()
            require('mason-lspconfig').setup {
                ensure_installed = default_servers,
            }
            for _, lsp in ipairs(default_servers) do
                lspconfig[lsp].setup {}
            end

            -- Específicos de linguagem
            -- lspconfig.pylsp.setup {
            --     settings = {
            --         pylsp = {
            --             plugins = {
            --                 pycodestyle = { maxLineLength = 100 }
            --             }
            --         }
            --     }
            -- }
            lspconfig.ltex.setup {
                settings = {
                    ltex = {
                        language = 'pt-BR',
                    }
                }
            }

            -- On attach
            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('NaniLspConfig', { clear = true }),
                callback = function(ev)
                    if not (ev.data and ev.data.client_id) then
                        return
                    end
                    local bufnr = ev.buf
                    local client = vim.lsp.get_client_by_id(ev.data.client_id)

                    local lsp_map = function(mode, lhs, rhs, desc)
                        vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
                    end

                    lsp_map({ 'n' }, '<leader>cr', vim.lsp.buf.rename, 'rename')
                    lsp_map({ 'n' }, '<leader>ca', vim.lsp.buf.code_action, 'code action')
                    lsp_map({ 'n' }, '<leader>si', "<cmd>Telescope lsp_document_symbols<cr>", 'doc. symbols')

                    lsp_map({ 'n' }, 'gd', vim.lsp.buf.definition, 'goto definition')
                    lsp_map({ 'n' }, 'gD', vim.lsp.buf.declaration, 'goto declaration')
                    lsp_map({ 'n' }, 'gr', vim.lsp.buf.references, 'qflist references')
                    lsp_map({ 'n' }, 'gI', vim.lsp.buf.implementation, 'qflist implementations')

                    lsp_map({ 'n' }, 'K', vim.lsp.buf.hover, 'documentation')
                    lsp_map({ 'i' }, '<c-h>', vim.lsp.buf.signature_help, 'function signature')

                    lsp_map({ 'n' }, ']e', vim.diagnostic.goto_next, "next error")
                    lsp_map({ 'n' }, '[e', vim.diagnostic.goto_prev, "previous error")
                    lsp_map({ 'n' }, "<leader>e", vim.diagnostic.open_float, "show error")

                    lsp_map({ 'n', 'v' }, '<leader>cf', vim.lsp.buf.format, 'code format')
                end
            })
        end,
    },

    -- #############
    --    NV-TERM
    -- #############
    {
        "NvChad/nvterm",
        keys = {
            {
                "<space>ts",
                function() require('nvterm.terminal').toggle("horizontal") end,
                desc = 'term toggle horizontal'
            },
            { "<space>tv", function() require('nvterm.terminal').toggle("vertical") end, desc = 'term toggle vertical' },
            { "<space>tf", function() require('nvterm.terminal').toggle("float") end,    desc = 'term toggle float' },
        },
        opts = { behavior = { auto_insert = false } },
    },

    -- #############
    --    NULL-LS
    -- #############
    {
        'jose-elias-alvarez/null-ls.nvim',
        config = function()
            local null_ls = require('null-ls')
            null_ls.setup {
                debug = true,
                sources = {
                    null_ls.builtins.formatting.black,
                    null_ls.builtins.formatting.isort,
                    null_ls.builtins.diagnostics.mypy,
                    -- Fish
                    null_ls.builtins.diagnostics.fish,
                    null_ls.builtins.formatting.fish_indent,
                    -- Bash
                    null_ls.builtins.formatting.shfmt,
                }
            }
        end,
    },

    -- ################
    --    TREESITTER
    -- ################
    {
        'nvim-treesitter/nvim-treesitter',
        build = ":TSUpdate",
        config = function()
            require('nvim-treesitter.configs').setup {
                ensure_installed = { 'lua', 'markdown', 'python', 'vimdoc', 'org', },
                highlight = { enable = true, additional_vim_regex_highlighting = { 'org' } },
                textobjects = {
                    select = {
                        enable = true,
                        lookahead = true,
                        keymaps = {
                            ['aa'] = '@parameter.outer',
                            ['ia'] = '@parameter.inner',
                            ['af'] = '@function.outer',
                            ['if'] = '@function.inner',
                            ['ac'] = '@comment.outer',
                            ['ic'] = '@comment.outer',
                        },
                    },
                },
            }
        end
    },
    {
        'nvim-treesitter/nvim-treesitter-textobjects',
        after = 'nvim-treesitter',
    },

    -- #################
    --   AUTOCOMPLETE
    -- #################
    {
        'hrsh7th/nvim-cmp',
        event = 'InsertEnter',
        dependencies = {
            -- UI
            'onsails/lspkind.nvim',
            -- Sources
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-nvim-lua',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-omni',
            'saadparwaiz1/cmp_luasnip',
            -- Snippets
            { 'L3MON4D3/LuaSnip', version = 'v1.*', build = 'make install_jsregexp' },
            'rafamadriz/friendly-snippets',
        },
        config = function()
            local cmp = require('cmp')
            local luasnip = require('luasnip')
            local lspkind = require('lspkind')

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert {
                    ['<c-space>'] = cmp.mapping.confirm { select = true },
                    -- mappings luasnip
                },
                sources = {
                    { name = 'nvim_lsp' },
                    { name = 'nvim_lua' },
                    -- { name = 'neorg' },
                    { name = 'luasnip' },
                    { name = 'path' },
                    { name = 'buffer',  keyword_length = 5 },
                },
                formatting = {
                    format = lspkind.cmp_format({
                        with_text = true,
                    })
                },
                -- window = {
                --     completion = cmp.config.window.bordered(),
                --     documentation = cmp.config.window.bordered(),
                -- },
            })
            map({ 'i', 's' }, '<c-j>', function() if luasnip.jumpable(1) then luasnip.jump(1) end end)
            map({ 'i', 's' }, '<c-k>', function() if luasnip.jumpable(-1) then luasnip.jump(-1) end end)
            map({ 'i', 's' }, '<c-l>', function() if luasnip.choice_active() then luasnip.change_choice(1) end end)
            require("luasnip.loaders.from_vscode").load()
            -- Integração autopairs
            cmp.event:on('confirm_done',
                require('nvim-autopairs.completion.cmp').on_confirm_done({ map_char = { tex = '' } }))
        end,
    },

    -- ########
    --    UI
    -- ########
    { 'stevearc/dressing.nvim',    event = 'VeryLazy', opts = {}, },
    { 'NvChad/nvim-colorizer.lua', event = 'VeryLazy', opts = {} },

    -- #############
    --    TROUBLE
    -- #############
    {
        "folke/trouble.nvim",
        keys = {
            { '<leader>td', '<cmd>Trouble document_diagnostics<cr>', desc = 'trouble diagnostics' },
            { '<leader>tD', '<cmd>Trouble lsp_definitions<cr>',      desc = 'trouble definitions' },
            { '<leader>tr', '<cmd>Trouble lsp_references<cr>',       desc = 'trouble refs' },
            { '<leader>tt', '<cmd>TodoTrouble<cr>',                  desc = 'trouble TODOs' },
            { '<leader>tq', '<cmd>Trouble quickfix<cr>',             desc = 'trouble qflist' },
        },
        cmd = 'Trouble',
        opts = {},
    },

    -- ###############
    --    NVIM TREE
    -- ###############
    {
        'nvim-tree/nvim-tree.lua',
        keys = {
            { "<leader><tab>", "<cmd>NvimTreeFocus<cr>", desc = 'focus file explorer' }
        },
        opts = {
            sync_root_with_cwd = true,
            renderer = {
                group_empty = true
            },
        },
    },

    -- ##########
    --    LEAP
    -- ##########
    {
        'ggandor/leap.nvim',
        config = function()
            require('leap').add_default_mappings()
        end
    },

    -- ################
    --    PARÊNTESIS
    -- ################
    { 'tpope/vim-surround' },
    { 'windwp/nvim-autopairs', event = 'InsertEnter', opts = {} },
=======
require("lazy").setup({
    -- ###########
    --    ICONS
    -- ###########
    { "nvim-tree/nvim-web-devicons" },
>>>>>>> d1ddfa9 (nvim: arruma config do neovim para v0.9.4)

    -- ###############
    --    WHICH-KEY
    -- ###############
    {
        "folke/which-key.nvim",
        after = "echasnovski/mini.nvim",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end,
        opts = {},
    },

    -- ###############
    --    MINI.NVIM
    -- ###############
    {
        "echasnovski/mini.nvim",
        version = false, -- use latest version
        config = function()
            -- Show indentation scope
            require("mini.indentscope").setup()

            -- Move selections
            require("mini.move").setup()

            -- Common text objects
            require("mini.ai").setup()

            -- vim-commentary alternative
            require("mini.comment").setup()

            -- Better delimiter experiences
            require("mini.pairs").setup()
            require("mini.surround").setup()
        end,
    },

    -- ###############
    --    TELESCOPE
    -- ###############
    {
<<<<<<< HEAD
        "catppuccin/nvim",
        name = "catppuccin",
        lazy = true,
        opts = {
            no_italic = IS_TABLET,
            integrations = {
                fidget = true,
                vimwiki = true,
                harpoon = true,
                leap = true,
                mason = true,
                which_key = true,
                indent_blankline = { enabled = true, }
=======
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        dependencies = {
            { "nvim-lua/plenary.nvim", lazy = true },
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
            { "jemag/telescope-diff.nvim" },
        },
        config = function()
            local telescope = require("telescope")
            local actions = require("telescope.actions")
            telescope.setup({
                defaults = {
                    prompt_prefix = "  ",
                    mappings = {
                        n = { ["<c-q>"] = actions.smart_send_to_qflist + actions.open_qflist },
                        i = { ["<c-q>"] = actions.smart_send_to_qflist + actions.open_qflist },
                    },
                },
                pickers = {
                    -- Live grep (<leader>sp) on hidden files
                    live_grep = { additional_args = { "--hidden" } },
                },
            })
            require("telescope").load_extension("fzf")
            require("telescope").load_extension("diff")
        end,
    },

    -- #########
    --    LSP
    -- #########
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            { "williamboman/mason.nvim", config = true, build = ":MasonUpdate" },
            "williamboman/mason-lspconfig.nvim",
            { "j-hui/fidget.nvim", opts = {} },
        },
        config = function()
            -- LSP servers to setup automatically with lspconfig
            local servers = {
                "rust_analyzer",
                "pyright",
                "lua_ls",
                "gopls",
                "texlab",
>>>>>>> d1ddfa9 (nvim: arruma config do neovim para v0.9.4)
            }
            require("mason").setup()
            require("mason-lspconfig").setup({ ensure_installed = servers })

            -- Setup LSP servers with the correct capabilities
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())
            for _, server in ipairs(servers) do
                require("lspconfig")[server].setup({})
            end

            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("NaniLspConfig", { clear = true }),
                callback = function(ev)
                    local lsp_map = function(mode, lhs, rhs, desc)
                        vim.keymap.set(mode, lhs, rhs, { buffer = ev.buf, desc = desc })
                    end

                    lsp_map({ "n" }, "<F2>", vim.lsp.buf.rename, "rename")
                    lsp_map({ "n" }, "<leader>cr", vim.lsp.buf.rename, "rename")
                    lsp_map({ "n" }, "<leader>ca", vim.lsp.buf.code_action, "code action")

                    lsp_map({ "n" }, "<leader>si", "<cmd>Telescope lsp_document_symbols<cr>", "search doc. symbols")

                    lsp_map({ "n" }, "gd", vim.lsp.buf.definition, "goto definition")
                    lsp_map({ "n" }, "gD", vim.lsp.buf.declaration, "goto declaration")
                    lsp_map({ "n" }, "gr", vim.lsp.buf.references, "qflist references")
                    lsp_map({ "n" }, "gI", vim.lsp.buf.implementation, "qflist implementations")

                    lsp_map({ "n" }, "K", vim.lsp.buf.hover, "documentation")
                    lsp_map({ "i" }, "<c-h>", vim.lsp.buf.signature_help, "function signature")

                    lsp_map({ "n" }, "]e", vim.diagnostic.goto_next, "next error")
                    lsp_map({ "n" }, "[e", vim.diagnostic.goto_prev, "previous error")
                    lsp_map({ "n" }, "<leader>e", vim.diagnostic.open_float, "show error")
                end,
            })
        end,
    },

    -- ################
    --    FORMATTING
    -- ################
    {
        "stevearc/conform.nvim",
        branch = "nvim-0.9",
        opts = {
            notify_on_error = false,
            format_on_save = false,
            formatters_by_ft = {
                lua = { "stylua" },
                go = { "gofmt" },
                markdown = { "prettier" },
            },
        },
    },

    -- ################
    --    TREESITTER
    -- ################
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = {
                    "bash",
                    "c",
                    "diff",
                    "go",
                    "html",
                    "lua",
                    "luadoc",
                    "markdown",
                    "markdown_inline",
                    "python",
                    "query",
                    "vim",
                    "vimdoc",
                },
                auto_install = true,
                indent = { enable = true },
                highlight = {
                    enable = true,
                    -- NOTE: should be always off when using catppuccin
                    additional_vim_regex_highlighting = false,
                },
                textobjects = {
                    select = {
                        enable = true,
                        lookahead = true,
                        keymaps = {
                            ["aa"] = "@parameter.outer",
                            ["ia"] = "@parameter.inner",
                            ["af"] = "@function.outer",
                            ["if"] = "@function.inner",
                            ["ac"] = "@comment.outer",
                            ["ic"] = "@comment.outer",
                        },
                    },
                },
            })
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        after = "nvim-treesitter",
    },

    -- #################
    --   AUTOCOMPLETE
    -- #################
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            -- UI
            "onsails/lspkind.nvim",
            -- Snippets
            { "L3MON4D3/LuaSnip", version = "v1.*", build = "make install_jsregexp" },
            "rafamadriz/friendly-snippets",
            -- Sources
            "saadparwaiz1/cmp_luasnip",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
        },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")
            local lspkind = require("lspkind")

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                completion = { completeopt = "menu,menuone,noinsert" },
                mapping = cmp.mapping.preset.insert({
                    ["<c-space>"] = cmp.mapping.confirm({ select = true }),
                    ["<C-n>"] = cmp.mapping.select_next_item(),
                    ["<C-p>"] = cmp.mapping.select_prev_item(),
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    -- Pula de complete pra complete
                    ["<C-j>"] = cmp.mapping(function()
                        if luasnip.expand_or_locally_jumpable() then
                            luasnip.expand_or_jump()
                        end
                    end, { "i", "s" }),
                    ["<C-k>"] = cmp.mapping(function()
                        if luasnip.locally_jumpable(-1) then
                            luasnip.jump(-1)
                        end
                    end, { "i", "s" }),
                }),
                sources = {
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                    { name = "path" },
                    { name = "buffer", keyword_length = 5 },
                },
                formatting = {
                    format = lspkind.cmp_format({
                        with_text = true,
                    }),
                },
            })
            require("luasnip.loaders.from_vscode").load()
        end,
    },

    -- ###############
    --    NVIM TREE
    -- ###############
    {
        "nvim-tree/nvim-tree.lua",
        keys = {
            { "<leader><tab>", "<cmd>NvimTreeFocus<cr>", desc = "focus file explorer" },
        },
        opts = {
            sync_root_with_cwd = true,
            renderer = {
                group_empty = true,
            },
        },
    },

    -- #################
    --    COLORSCHEME
    -- #################
    { "rebelot/kanagawa.nvim" },

    -- ################
    --    StatusLine
    -- ################
    {
        "nvim-lualine/lualine.nvim",
        opts = {
            options = {
                section_separators = { left = "", right = "" },
                component_separators = { left = "", right = "" },
            },
            sections = {
                lualine_a = { "mode" },
                lualine_b = { "filename" },
                lualine_c = {
                    "branch",
                    {
                        "diff",
                        symbols = { added = " ", modified = " ", removed = " " },
                        padding = { left = 2, right = 1 },
                    },
                },
                lualine_x = {
                    {
                        "diagnostics",
                        symbols = {
                            error = " ",
                            warn = " ",
                            info = " ",
                            hint = " ",
                        },
                    },
                },
                lualine_y = { "filetype" },
                lualine_z = { "location" },
            },
        },
    },

    -- #########
    --    GIT
    -- #########
    { "lewis6991/gitsigns.nvim", event = "VeryLazy", opts = {} },
    {
        "tpope/vim-fugitive",
        cmd = "Git",
        keys = {
            { "<leader>gg", "<cmd>Git<cr>", desc = "git status" },
            { "<leader>gl", "<cmd>Git log<cr>", desc = "git log" },
            { "<leader>gP", "<cmd>Git push<cr>", desc = "git push" },
            { "<leader>gb", "<cmd>Git blame<cr>", desc = "git blame" },
            { "<leader>gm", "<cmd>Gdiff!<cr>", desc = "git merge file" },
        },
    },
    { "sindrets/diffview.nvim" },

    -- ###############
    --    FLIT/LEAP
    -- ###############
    {
        "ggandor/leap.nvim",
        keys = {
            { "gs", "<Plug>(leap-forward)", mode = { "n", "x", "o" }, desc = "Leap forward" },
            { "gS", "<Plug>(leap-backward)", mode = { "n", "x", "o" }, desc = "Leap backward" },
        },
    },
    { "ggandor/flit.nvim", dependencies = "ggandor/leap.nvim", opts = {} },

    -- #############
    --    HARPOON
    -- #############
    {
        "ThePrimeagen/harpoon",
        keys = {
            {
                "<leader>,",
                function()
                    require("harpoon.ui").nav_prev()
                end,
                desc = "harpoon prev",
            },
            {
                "<leader>.",
                function()
                    require("harpoon.ui").nav_next()
                end,
                desc = "harpoon next",
            },
            {
                "<leader>>",
                function()
                    require("harpoon.mark").add_file()
                end,
                desc = "harpoon add",
            },
            {
                "<leader><",
                function()
                    require("harpoon.ui").toggle_quick_menu()
                end,
                desc = "harpoon menu",
            },
        },
    },

    -- ################
    --    CLINGO ASP
    -- ################
    { "rkaminsk/vim-syntax-clingo" },

    -- ###########
    --    KITTY
    -- ###########
    { "fladson/vim-kitty" },

    -- ###########
    --    LATEX
    -- ###########
    {
        "lervag/vimtex",
        init = function()
            vim.g.vimtex_view_general_viewer = "evince"
            vim.g.vimtex_fold_enabled = true
            vim.g.vimtex_format_enabled = false
            vim.g.vimtex_quickfix_open_on_warning = false
            vim.g.vimtex_compiler_latexmk = {
                options = {
                    "-shell-escape",
                    "-verbose",
                    "-file-line-error",
                    "-synctex=1",
                    "-interaction=nonstopmode",
                },
            }
        end,
    },
})

-- #################
--    COLORSCHEME
-- #################
local current_theme = "kanagawa"
vim.cmd.colorscheme(current_theme)

-- Faz sintax highlight em texto copiado
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank()
    end,
    group = vim.api.nvim_create_augroup("YankHighlight", { clear = true }),
    pattern = "*",
})

-- #############
--    KEYMAPS
-- #############
local wk = require("which-key")

wk.add({
    { "<leader>c", group = "code" },
    {
        "<leader>cf",
        function()
            require("conform").format({ async = true, lsp_fallback = true })
        end,
        desc = "code format",
    },

    { "<leader>f", group = "file" },
    {
        mode = { "n", "v" },
        { "<leader>fs", "<cmd>w<cr>", desc = "save file" },
        { "<leader>fS", "<cmd>wa<cr>", desc = "save all files" },
        { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "find file" },
        { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "find recent" },
        { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "find buffer" },
        {
            "<leader>fd",
            function()
                require("telescope").extensions.diff.diff_current({ hidden = true })
            end,
            desc = "diff this file",
        },
        {
            "<leader>fD",
            function()
                require("telescope").extensions.diff.diff_files({ hidden = true })
            end,
            desc = "diff files",
        },
    },

    { "<leader>g", group = "git" },
    {
        mode = { "n", "v" },
        { "<leader>gs", require("gitsigns").stage_hunk, desc = "stage hunk" },
        { "<leader>gp", require("gitsigns").preview_hunk, desc = "preview hunk" },
        { "<leader>gr", require("gitsigns").reset_hunk, desc = "reset hunk" },
        { "<leader>gu", require("gitsigns").undo_stage_hunk, desc = "undo hunk" },
        { "<leader>gR", require("gitsigns").reset_buffer, desc = "git reset buffer" },
        { "<leader>gf", "<cmd>diffget //2<cr>", desc = "diffget left" },
        { "<leader>gj", "<cmd>diffget //3<cr>", desc = "diffget right" },
    },

    { "<leader>h", group = "help" },
    {
        mode = { "n", "v" },
        { "<leader>hh", "<cmd>Telescope help_tags<cr>", desc = "help vim" },
        { "<leader>hk", "<cmd>Telescope keymaps<cr>", desc = "help keymaps" },
        { "<leader>hm", "<cmd>Telescope man_pages<cr>", desc = "help manpages" },
    },

    { "<leader>m", group = "filetype" },

    { "<leader>s", group = "search" },
    {
        mode = { "n", "v" },
        { "<leader>ss", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "search in buffer" },
        { "<leader>sp", "<cmd>Telescope live_grep<cr>", desc = "search in project" },
        { "<leader>st", "<cmd>Telescope colorscheme<cr>", desc = "switch themes" },
    },

    { "<leader>z", group = "spell" },
    {
        "<leader>zz",
        function()
            vim.o.spell = not vim.o.spell
        end,
        desc = "toggle",
    },
    { "<leader>zc", "1z=", desc = "correct default" },
    { "<leader>za", "zg", desc = "spell add" },

    { "[", group = "previous" },
    {
        mode = { "n", "v" },
        { "[q", "<cmd>cprevious<cr>", desc = "qfix" },
        { "[l", "<cmd>lprevious<cr>", desc = "locl" },
        { "[h", require("gitsigns").prev_hunk, desc = "hunk" },
    },

    { "]", group = "next" },
    {
        mode = { "n", "v" },
        { "]q", "<cmd>cnext<cr>", desc = "qfix" },
        { "]l", "<cmd>lnext<cr>", desc = "locl" },
        { "]h", require("gitsigns").next_hunk, desc = "hunk" },
    },

    { "<leader>q", "<cmd>copen<cr>", desc = "open qflist" },
    { "<leader>Q", "<cmd>cclose<cr>", desc = "close qflist" },

    { "<leader>w", proxy = "<c-w>", group = "windows" },
    { "<leader><leader>", "<cmd>Telescope git_files<cr>", desc = "open file (git)" },
})

-- Use <c-k>/<c-j> to move up/down in command history
map({ "c" }, "<c-k>", "<up>", "down")
map({ "c" }, "<c-j>", "<down>", "up")

-- Add some quality of life text-objects:
--  g --> buffer
--  h --> hunk
map({ "o", "x" }, "ig", ":<c-u>normal! ggVG<cr>", "text obj: buffer")
map({ "o", "x" }, "ag", ":<c-u>normal! ggVG<cr>", "text obj: buffer")
map({ "o", "x" }, "ih", ":<c-u>Gitsigns select_hunk<cr>", "text obj: hunk")
map({ "o", "x" }, "ah", ":<c-u>Gitsigns select_hunk<cr>", "text obj: hunk")

-- Use gj and gk in place of the normal j k movements.
vim.keymap.set({ "n", "v" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set({ "n", "v" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- <c-,> works as <esc> in the built-in terminal
vim.keymap.set("t", [[<C-,>]], [[<C-\><C-n>]])
