---@diagnostic disable: lowercase-global
-- #####################
--    SETTINGS GERAIS
-- #####################
vim.g.mapleader = ' '

local set = {
    -- Cores
    termguicolors = true,
    -- Remove backups
    undofile = true,
    swapfile = false,
    backup = false,
    writebackup = false,
    -- Busca/autocomplete
    ignorecase = true,
    smartcase = true,
    incsearch = true,
    -- Navegação
    scrolloff = 5,
    -- Copia e cola
    clipboard = { 'unnamed', 'unnamedplus' },
    -- Line wrap
    wrap = true,
    breakindent = true,
    textwidth = 0,
    smartindent = true,
    linebreak = true,
    -- Caracteres invisíveis
    list = true,
    listchars = { tab = '» ', trail = '·', --[[ eol = '¬' ]] },
    showbreak = '↳',
    -- Update time
    updatetime = 250,
    timeoutlen = 500,
    -- Statusline global
    laststatus = 3,
    -- Tab
    tabstop = 4,
    shiftwidth = 0,
    expandtab = true,
    -- Coluna lateral
    relativenumber = true,
    cursorline = true,
    signcolumn = 'yes',
    fillchars = { diff = '╱', eob = " " },
    -- Corretor de palavras
    spellsuggest = "best,9",
    spelllang = { 'pt_br', 'en' },
    -- Abrindo novas janelas
    splitright = true,
    splitbelow = true,
    -- Concealing
    conceallevel = 2,
    concealcursor = "c",
    -- Folds
    foldmethod = 'expr',
    foldexpr = "nvim_treesitter#foldexpr()",
    foldlevel = 20,
}
for k, v in pairs(set) do
    vim.opt[k] = v
end

-- ###################
--    KEYMAPS FUNCS
-- ###################
function map(mode, lhs, rhs, desc, ft)
    if ft then
        desc = ft .. ': ' .. desc
    end
    vim.keymap.set(mode, lhs, rhs, { desc = desc })
end

function lead_map(mode, lhs, rhs, desc, ft)
    map(mode, '<leader>' .. lhs, rhs, desc, ft)
end

function nmap(lhs, rhs, desc, ft)
    map({ 'n' }, lhs, rhs, desc, ft)
end

function lead_nmap(lhs, rhs, desc, ft)
    nmap('<leader>' .. lhs, rhs, desc, ft)
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
            { '<leader><leader>', "<cmd>Telescope git_files<cr>",                                                     'find git file' },
            { '<leader>ff',       "<cmd>Telescope find_files hidden=true<cr>",                                        'find file' },
            { '<leader>fr',       "<cmd>Telescope oldfiles<cr>",                                                      'find recent' },
            { '<leader>fb',       "<cmd>Telescope buffers<cr>",                                                       'find buffer' },
            { '<leader>fd',       function() require('telescope').extensions.diff.diff_current { hidden = true } end,
                                                                                                                          'diff this file' },
            { '<leader>fD',       function() require('telescope').extensions.diff.diff_files { hidden = true } end,
                                                                                                                          'diff this file' },
            { '<leader>ss',       "<cmd>Telescope current_buffer_fuzzy_find<cr>",                                     'search buffer' },
            { '<leader>sp',       "<cmd>Telescope live_grep<cr>",                                                     'search project' },
            { '<leader>st',       "<cmd>TodoTelescope<cr>",                                                           "search todo's" },
            { '<leader>ht',       "<cmd>Telescope colorscheme<cr>",                                                   'search themes' },
            { '<leader>hh',       "<cmd>Telescope help_tags<cr>",                                                     'help vim' },
            { '<leader>hm',       "<cmd>Telescope man_pages<cr>",                                                     'help manpages' },
            { '<leader>hb',       "<cmd>Telescope keymaps<cr>",                                                       'help keymaps' },
            { '<leader>zC',       '<cmd>Telescope spell_suggest theme=cursor<cr>',                                    'spell suggest' },
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
            -- >> PylspInstall python-lsp-black pyls-isort pylsp-rope
            local lspconfig = require('lspconfig')
            local default_servers = { 'clangd', 'rust_analyzer', 'pylsp', 'lua_ls', 'texlab', 'ltex' }
            require('mason').setup()
            require('mason-lspconfig').setup {
                ensure_installed = default_servers,
            }
            for _, lsp in ipairs(default_servers) do
                lspconfig[lsp].setup {}
            end

            -- Específicos de linguagem
            lspconfig.pylsp.setup {
                settings = {
                    pylsp = {
                        plugins = {
                            pycodestyle = { maxLineLength = 100 }
                        }
                    }
                }
            }
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
                        vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = 'lsp: ' .. desc })
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
    --    NULL-LS
    -- #############
    {
        'jose-elias-alvarez/null-ls.nvim',
        config = function()
            local null_ls = require('null-ls')
            null_ls.setup {
                debug = true,
                sources = {
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
            { '<leader>td', '<cmd>Trouble document_diagnostics<cr>', 'trouble diagnostics' },
            { '<leader>tD', '<cmd>Trouble lsp_definitions<cr>',      'trouble definitions' },
            { '<leader>tr', '<cmd>Trouble lsp_references<cr>',       'trouble refs' },
            { '<leader>tt', '<cmd>TodoTrouble<cr>',                  'trouble TODOs' },
            { '<leader>tq', '<cmd>Trouble quickfix<cr>',             'trouble qflist' },
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
            { "<leader><tab>", "<cmd>NvimTreeFocus<cr>", 'Focus file explorer' }
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
    { 'windwp/nvim-autopairs',       event = 'InsertEnter', opts = {} },

    -- #################
    --    COMENTÁRIOS
    -- #################
    { 'numToStr/Comment.nvim',       event = 'VeryLazy',    opts = {} },

    -- ############
    --     TEMA
    -- ############
    { 'navarasu/onedark.nvim',       lazy = true },
    { 'EdenEast/nightfox.nvim',      lazy = true, },
    { 'projekt0n/github-nvim-theme', lazy = true },
    {
        'sainnhe/gruvbox-material',
        lazy = true,
        init = function()
            vim.g.gruvbox_material_background = 'hard'
            vim.g.gruvbox_material_foreground = 'material'
            vim.g.gruvbox_material_enable_bold = 1
            vim.g.gruvbox_material_transparent_background = 2
        end
    },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        lazy = true,
        opts = {
            integrations = {
                fidget = true,
                harpoon = true,
                leap = true,
                mason = true,
                indent_blankline = { enabled = true, }
            }
        }
    },

    -- ###########
    --    TODOs
    -- ###########
    { 'folke/todo-comments.nvim', event = 'BufEnter', opts = {} },

    -- ################
    --    StatusLine
    -- ################
    {
        'nvim-lualine/lualine.nvim',
        opts = {
            options = {
                section_separators = { left = '', right = '' },
                component_separators = { left = '', right = '' }
            },
            sections = {
                lualine_a = { 'mode' },
                lualine_b = { 'filename' },
                lualine_c = {
                    'branch',
                    {
                        'diff',
                        symbols = { added = " ", modified = " ", removed = " " },
                        padding = { left = 2, right = 1 }
                    }
                },
                lualine_x = {
                    {
                        'diagnostics',
                        symbols = {
                            error = " ",
                            warn = " ",
                            info = " ",
                            hint = " ",
                        },
                    }
                },
                lualine_y = { 'filetype' },
                lualine_z = { 'location' },
            },
        },
    },

    -- #########
    --    GIT
    -- #########
    { 'lewis6991/gitsigns.nvim',  event = 'VeryLazy', opts = {} },
    {
        'tpope/vim-fugitive',
        cmd = 'Git',
        keys = {
            { '<leader>gg', '<cmd>Git<cr>',       "git status" },
            { '<leader>gl', '<cmd>Git log<cr>',   "git log" },
            { '<leader>gP', '<cmd>Git push<cr>',  "git push" },
            { '<leader>gb', '<cmd>Git blame<cr>', "git blame" },
        }
    },

    -- ##############
    --    Zen Mode
    -- ##############
    {
        "folke/zen-mode.nvim",
        cmd = 'ZenMode',
        keys = {
            { '<leader>Z', "<cmd>ZenMode<cr>", 'zen mode' },
        },
        opts = {},
    },

    -- #############
    --    HARPOON
    -- #############
    {
        'ThePrimeagen/harpoon',
        keys = {
            { "<leader>,", function() require('harpoon.ui').nav_prev() end,          "[Harpoon] Navigate Prev" },
            { "<leader>.", function() require('harpoon.ui').nav_next() end,          "[Harpoon] Navigate Next" },
            { "<leader><", function() require('harpoon.mark').add_file() end,        "[Harpoon] Add File" },
            { "<leader>>", function() require('harpoon.ui').toggle_quick_menu() end, "[Harpoon] Quick Menu" },
        }
    },

    -- ################
    --    CLINGO ASP
    -- ################
    { 'rkaminsk/vim-syntax-clingo' },

    -- ###########
    --    NEORG
    -- ###########
    {
        "nvim-neorg/neorg",
        build = ":Neorg sync-parsers",
        enabled = false,
        ft = 'norg',
        keys = {
            { '<leader>oo', '<cmd>Neorg workspace<cr>', 'neorg default workspace' },
            { '<leader>oi', '<cmd>Neorg index<cr>',     'neorg index' },
        },
        config = function()
            NEORG_DIR = '~/Documentos/neorg/'
            require("neorg").setup {
                load = {
                    ["core.defaults"] = {},
                    ["core.concealer"] = {},
                    ['core.completion'] = {
                        config = { engine = 'nvim-cmp' },
                    },
                    ["core.dirman"] = {
                        config = {
                            workspaces = {
                                ic = NEORG_DIR .. "ic/",
                                faculdade = NEORG_DIR .. "faculdade/",
                                pessoal = NEORG_DIR .. "pessoal/",
                            },
                            default_workspace = 'faculdade',
                        },
                    },
                },
            }
        end,
    },

    -- ###########
    --    KITTY
    -- ###########
    { 'fladson/vim-kitty' },

    -- ###########
    --    LATEX
    -- ###########
    {
        'lervag/vimtex',
        init = function()
            vim.g.vimtex_view_general_viewer = 'evince'
            vim.g.vimtex_complete_enabled = false
            vim.g.vimtex_fold_enabled = true
            vim.g.vimtex_format_enabled = false
            vim.g.vimtex_quickfix_mode = 2
            vim.g.vimtex_compiler_latexmk = {
                options = {
                    '-shell-escape',
                    '-verbose',
                    '-file-line-error',
                    '-synctex=1',
                    '-interaction=nonstopmode',
                },
            }
        end,
    }
})

-- ##########
--    TEMA
-- ##########
local tema_ativo = 'catppuccin'
vim.cmd.colorscheme(tema_ativo)

-- Faz sintax highlight em texto copiado
vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
        vim.highlight.on_yank()
    end,
    group = vim.api.nvim_create_augroup('YankHighlight', { clear = true }),
    pattern = '*',
})

-- #############
--    KEYMAPS
-- #############
lead_nmap('fs', '<cmd>w<cr>', 'save file')
lead_nmap('fS', '<cmd>wa<cr>', 'save all files')

lead_nmap('bk', '<cmd>bd<cr>', 'delete buffer')

lead_nmap('w', '\23', 'window')

lead_nmap('gs', require('gitsigns').stage_hunk, 'stage hunk')
lead_nmap('gp', require('gitsigns').preview_hunk, 'preview hunk')
lead_nmap('gr', require('gitsigns').reset_hunk, 'reset hunk')
lead_nmap('gu', require('gitsigns').undo_stage_hunk, 'undo hunk')
lead_nmap('gR', require('gitsigns').reset_buffer, 'git reset buffer')
lead_nmap('gf', '<cmd>diffget //2<cr>', "diffget left")
lead_nmap('gj', '<cmd>diffget //3<cr>', "diffget right")

lead_nmap("zz", function() vim.o.spell = not vim.o.spell end, "spell toggle")
lead_nmap("zc", "1z=", "spell correct default")
lead_nmap("za", "zg", "spell add")

nmap("[q", "<cmd>cprevious<cr>", "previous qfix")
nmap("]q", "<cmd>cnext<cr>", "next qfix")
nmap("[l", "<cmd>lprevious<cr>", "previous locl")
nmap("]l", "<cmd>lnext<cr>", "next locl")
nmap("[h", require('gitsigns').prev_hunk, "previous hunk")
nmap("]h", require('gitsigns').next_hunk, "next hunk")
nmap("[t", function() require('todo-comments').jump_prev() end, "previous hunk")
nmap("]t", function() require('todo-comments').jump_next() end, "next hunk")

map({ 'c' }, '<c-k>', '<up>', 'down')
map({ 'c' }, '<c-j>', '<down>', 'up')

map({ 'o', 'x' }, 'ig', ':<c-u>normal! ggVG<cr>', 'text obj: buffer')
map({ 'o', 'x' }, 'ag', ':<c-u>normal! ggVG<cr>', 'text obj: buffer')
map({ 'o', 'x' }, 'ih', ':<c-u>Gitsigns select_hunk<cr>', 'text obj: hunk')
map({ 'o', 'x' }, 'ah', ':<c-u>Gitsigns select_hunk<cr>', 'text obj: hunk')

vim.keymap.set({ "n" }, 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set({ "n" }, 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- ###############
--    TEMPLATES
-- ###############
local template_augroup = vim.api.nvim_create_augroup('NaniTemplate', { clear = true })
vim.api.nvim_create_autocmd('BufNewFile', {
    pattern = '*.tex',
    group = template_augroup,
    callback = function(_)
        vim.ui.select({ 'lista' }, {
            prompt = 'carregar template:',

        }, function(choice)
            if not choice then
                return
            end
            vim.cmd("0r ~/.config/nvim/templates/lista.tex")
            vim.fn.searchpos('Lista X')
        end)
    end
})

vim.api.nvim_create_autocmd('BufNewFile', {
    pattern = '.editorconfig',
    group = template_augroup,
    command = "0r ~/.config/nvim/templates/.editorconfig",
})
