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

    ]], { c(1, { t('python3'), t('python2') }) })),

    -- Imports
    s('pd', t("import pandas as pd")),
    s('np', t("import numpy as np")),
    s('sns', t("import seaborn as sns"))
})
