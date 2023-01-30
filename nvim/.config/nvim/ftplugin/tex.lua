-- #####################
--    VIMTEX (CONFIG)
-- #####################
vim.g.vimtex_view_general_viewer = 'evince'
vim.g.vimtex_complete_enabled = false
vim.g.vimtex_quickfix_mode = 2

-- Correção de texto automaticamente acionada no LaTeX
vim.opt_local.spell = true

-- ##############
--    SNIPPETS
-- ##############
local ls = require('luasnip')
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local fmt = require('luasnip.extras.fmt').fmt
local rep = require('luasnip.extras').rep

ls.add_snippets('tex', {
    -- #############
    --    SIMPLES
    -- #############
    -- Quote
    s("q", fmt("\\quote{{{}}} ", { i(1) })),

    -- Itálico
    s("i", fmt("\\textit{{{}}} ", { i(1) })),

    -- Negrito
    s("b", fmt("\\textbf{{{}}} ", { i(1) })),

    -- Matemática
    s("m", fmt("${}$", { i(1) })),

    -- ##################
    --    ENVIRONMENTS
    -- ##################
    -- Básico
    s("beg", fmt([[
    \begin{{{}}}
        {}
    \end{{{}}}
    ]], {
        i(1, 'environment'),
        i(0),
        rep(1)
    })),

    -- Imagem
    s("img", fmt([[
    \begin{{figure}}[ht!]
        \includegraphics{{{}}}
        \caption{{{}}}
    \end{{figure}}

    ]], {
        i(1, 'image path'),
        i(2, 'image caption')
    })),
})
