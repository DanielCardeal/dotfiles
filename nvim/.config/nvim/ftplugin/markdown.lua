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
