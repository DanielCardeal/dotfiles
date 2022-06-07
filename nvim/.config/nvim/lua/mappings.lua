local wk = require('which-key')
local ls = require('luasnip')

local map = vim.keymap.set

-- Atalhos sem prefixo
map({ 'n', 'v' }, 'f', "<cmd>HopChar1<cr>", {})
map({ 'n', 'v' }, 's', "<cmd>HopChar2<cr>", {})
map('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', {})
map({ 'o', 'x' }, 'ih', ':<c-u>Gitsigns select_hunk<cr>', {})

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
        f = { "<cmd>Telescope find_files<cr>", "find files" },
        r = { "<cmd>Telescope oldfiles<cr>", "recent files" },
        s = { "<cmd>w<cr>", "save file" },
    },

    g = {
        name = "git",
        s = { '<cmd>Gitsigns stage_hunk<cr>', 'stage hunk' },
        u = { '<cmd>Gitsigns undo_stage_hunk<cr>', 'undo hunk' },
        d = { '<cmd>Gitsigns preview_hunk<cr>', 'preview hunk' },
        b = { '<cmd>Gitsigns blame_line<cr>', 'blame line' },
        B = { '<cmd>lua require("gitsigns").blame_line { full = true }<cr>', 'blame line (full)' },
        q = { '<cmd>Gitsigns setqflist all<cr>', 'set qflist' },
        r = { '<cmd>Gitsigns reset_hunk<cr>', 'reset hunk' },
        R = { '<cmd>Gitsigns reset_buffer<cr>', 'reset buffer' },
    },

    b = {
        name = "buffer",
        k = { "<cmd>bp | bd#<cr>", "kill" },
    },

    c = {
        name = 'code',
        r = { '<cmd>lua vim.lsp.buf.rename()<CR>', 'rename' },
        a = { '<cmd>lua vim.lsp.buf.code_action()<CR>', 'actions' },
        f = { '<cmd>lua vim.lsp.buf.formatting()<CR>', 'format' },
    },

    w = {
        '<Cmd>lua require("which-key").show("\23", {mode = "n", auto = true})<CR>',
        "window"
    },

    s = {
        name = "search",
        s = { "<cmd>Telescope current_buffer_fuzzy_find<cr>", "grep buffer" },
        p = { "<cmd>Telescope live_grep<cr>", "grep dir" },
        t = { "<cmd>Telescope colorscheme<cr>", "themes" },
        m = { "<cmd>Telescope man_pages<cr>", "man pages" },
    },

    t = {
        name = "trouble",
        t = { "<cmd>Trouble<cr>", "focus" },
        d = { "<cmd>Trouble document_diagnostics<cr>", "buf diag" },
        D = { "<cmd>Trouble workspace_diagnostics<cr>", "work diag" },
        q = { "<cmd>Trouble quickfix<cr>", "quickfix" },
        l = { "<cmd>Trouble loclist<cr>", "loclist" },
        g = { "<cmd>TodoTrouble<cr>", "TODOs" },
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

    Z = { '<cmd>Goyo<cr>', 'toggle zen' },

    [' '] = { "<cmd>Telescope git_files<cr>", "git files" },
    [','] = { "<cmd>Telescope buffers<cr>", "list buffers" },
    ['.'] = { "<cmd>Telescope find_files<cr>", "find files" },
    ['<tab>'] = { require('plugins.nvim-tree').nani_toggle_nvimtree, 'toggle tree' },
}, { prefix = "<leader>" })

-- Atalhos de goto
wk.register({
    s = {
        name = "hop",
        w = { "<cmd>HopWord<cr>", "word" },
        l = { "<cmd>HopLine<cr>", "line" },
        k = { "<cmd>HopLineBC<cr>", "line up" },
        j = { "<cmd>HopLineAC<cr>", "line down" },
        ["/"] = { "<cmd>HopPattern<cr>", "pattern" },
    },
}, { prefix = 'g' })

-- Atalhos de movimentação [ (para trás)
wk.register({
    ['h'] = { "<cmd>Gitsigns prev_hunk<cr>", "prev hunk" },
    ['e'] = { "<cmd> lua vim.diagnostic.goto_prev()<cr>", "prev err" }
}, { prefix = "[" })

-- Atalhos de movimentação ] (para frente)
wk.register({
    ['h'] = { "<cmd>Gitsigns next_hunk<cr>", "next hunk" },
    ['e'] = { "<cmd> lua vim.diagnostic.goto_next()<cr>", "next err" }
}, { prefix = "]" })
