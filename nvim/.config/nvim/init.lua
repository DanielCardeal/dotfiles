---@diagnostic disable: lowercase-global
-- ######################
--    GENERAL SETTINGS
-- ######################
vim.g.mapleader = " "

vim.g.nani_scratch_bufnr = nil
vim.g.nani_scratch_height = 7

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
    clipboard = { "unnamed" },

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
require("lazy").setup({
    -- ###########
    --    ICONS
    -- ###########
    { "nvim-tree/nvim-web-devicons" },

    -- ###############
    --   COMMENTARY
    -- ###############
    { "tpope/vim-commentary" },

    -- ################
    --    DELIMITERS
    -- ################
    { "tpope/vim-surround" },
    {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        config = true
    },

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
        end,
    },

    -- ###############
    --    TELESCOPE
    -- ###############
    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        dependencies = {
            { "nvim-lua/plenary.nvim", lazy = true },
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
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        opts = {
            flavour = "mocha",
        }
    },

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
                lualine_b = {
                    {
                        "filename",
                        path = 1,
                    }
                },
                lualine_c = {
                    "branch",
                    "diff",
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
            winbar = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = { "filename" },
                lualine_x = {},
                lualine_y = {},
                lualine_z = {},
            },
            inactive_winbar = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = { "filename" },
                lualine_x = {},
                lualine_y = {},
                lualine_z = {},
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

    -- ###########
    --    SNEAK
    -- ###########
    {
        "justinmk/vim-sneak",
        init = function()
            vim.keymap.set({ "n" }, "f", "<Plug>Sneak_f")
            vim.keymap.set({ "n" }, "F", "<Plug>Sneak_F")
            vim.keymap.set({ "n" }, "t", "<Plug>Sneak_t")
            vim.keymap.set({ "n" }, "T", "<Plug>Sneak_T")
        end,
    },

    -- #############
    --    HARPOON
    -- #############
    { "ThePrimeagen/harpoon" },

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
local default_colorscheme = "catppuccin"
vim.cmd.colorscheme(default_colorscheme)

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

    { "<leader>u", vim.cmd.UndotreeToggle },

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

            -- If already focused on the scratch buffer:
            --   a) close window if there is another window
            --   b) ignore command if it is the only window
            if vim.api.nvim_get_current_buf() == vim.g.nani_scratch_bufnr then
                if #wins > 1 then
                    vim.api.nvim_win_close(0, false)
                end
                return
            end

            -- Focus scratch if it is already open in another window
            for _, win in pairs(wins) do
                if vim.api.nvim_win_get_buf(win) == vim.g.nani_scratch_bufnr then
                    vim.api.nvim_set_current_win(win)
                    return
                end
            end
            -- Otherwise, opens a new split and puts the scratch buffer there
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

    -- Add some quality of life text-objects:
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

-- Use jk to move up/down in command history
vim.keymap.set("i", "jk", "<esc>", { silent = true })
vim.keymap.set("i", "kj", "<esc>", { silent = true })

-- Use <c-k>/<c-j> to move up/down in command history
vim.keymap.set({ "c" }, "<c-k>", "<up>", { desc = "prev. command" })
vim.keymap.set({ "c" }, "<c-j>", "<down>", { desc = "next command" })

-- Use gj and gk in place of the normal j k movements.
vim.keymap.set({ "n", "v" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set({ "n", "v" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- <c-,> works as <esc> in the built-in terminal
vim.keymap.set("t", [[<C-,>]], [[<C-\><C-n>]])
