-- Snippets
local ls = require('luasnip')
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local fmt = require('luasnip.extras.fmt').fmt

ls.add_snippets("markdown", {
    s("l", fmt([[
    [{}]({})
    ]], { i(1, 'alt'), i(2, 'url') })),

    s("img", fmt([[
    ![{}]({})
    ]], { i(1, 'alt'), i(2, 'path') })),

    s("h", fmt([[
    {} {}
    ]], { c(1, {
        t('#'),
        t('##'),
        t('###'),
        t('####'),
        t('#####'),
        t('######'),
    }), i(2, 'Header') }))
})
