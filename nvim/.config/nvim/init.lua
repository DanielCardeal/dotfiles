-- ########################
--     BOOTSTRAP PACKER
-- ########################
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
local is_bootstrap = false
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    is_bootstrap = true
    vim.fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
    vim.cmd [[packadd packer.nvim]]
end

-- #############################
--    DECLARAÇÃO DOS PLUGINS
-- #############################
local use = require('packer').use
require('packer').startup(function()
    -- #####################
    --    PACKAGE MANAGER
    -- #####################
    use 'wbthomason/packer.nvim'

    -- ###########
    --    SNEAK
    -- ###########
    use 'justinmk/vim-sneak'

    -- ################
    --    PARÊNTESIS
    -- ################
    use 'tpope/vim-surround'
    use 'windwp/nvim-autopairs'
    use 'p00f/nvim-ts-rainbow' -- parêntesis coloridos

    -- ################
    --    WHITESPACE
    -- ################
    use 'tpope/vim-sleuth'
    use 'DanielCardeal/trimmy.nvim'

    -- #################
    --    COMENTÁRIOS
    -- #################
    use 'numToStr/Comment.nvim'

    -- ############
    --     TEMA
    -- ############
    use 'navarasu/onedark.nvim'
    use 'EdenEast/nightfox.nvim'

    -- ################
    --    StatusLine
    -- ################
    use 'nvim-lualine/lualine.nvim'

    -- #########
    --    GIT
    -- #########
    use 'lewis6991/gitsigns.nvim'
    use 'tpope/vim-fugitive'

    -- #########
    --    LSP
    -- #########
    use {
        'neovim/nvim-lspconfig',
        requires = {
            -- Instalação automática de language servers
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',

            -- UI com status atual dos language servers
            'j-hui/fidget.nvim',
        },
    }

    -- ###############
    --    Telescope
    -- ###############
    use {
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        requires = { 'nvim-lua/plenary.nvim' }
    }
    use {
        'nvim-telescope/telescope-fzf-native.nvim',
        run = 'make',
        cond = vim.fn.executable 'make' == 1,
    }

    -- ################
    --    Treesitter
    -- ################
    use {
        'nvim-treesitter/nvim-treesitter',
        run = function()
            pcall(require('nvim-treesitter.install').update { with_sync = true })
        end,
    }
    use {
        'nvim-treesitter/nvim-treesitter-textobjects',
        after = 'nvim-treesitter',
    }

    -- ##############
    --    Zen Mode
    -- ##############
    use "folke/zen-mode.nvim"

    -- ##############
    --    SNIPPETS
    -- ##############
    use 'SirVer/ultisnips' -- snippet engine
    use 'honza/vim-snippets' -- pacote de snippets

    -- #################
    --   AUTOCOMPLETE
    -- #################
    use {
        'hrsh7th/nvim-cmp',
        requires = {
            -- UI
            'onsails/lspkind.nvim',
            -- Sources
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-nvim-lua',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'quangnguyen30192/cmp-nvim-ultisnips',
        },
    }

    -- ###########
    --    LATEX
    -- ###########
    use 'lervag/vimtex'

    -- Sincroniza o ambiente na primeira instalação
    if is_bootstrap then
        require('packer').sync()
    end
end)

if is_bootstrap then
    print '=========================================='
    print '    Os plugins estão sendo instalados'
    print '    Espere até que o Packer finalize'
    print '       e então reinicie o Neovim.'
    print '=========================================='
    return
end

-- ######################
--    SYNC AUTOMÁTICO
-- ######################
local packer_group = vim.api.nvim_create_augroup('Packer', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', {
    command = 'source <afile> | PackerCompile',
    group = packer_group,
    pattern = vim.fn.expand '$MYVIMRC',
})

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
    listchars = { tab = '» ', trail = '·', eol = '¬' },
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
    number = true,
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
}
for k, v in pairs(set) do
    vim.opt[k] = v
end

-- ###################
--    CONFIG (TEMA)
-- ###################
local tema_ativo = 'nightfox'
vim.cmd("colorscheme " .. tema_ativo)

-- ####################
--    KEYMAPS GERAIS
-- ####################
local map = function(mode, left, right, description)
    mode = mode or 'n'
    description = description or ''
    vim.keymap.set(mode, left, right, { desc = description })
end
local nmap = function(lhs, rhs, desc)
    map('n', lhs, rhs, desc)
end

vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Melhora movimento com linhas visuais
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Salvar arquivos
nmap('<leader>fs', '<cmd>w<cr>', '[F]ile [S]ave')
nmap('<leader>fS', '<cmd>wa<cr>', '[F]ile [S]ave (all)')

-- Text objects
map({ 'o', 'x' }, 'ig', ':<c-u>normal! ggVG<cr>')
map({ 'o', 'x' }, 'ag', ':<c-u>normal! ggVG<cr>')

-- Manipulação de buffers/janelas
nmap('<leader>w', '\23', "[W]indow")
nmap('<leader>q', '<cmd>q<cr>', 'Close Window')
nmap('<leader>bk', '<cmd>bd<cr>', '[B]uffer [D]elete')

-- GOTOs
nmap("]q", "<cmd>cnext<cr>", "[Q]fix Next")
nmap("[q", "<cmd>cprevious<cr>", "[Q]fix Previous")
nmap("]l", "<cmd>lnext<cr>", "[L]oclist Next")
nmap("[l", "<cmd>lprevious<cr>", "[L]oclist Previous")

-- ######################
--    STATUSLINE (CONFIG)
-- ######################
require('lualine').setup {
    options = {
        icons_enabled = false,
        theme = 'auto',
        section_separators = { left = '', right = '' },
        component_separators = { left = '', right = '' },
    }
}

-- Adiciona uma winbar para facilitar a detecção dos arquivos
vim.o.winbar = "%=%f"

-- ###########################
--    COMMENT.NVIM (CONFIG)
-- ###########################
require('Comment').setup()

-- #######################
--    GITSIGNS (CONFIG)
-- #######################
require('gitsigns').setup {
    numhl = true,
    current_line_blame = true,
    keymaps = {},
}

-- ########################
--    TELESCOPE (CONFIG)
-- ########################
require('telescope').setup {
    defaults = {
        prompt_prefix = "  ",
        mappings = {
            i = {
                ["<C-q>"] = require('telescope.actions').smart_send_to_qflist,
                ["<C-d>"] = require('telescope.actions').delete_buffer,
                ["<C-a>"] = require('telescope.actions').select_all,
            },
            n = {
                ["<C-q>"] = require('telescope.actions').smart_send_to_qflist,
                ["<C-d>"] = require('telescope.actions').delete_buffer,
                ["<C-a>"] = require('telescope.actions').select_all,
            }
        }
    },
    extensions = {
        -- Extensão para fuzzy search com padrões inteligentes
        fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
        },
    },
    pickers = {
        find_files = {
            -- Mostra arquivos ocultos em <leader>ff
            hidden = true,
            file_ignore_patterns = { '.git' },
        },
        live_grep = {
            -- Busca em arquivos oculto em <leader>sp
            additional_args = function(_)
                return { '--hidden' }
            end,
            file_ignore_patterns = { '.git' },
        }
    }
}

-- Carrega extensões
pcall(require('telescope').load_extension, 'fzf')

-- Keymaps
nmap('<leader><leader>', require('telescope.builtin').git_files, 'Git Files')
nmap('<leader>,', require('telescope.builtin').buffers, 'List Buffers')
nmap('<leader>.', require('telescope.builtin').find_files, 'Find Files')

nmap('<leader>ff', require('telescope.builtin').find_files, '[F]ind [F]iles')
nmap('<leader>fr', require('telescope.builtin').oldfiles, '[F]ind [R]ecent')

nmap('<leader>ss', require('telescope.builtin').current_buffer_fuzzy_find, '[S]earch [S]tring')
nmap('<leader>sp', require('telescope.builtin').live_grep, '[S]earch [P]roject')
nmap('<leader>st', require('telescope.builtin').colorscheme, '[S]earch [T]hemes')

nmap('<leader>hh', require('telescope.builtin').help_tags, '[H]elp [H]elp')
nmap('<leader>hm', require('telescope.builtin').man_pages, '[H]elp [M]anpages')
nmap('<leader>hb', require('telescope.builtin').keymaps, '[H]elp [B]indings')
nmap('<leader>hk', require('telescope.builtin').keymaps, '[H]elp [K]eymaps')

-- #########################
--    TREESITTER (CONFIG)
-- #########################
require('nvim-treesitter.configs').setup {
    ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'help' },
    -- TODO começar o highlight
    highlight = { enable = true },
    indent = { enable = true },
    textobjects = {
        select = {
            enable = true,
            lookahead = true,
            keymaps = {
                ['aa'] = '@parameter.outer',
                ['ia'] = '@parameter.inner',
                ['af'] = '@function.outer',
                ['if'] = '@function.inner',
                ['ac'] = '@class.outer',
                ['ic'] = '@class.inner',
            },
        },
    },
    rainbow = {
        -- Extensão treesitter rainbow
        enable = true,
    }
}

-- #########################
--    PARÊNTESIS (CONFIG)
-- #########################
require('nvim-autopairs').setup()

-- #########################
--    WHITESPACE (CONFIG)
-- #########################
require('trimmy').setup()

-- ##################
--    GIT (CONFIG)
-- ##################

-- Keymaps
nmap('<leader>gs', require('gitsigns').stage_hunk, '[G]it [S]tage Hunk')
nmap('<leader>gu', require('gitsigns').undo_stage_hunk, '[G]it [U]ndo Stage Hunk')
nmap('<leader>gp', require('gitsigns').preview_hunk, '[G]it [P]review Hunk')
nmap('<leader>gr', require('gitsigns').reset_hunk, '[G]it [R]eset Hunk')
nmap('<leader>gR', require('gitsigns').reset_buffer, '[G]it [R]eset Buffer')

nmap("]h", require('gitsigns').next_hunk, "Next [H]unk")
nmap("[h", require('gitsigns').prev_hunk, "Previous [H]unk")

map({ 'o', 'x' }, 'ih', ':<c-u>Gitsigns select_hunk<cr>')
map({ 'o', 'x' }, 'ah', ':<c-u>Gitsigns select_hunk<cr>')

-- ##################
--    LSP (CONFIG)
-- ##################
local on_attach = function(_, bufnr)
    -- Função auxiliar para não precisar repetir a descrição em todos os mappings do LSP
    local nmap = function(left, right, desc)
        if desc then
            desc = 'LSP: ' .. desc
        end
        nmap(left, right, desc)
    end

    nmap('<leader>cr', vim.lsp.buf.rename, '[C]ode [R]ename')
    nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

    nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
    nmap('gD', vim.lsp.buf.type_definition, '[G]oto [D]efinition (type)')
    nmap('gr', vim.lsp.buf.references, '[G]oto [R]eferences')
    nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')

    nmap('<leader>si', require('telescope.builtin').lsp_document_symbols, '[S]earch [S]ymbols')
    nmap('<leader>sI', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[S]earch [S]ymbols (workspace)')

    nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
    nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

    nmap("]e", vim.diagnostic.goto_next, "Next [E]rror")
    nmap("[e", vim.diagnostic.goto_prev, "Prev [E]rror")

    -- Formatação do buffer
    local fmt = function(_)
        if vim.lsp.buf.format then
            vim.lsp.buf.format()
        elseif vim.lsp.buf.formatting then
            vim.lsp.buf.formatting()
        end
    end
    nmap('<leader>cf', fmt, '[C]ode [F]ormat')
end

-- Instala e configura LSPs automaticamente
local default_servers = { 'clangd', 'rust_analyzer', 'pyright', 'sumneko_lua', 'texlab' }

require('mason').setup()
require('mason-lspconfig').setup {
    ensure_installed = default_servers,
}

-- Melhora autocomplete com LSP
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

for _, lsp in ipairs(default_servers) do
    require('lspconfig')[lsp].setup {
        on_attach = on_attach,
        capabilities = capabilities,
    }
end

-- Habilita LSP status
require('fidget').setup()

-- #############
--    SNIPPET
-- #############
-- Mapeia <c-j> e <c-k> para próximo campo / campo anterior do snippet
vim.UltiSnipsExpandTrigger = "<c-space>"
vim.UltiSnipsJumpForwardTrigger = "<c-j>"
vim.UltiSnipsJumpBackwardTrigger = "<c-k>"

-- ###########################
--    AUTOCOMPLETE (CONFIG)
-- ###########################
local cmp = require 'cmp'

cmp.setup {
    mapping = cmp.mapping.preset.insert {
        ['<c-b>'] = cmp.mapping.scroll_docs(-4),
        ['<c-f>'] = cmp.mapping.scroll_docs(4),
        ['<c-n>'] = cmp.mapping.select_next_item(),
        ['<c-p>'] = cmp.mapping.select_prev_item(),
        ['<c-space>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Insert,
            select = true
        },
    },
    window = {
        completion = cmp.config.window.bordered(),
    },
    formatting = {
        format = require('lspkind').cmp_format({
            mode = "symbol_text",
            menu = ({
                buffer = "[Buffer]",
                nvim_lsp = "[LSP]",
                luasnip = "[LuaSnip]",
                nvim_lua = "[Lua]",
                latex_symbols = "[Latex]",
                omni = "[Omni]",
            })
        }),
    },
    sources = {
        { name = 'nvim_lsp' },
        { name = 'nvim_lua' },
        { name = 'path' },
        { name = "ultisnips" },
        { name = 'buffer', keyword_length = 5 },
    },
    snippet = {
        expand = function(args)
            vim.fn["UltiSnips#Anon"](args.body)
        end,
    }
}

-- Integração com nvim-autopairs
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done({ map_char = { tex = '' } }))

-- #########################
--    CORRETOR AUTOMÁTICO
-- #########################
nmap("<leader>zz", function() vim.o.spell = not vim.o.spell end, "[Z]pell [Z]tart")
nmap("<leader>zc", "1z=", "[Z]pell [C]orrect Default")
nmap("<leader>zC", "1z=", "[Z]pell [C]orrect")
nmap("<leader>za", "zg", "[Z]pell [A]dd")

-- ##############
--    ZEN MODE
-- ##############
nmap('<leader>Z', require('zen-mode').toggle, 'Toogle [Z]en-Mode')

-- ##############
--    TERMINAL
-- ##############
-- Corrige caractere emitido por <C-,>, <C-[>, ... no kitty. Para mais informações: https://github.com/neovim/neovim/issues/17867#issuecomment-1079934289
if vim.env.TERM == 'xterm-kitty' then
    vim.cmd([[autocmd UIEnter * if v:event.chan ==# 0 | call chansend(v:stderr, "\x1b[>1u") | endif]])
    vim.cmd([[autocmd UILeave * if v:event.chan ==# 0 | call chansend(v:stderr, "\x1b[<1u") | endif]])
end

-- Usa neovim-remote como editor padrão (importante porque faz o git abrir direto no neovim):
if vim.fn.executable('nvr') == 1 then
    vim.env.GIT_EDITOR = 'nvr -cc split --remote-wait'
end

-- Deleta buffers abertos pelo git automaticamente ao fechar a janela (baseado nas instruções do github do neovim-remote)
local augroup = vim.api.nvim_create_augroup("NaniTerminal", {})
vim.api.nvim_create_autocmd("FileType", {
    pattern = "gitcommit,gitrebase,gitconfig",
    callback = function()
        vim.opt.bufhidden = "delete"
    end,
    group = augroup,
})

-- Entra no insert mode automaticamente ao entrar em um terminal
vim.api.nvim_create_autocmd("TermOpen", {
    pattern = "*",
    command = "startinsert",
    group = augroup,
})

-- Keymaps
-- Usa <c-,> como esc do modo terminal
vim.keymap.set('t', [[<C-,>]], [[<C-\><C-n>]])

nmap('<leader>to', '<cmd>term<cr>', '[T]erminal [O]pen')
nmap('<leader>ts', "<cmd>bo 12sp <bar> term<cr>", '[T]erminal [S]plit')
nmap('<leader>tv', "<cmd>bo vsp <bar> term<cr>", '[T]erminal [V]split')
nmap('<leader>tt', "<cmd>tabnew <bar> term<cr>", '[T]erminal [T]ab')
