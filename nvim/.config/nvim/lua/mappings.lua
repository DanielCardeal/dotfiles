local wk = require('which-key')
local ls = require('luasnip')

local map = vim.keymap.set

-- Atalhos sem prefixo
map('n', 'f', "<cmd>HopChar1<cr>", {})
map('n', 's', "<cmd>HopChar2<cr>", {})

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

-- Atalhos de <leader>
wk.register({
    f = {
        name = "file",
        f = { "<cmd>Telescope find_files<cr>", "find files" },
        r = { "<cmd>Telescope oldfiles<cr>", "recent files" },
        s = { "<cmd>w<cr>", "save file" },
    },

    b = {
        name = "buffer",
        k = { "<cmd>bp | bd#<cr>", "kill" },
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
        h = { "<cmd>Telescope help_tags<cr>", "manual" },
        t = { "<cmd>Telescope colorscheme<cr>", "themes" },
        b = { "<cmd>Telescope keymaps<cr>", "bindings" },
    },

    z = { '<cmd>Goyo<cr>', 'toggle zen' },

    [":"] = { "<cmd>Telescope commands<cr>", "M-x" },
    [' '] = { "<cmd>Telescope git_files<cr>", "git files" },
    [','] = { "<cmd>Telescope buffers<cr>", "list buffers" },
    ['.'] = { "<cmd>Telescope find_files<cr>", "find files" },
    ['<tab>'] = { '<cmd>NvimTreeToggle<cr>', 'toggle tree' },
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
    ['h'] = { "<cmd>GitGutterPrevHunk<cr>", "prev hunk" },
    ['e'] = { "<cmd> lua vim.diagnostic.goto_prev()<cr>", "prev err" }
}, { prefix = "[" })

-- Atalhos de movimentação ] (para frente)
wk.register({
    ['h'] = { "<cmd>GitGutterNextHunk<cr>", "next hunk" },
    ['e'] = { "<cmd> lua vim.diagnostic.goto_next()<cr>", "next err" }
}, { prefix = "]" })
