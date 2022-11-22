local wk = require('which-key')
local ls = require('luasnip')

local map = vim.keymap.set

-- Atalhos sem prefixo
map('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>')
map('n', '<tab>', 'za') -- Toggle de folds usando <tab>

-- Melhora movimento em linhas visuais
map({ 'n', 'v' }, 'j', 'gj')
map({ 'n', 'v' }, 'k', 'gk')

-- Text objects
map({ 'o', 'x' }, 'ih', ':<c-u>Gitsigns select_hunk<cr>')
map({ 'o', 'x' }, 'ah', ':<c-u>Gitsigns select_hunk<cr>')

map({ 'o', 'x' }, 'ig', ':<c-u>normal! ggVG<cr>')
map({ 'o', 'x' }, 'ag', ':<c-u>normal! ggVG<cr>')

-- <c-j> para próximo campo do snippet
map({ "i", "s" }, "<c-j>", function()
    if ls.expand_or_jumpable() then
        ls.expand_or_jump()
    end
end)
-- <c-k> para campo anterior do snippet
map({ "i", "s" }, "<c-k>", function()
    if ls.jumpable(-1) then
        ls.jump(-1)
    end
end)

-- Comandos de goto (sem leader)
wk.register({
    g = {
        name = "goto",
        D = { '<cmd>lua vim.lsp.buf.declaration()<CR>', 'declaration' },
        d = { '<cmd>lua vim.lsp.buf.definition()<CR>', 'definition' },
        r = { '<cmd>lua vim.lsp.buf.references()<CR>', 'references' },
        i = { '<cmd>lua vim.lsp.buf.implementation()<CR>', 'implementation' },
    }
})

-- Atalhos de <leader>
wk.register({
    f = {
        name = "file",
        d = { "<cmd>Telescope zoxide list theme=dropdown<cr>", "goto dir" },
        f = { "<cmd>Telescope find_files<cr>", "find files" },
        r = { "<cmd>Telescope oldfiles<cr>", "recent files" },
        s = { "<cmd>w<cr>", "save file" },
        S = { "<cmd>wa<cr>", "save all" },
        p = { "<cmd>let @+ = expand('%:t')<cr>", "copy path" },
        P = { "<cmd>let @+ = expand('%:p')<cr>", "copy full path" },
    },

    q = { "<cmd>q<cr>", "close window" },

    g = {
        name = "git",
        s = { '<cmd>Gitsigns stage_hunk<cr>', 'stage hunk' },
        u = { '<cmd>Gitsigns undo_stage_hunk<cr>', 'undo hunk' },
        p = { '<cmd>Gitsigns preview_hunk<cr>', 'preview hunk' },
        b = { '<cmd>Telescope git_branches<cr>', 'branch' },
        q = {
            function()
                require('gitsigns').setqflist('all', { open = false })
                print('Git hunks sent to qflist')
            end,
            'set qflist'
        },
        r = { '<cmd>Gitsigns reset_hunk<cr>', 'reset hunk' },
        R = { '<cmd>Gitsigns reset_buffer<cr>', 'reset buffer' },
        d = {
            name = 'diffview',
            c = { '<cmd>DiffviewClose<cr>', 'close' },
            f = { '<cmd>DiffviewFocusFiles<cr>', 'focus files' },
            o = { '<cmd>DiffviewOpen<cr>', 'open' },
            r = { '<cmd>DiffviewRefresh<cr>', 'refresh' },
            t = { '<cmd>DiffviewToggleFiles<cr>', 'toggle files' },
            h = { '<cmd>DiffviewFileHistory %<cr>', 'history current file' },
            H = { '<cmd>DiffviewFileHistory<cr>', 'history all files' },
        }
    },

    o = {
        name = 'org',
    },

    b = {
        name = "buffer",
        k = { "<cmd>lua MiniBufremove.delete()<cr>", "delete this" },
    },

    c = {
        name = 'code',
        r = { '<cmd>lua vim.lsp.buf.rename()<CR>', 'rename' },
        a = { '<cmd>lua vim.lsp.buf.code_action()<CR>', 'actions' },
        f = { '<cmd>lua vim.lsp.buf.format { async = true }<CR>', 'format' },
        d = { "<cmd>TroubleToggle document_diagnostics<cr>", "buf diag" },
        D = { "<cmd>TroubleToggle workspace_diagnostics<cr>", "work diag" },
        q = { "<cmd>TroubleToggle quickfix<cr>", "quickfix" },
        l = { "<cmd>TroubleToggle loclist<cr>", "loclist" },
    },

    d = {
        name = "debugger",
        t = { "<cmd>lua require('dap').toggle_breakpoint()<cr>", "toggle breakpoint" },
        c = { "<cmd>lua require('dap').continue()<cr>", "continue" },
        b = { "<cmd>lua require('dap').terminate()<cr>", "break" },
        n = { "<cmd>lua require('dap').step_over()<cr>", "next" },
        i = { "<cmd>lua require('dap').step_into()<cr>", "step in" },
        o = { "<cmd>lua require('dap').step_out()<cr>", "step out" },
        q = { "<cmd>lua require('dap').close()<cr>", "quit" },
        r = { "<cmd>lua require('dap').repl.open()<cr>", "repl" },
    },

    w = {
        '<Cmd>lua require("which-key").show("\23", {mode = "n", auto = true})<CR>',
        "window"
    },

    s = {
        name = "search",
        s = { "<cmd>Telescope current_buffer_fuzzy_find<cr>", "grep buffer" },
        p = { "<cmd>Telescope live_grep<cr>", "grep dir" },
        m = { "<cmd>Telescope man_pages<cr>", "man pages" },
        i = { "<cmd>Telescope lsp_document_symbols<cr>", "symbols" },
    },

    t = {
        name = "terminal",
        s = { "<cmd>bo 12sp <bar> term<cr>", "term below" },
        v = { "<cmd>bo vsp <bar> term<cr>", "term right" },
        o = { "<cmd>term<cr>", "term here" },
        t = { "<cmd>tabnew <bar> term<cr>", "term tab" },
    },

    l = {
        name = "lsp",
        i = { "<cmd>LspInfo<cr>", "info" },
        p = { "<cmd>LspPrintInstalled<cr>", "print servers" },
        s = { "<cmd>LspStart<cr>", "start server" },
        S = { "<cmd>LspStop<cr>", "stop server" },
    },

    p = {
        name = 'packer',
        s = { "<cmd>PackerSync<cr>", "sync" },
        i = { "<cmd>PackerStatus<cr>", "info" },
        c = { "<cmd>PackerCompile<cr>", "compile" },
        C = { "<cmd>PackerCompile profile=true<cr>", "compile for profiling" },
        p = { "<cmd>PackerProfile<cr>", "profile" },
    },

    h = {
        name = 'help',
        h = { "<cmd>Telescope help_tags<cr>", "help" },
        m = { "<cmd>Telescope man_pages<cr>", "man" },
        t = { "<cmd>Telescope colorscheme<cr>", "themes" },
        b = { "<cmd>Telescope keymaps<cr>", "bindings" },
    },

    z = {
        function() vim.o.spell = not vim.o.spell end,
        "toggle spell"
    },

    [' '] = { "<cmd>Telescope git_files<cr>", "git files" },
    [','] = { "<cmd>Telescope buffers<cr>", "list buffers" },
    ['.'] = { "<cmd>Telescope find_files<cr>", "find files" },
    ['<tab>'] = { require('nani.plugins.nvim-tree').nani_toggle_nvimtree, 'toggle tree' },
}, { prefix = "<leader>" })

-- Atalhos de leader (visual mode)
wk.register({
    c = {
        name = 'code',
        f = { '<cmd>lua vim.lsp.buf.range_formatting()<CR>', 'format range' },
    },
}, { prefix = "<leader>", mode = "v" })

-- Atalhos de movimentação [ (para trás)
wk.register({
    h = { "<cmd>Gitsigns prev_hunk<cr>", "Previous hunk" },
    e = { "<cmd> lua vim.diagnostic.goto_prev()<cr>", "Previous error" },
    q = { "<cmd>cprevious<cr>", "Previous qfix" },
    l = { "<cmd>lprevious<cr>", "Previous loc" },
}, { prefix = "[" })

-- Atalhos de movimentação ] (para frente)
wk.register({
    h = { "<cmd>Gitsigns next_hunk<cr>", "Next hunk" },
    e = { "<cmd> lua vim.diagnostic.goto_next()<cr>", "Next error" },
    q = { "<cmd>cnext<cr>", "Next qfix" },
    l = { "<cmd>lnext<cr>", "Next loc" },
}, { prefix = "]" })
