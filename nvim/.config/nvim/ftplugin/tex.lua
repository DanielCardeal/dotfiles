-- Correção de texto automaticamente acionada no LaTeX
vim.opt_local.spell = true

-- Completion
require('cmp').setup.buffer {
    sources = {
        { name = 'omni',   max_item_count = 5, priority = 9999},
        { name = 'luasnip' },
        { name = 'buffer', keyword_length = 5 },
    },
}


-- ##############
--    SNIPPETS
-- ##############
local ls = require('luasnip')
local s = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmt = require('luasnip.extras.fmt').fmt

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
