-- #####################
--    VIMTEX (CONFIG)
-- #####################
vim.g.vimtex_view_general_viewer = 'evince'
vim.g.vimtex_complete_enabled = false
vim.g.vimtex_fold_enabled = true
vim.g.vimtex_format_enabled = false
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

local function comment_header(header)
    return string.rep("#", string.len(header[1][1]) + 6)
end

ls.add_snippets('tex', {
    -- #############
    --    SIMPLES
    -- #############
    -- Quote
    s("q", fmt("\\quote{{{}}} ", { i(1) })),

    -- ##################
    --    COMENTÁRIOS
    -- ##################
    s('chead', fmt([[
    % {}
    %    {}
    % {}

    ]], {
        f(comment_header, 1),
        i(1, 'header'),
        f(comment_header, 1),
    })),
})
