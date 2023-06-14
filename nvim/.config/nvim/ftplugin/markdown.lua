-- Compilação automática usando pandoc
local function setup_autocompile()
    if not vim.fn.executable('pandoc') then
        error("Impossível começar compilação automática: compilador `pandoc` não encontrado.")
    end

    vim.api.nvim_create_autocmd("BufWritePost", {
        pattern = '*.md',
        group = vim.api.nvim_create_augroup("MarkdownAutocompile", { clear = true }),
        callback = function()
            local basename = vim.fn.expand("<afile>:p:r")
            local cur_file = basename .. '.md'
            local out_file = basename .. '.pdf'
            vim.fn.jobstart({
                "pandoc",
                "-f", "markdown-implicit_figures",
                "-o", out_file,
                cur_file,
            })
        end
    })
end

local function stop_autocompile()
    vim.api.nvim_del_augroup_by_name("MarkdownAutocompile")
end

vim.api.nvim_create_user_command(
    "MarkdownStartAutocompile",
    setup_autocompile,
    {}
)

vim.api.nvim_create_user_command(
    "MarkdownStopAutocompile",
    stop_autocompile,
    {}
)

ftmap("Markdown", "n", "<leader>mc", "<cmd>MarkdownStartAutocompile<cr>",
    "Inicia compilação automática do arquivo.")

ftmap("Markdown", "n", "<leader>mC", "<cmd>MarkdownStopAutocompile<cr>",
    "Para compilação automática do arquivo.")

-- Snippets
local ls = require('luasnip')
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local fmt = require('luasnip.extras.fmt').fmt

ls.add_snippets("markdown", {
    -- Headers
    s("head", fmt([[
    {} {}
    ]], { c(1, {
        t('#'),
        t('##'),
        t('###'),
        t('####'),
        t('#####'),
        t('######'),
    }), i(2, 'Header') })),

    -- Links
    s("link", fmt([[
    [{}]({})
    ]], { i(1, 'alt'), i(2, 'url') })),

    -- Imagens
    s("img", fmt([[
    ![{}]({})
    ]], { i(1, 'alt'), i(2, 'path') })),

    -- Estilo
    s("it", { t({ "*" }), i(1), t({ "*" }) }),
    s("bold", { t({ "**" }), i(1), t({ "**" }) }),
    s("boldit", { t({ "***" }), i(1), t({ "***" }) }),

    -- Código
    s("code", { t({ "`" }), i(1), t({ "`" }) }),
    s("codeblock", fmt([[
    ```{}
    {}
    ```
    ]], { i(1, 'language'), i(2, 'code') }))
})
