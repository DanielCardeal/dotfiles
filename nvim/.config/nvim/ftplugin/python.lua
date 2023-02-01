-- Snippets
local ls = require('luasnip')
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local fmt = require('luasnip.extras.fmt').fmt

ls.add_snippets("python", {
    s("#!", fmt([[
    #! /bin/env {}

    ]], { c(1, { t('python'), t('python3'), t('python2') }) })),

    s("ifmain", fmt([[
    if __name__ == "__main__":
        {}
    ]], { i(1, "pass") })),

    s('class', fmt([[
    class {}:
        {}
    ]], { i(1, "Name"), i(2, "pass") })),

    s('def', fmt([[
    def {}({}){}:
        {}
    ]], {
        i(1, 'name'),
        i(2, 'arguments'),
        c(3, { { t(' -> '), i(1, 'None') }, t('') }),
        i(4, 'pass'),
    })),

    -- Imports
    s('pd', t("import pandas as pd")),
    s('np', t("import numpy as np")),
})
