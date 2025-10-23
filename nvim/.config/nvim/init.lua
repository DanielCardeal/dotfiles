---@diagnostic disable: lowercase-global
vim.g.mapleader = " "

vim.g.nani_scratch_bufnr = nil
vim.g.nani_scratch_height = 7

vim.cmd.colorscheme("default")

local set = {
    termguicolors = true,
    background = "dark",

    confirm = true,
    undofile = true,
    swapfile = false,
    backup = false,
    writebackup = false,

    ignorecase = true,
    smartcase = true,
    incsearch = true,
    inccommand = "split",
    colorcolumn = "80",

    scrolloff = 5,

    wrap = true,
    breakindent = true,
    textwidth = 0,
    smartindent = true,
    linebreak = true,

    list = true,
    listchars = {
        tab = "» ",
        trail = "·",
        -- eol = "↳",
    },

    updatetime = 250,
    timeoutlen = 300,

    winbar = "%f",
    laststatus = 3,

    tabstop = 4,
    shiftwidth = 0,
    expandtab = true,

    relativenumber = true,
    number = true,
    cursorline = true,
    signcolumn = "auto:2",
    fillchars = { diff = "╱", eob = " " },

    spellsuggest = "best,9",
    spelllang = { "pt_br", "en" },

    splitright = true,
    splitbelow = true,

    conceallevel = 2,
    concealcursor = "c",
}
for k, v in pairs(set) do
    vim.opt[k] = v
end

-- NOTE: usa schedule pra evitar delay na inicialização
vim.schedule(function()
    vim.o.clipboard = "unnamedplus"
end)

-- Baixa e configura lazy nvim na primeira vez que inicia o neovim após a instalação
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

require("lazy").setup({
    { "tpope/vim-surround" },
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = true,
    },

    {
        "folke/which-key.nvim",
        event = "VimEnter",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end,
        opts = {},
    },

    {
        "folke/zen-mode.nvim",
        keys = {
            {
                "<leader>cz",
                "<cmd>ZenMode<cr>",
                mode = "n",
                desc = "Toggle Zen",
            },
        },
        opts = {},
    },

    {
        "echasnovski/mini.nvim",
        version = false,
        config = function()
            require("mini.starter").setup()
            require("mini.comment").setup()

            require("mini.files").setup({})
            vim.keymap.set({ "n" }, "<leader><tab>", MiniFiles.open, { desc = "File explorer" })

            require("mini.cursorword").setup({
                delay = 1000 --[[ ms ]],
            })
            vim.api.nvim_set_hl(0, "MiniCursorwordCurrent", { link = "Visual" })
            vim.api.nvim_set_hl(0, "MiniCursorword", { link = "MiniCursorwordCurrent" })

            local statusline = require("mini.statusline")
            statusline.section_location = function()
                return "%2l:%-2v"
            end
            statusline.section_git = function()
                return vim.b.gitsigns_head or ""
            end
            statusline.section_diff = function()
                return vim.b.gitsigns_status or ""
            end
            statusline.section_fileinfo = function(args)
                local filetype = vim.bo.filetype
                local encoding = vim.bo.fileencoding or vim.bo.encoding
                local format = vim.bo.fileformat
                if statusline.is_truncated(args.trunc_width) or filetype == "" then
                    return filetype
                else
                    return string.format("%s%s[%s]", filetype == "" and "" or filetype .. " ", encoding, format)
                end
            end
            statusline.setup({
                use_icons = false,
                active = function()
                    local mode, mode_hl = statusline.section_mode({ trunc_width = 120 })
                    local git = statusline.section_git()
                    local diff = statusline.section_diff()
                    local lsp = statusline.section_lsp({ trunc_width = 75 })
                    local filename = statusline.section_filename({ trunc_width = 140 })
                    local fileinfo = statusline.section_fileinfo({ trunc_width = 120 })
                    local location = statusline.section_location()
                    local search = statusline.section_searchcount({ trunc_width = 75 })
                    return statusline.combine_groups({
                        { hl = mode_hl, strings = { mode } },
                        { hl = "MiniStatuslineDevinfo", strings = { git, diff, lsp } },
                        "%<",
                        { hl = "MiniStatuslineFilename", strings = { filename } },
                        "%=",
                        { hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
                        { hl = mode_hl, strings = { search, location } },
                    })
                end,
            })
        end,
    },

    {
        "nvim-telescope/telescope.nvim",
        event = "VimEnter",
        branch = "0.1.8",
        dependencies = {
            { "nvim-lua/plenary.nvim", lazy = true },
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",
                cond = function()
                    return vim.fn.executable("make") == 1
                end,
            },
        },
        config = function()
            local telescope = require("telescope")
            local actions = require("telescope.actions")
            telescope.setup({
                defaults = {
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
            pcall(telescope.load_extension, "fzf")
        end,
    },

    {
        "neovim/nvim-lspconfig",
        dependencies = {
            { "mason-org/mason.nvim", opts = {} },
            "mason-org/mason-lspconfig.nvim",
            { "saghen/blink.cmp" },
            { "j-hui/fidget.nvim", opts = {} },
        },
        config = function()
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("NaniLspConfig", { clear = true }),
                callback = function(ev)
                    local map = function(lhs, rhs, desc, mode)
                        mode = mode or "n"
                        vim.keymap.set(mode, lhs, rhs, { buffer = ev.buf, desc = "LSP: " .. desc })
                    end

                    map("<leader>cr", vim.lsp.buf.rename, "rename")
                    map("<leader>ca", vim.lsp.buf.code_action, "code action")

                    map("<leader>si", require("telescope.builtin").lsp_document_symbols, "open document symbols")

                    map("gD", vim.lsp.buf.declaration, "goto declaration")
                    map("gd", require("telescope.builtin").lsp_definitions, "goto definitions")
                    map("gr", require("telescope.builtin").lsp_references, "goto references")
                    map("gI", require("telescope.builtin").lsp_implementations, "goto implementations")

                    map("<c-h>", vim.lsp.buf.signature_help, "function signature", "i")

                    map("]e", vim.diagnostic.goto_next, "next error")
                    map("[e", vim.diagnostic.goto_prev, "previous error")
                    map("<leader>e", vim.diagnostic.open_float, "show error")
                end,
            })

            local servers = {
                gopls = {},
                lua_ls = {},
            }
            require("mason-lspconfig").setup({
                ensure_installed = { "gopls", "lua_ls" },
                automatic_installation = false,
                handlers = {
                    function(server_name)
                        local server_config = servers[server_name] or {}
                        server_config.capabilities =
                            require("blink.cmp").get_lsp_capabilities(server_config.capabilities)
                        require("lspconfig")[server_name].setup(server_config)
                    end,
                },
            })
        end,
    },
    {
        "stevearc/conform.nvim",
        event = { "BufWritePre" },
        cmd = { "ConformInfo" },
        keys = {
            {
                "<leader>cf",
                function()
                    require("conform").format({ async = true })
                end,
                mode = "n",
                desc = "Format buffer",
            },
        },
        opts = {
            formatters_by_ft = {
                lua = { "stylua" },
                go = { "goimports", "gofmt" },
            },
        },
    },

    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = {
                    "lua",
                    "luadoc",
                    "markdown",
                    "markdown_inline",
                },
                auto_install = true,
                highlight = { enable = true },
                indent = { enable = true },
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

    {
        "saghen/blink.cmp",
        dependencies = { "rafamadriz/friendly-snippets" },
        version = "1.*",
        opts = {
            keymap = { preset = "enter" },
            sources = {
                default = { "lsp", "path", "snippets", "buffer" },
            },
        },
        opts_extend = { "sources.default" },
    },

    {
        "lewis6991/gitsigns.nvim",
        event = "VeryLazy",
        opts = {
            sign_priority = 10,
            signs = {
                add = { text = "+" },
                change = { text = "~" },
                delete = { text = "_" },
                topdelete = { text = "‾" },
                changedelete = { text = "~" },
            },
        },
    },
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

    {
        "justinmk/vim-sneak",
        init = function()
            vim.keymap.set({ "n" }, "f", "<Plug>Sneak_f")
            vim.keymap.set({ "n" }, "F", "<Plug>Sneak_F")
            vim.keymap.set({ "n" }, "t", "<Plug>Sneak_t")
            vim.keymap.set({ "n" }, "T", "<Plug>Sneak_T")
        end,
    },

    { "ThePrimeagen/harpoon" },

    {
        "fatih/vim-go",
        init = function ()
            vim.g.go_fmt_autosave = 0
            vim.g.go_imports_autosave = 0
            vim.g.go_code_completion_enabled = 0
            vim.g.go_doc_popup_window = 1
        end,
        ft = "go",
    },

    { "fladson/vim-kitty" },
})

-- "pisca" quando copia o texto
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank()
    end,
    group = vim.api.nvim_create_augroup("YankHighlight", { clear = true }),
    pattern = "*",
})

-- Keymaps
local wk = require("which-key")
wk.add({
    { "<leader>c", group = "code" },
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
        { "<leader>gg", "<cmd>Git<cr>", desc = "git status" },
        { "<leader>gl", "<cmd>Git log<cr>", desc = "git log" },
        { "<leader>gP", "<cmd>Git push<cr>", desc = "git push" },
        { "<leader>gb", "<cmd>Git blame<cr>", desc = "git blame" },
        { "<leader>gm", "<cmd>Gdiffsplit!<cr>", desc = "git merge file" },
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

    {
        "<leader>q",
        function()
            vim.api.nvim_win_close(0, false)
        end,
        desc = "close window",
    },
    { "<leader>Q", "<cmd>copen<cr>", desc = "focus qflist" },

    { "<leader>w", "<c-w>", group = "windows", hidden = true },
    {
        "<leader>x",
        function()
            wins = vim.api.nvim_list_wins()
            if vim.g.nani_scratch_bufnr == nil then
                vim.g.nani_scratch_bufnr = vim.api.nvim_create_buf(true, true)
            end

            -- se o rascunho já está aberto:
            --   a) fecha a janela se já tem outra janela aberta
            --   b) ignora se for a única janela aberta
            if vim.api.nvim_get_current_buf() == vim.g.nani_scratch_bufnr then
                if #wins > 1 then
                    vim.api.nvim_win_close(0, false)
                end
                return
            end

            -- foca o scratch buffer se ele já estiver aberto em outra janela
            for _, win in pairs(wins) do
                if vim.api.nvim_win_get_buf(win) == vim.g.nani_scratch_bufnr then
                    vim.api.nvim_set_current_win(win)
                    return
                end
            end
            -- cc. abre novo split com um scratch buffer
            vim.cmd("split")
            vim.api.nvim_win_set_height(0, vim.g.nani_scratch_height)
            vim.api.nvim_win_set_buf(0, vim.g.nani_scratch_bufnr)
        end,
        desc = "scratch",
    },
    { "<leader><leader>", "<cmd>Telescope git_files<cr>", desc = "open file (git)" },

    -- Harpoon
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
        "<leader><",
        function()
            require("harpoon.mark").add_file()
        end,
        desc = "harpoon add",
    },
    {
        "<leader>>",
        function()
            require("harpoon.ui").toggle_quick_menu()
        end,
        desc = "harpoon menu",
    },

    -- Text object para buffer e git
    --  g --> buffer
    --  h --> hunk
    {
        mode = { "o", "x" },
        { "ig", ":<c-u>normal! ggVG<cr>", desc = "text obj: buffer" },
        { "ag", ":<c-u>normal! ggVG<cr>", desc = "text obj: buffer" },
        { "ih", ":<c-u>Gitsigns select_hunk<cr>", desc = "text obj: hunk" },
        { "ah", ":<c-u>Gitsigns select_hunk<cr>", desc = "text obj: hunk" },
    },
})

vim.keymap.set("i", "jk", "<esc>", { silent = true })
vim.keymap.set("n", "<leader>;", ":")

-- Navegação do histórico de comandos
vim.keymap.set({ "c" }, "<c-k>", "<up>", { desc = "prev. command" })
vim.keymap.set({ "c" }, "<c-j>", "<down>", { desc = "next command" })

-- Navegação em linhas visuais
vim.keymap.set({ "n", "v" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set({ "n", "v" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
