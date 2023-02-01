-- Keymaps
ftmap('lua', 'n', "<leader>ms", "<cmd>so<cr>", "[S]ource file")
ftmap('lua', 'n', "<leader>mc",
    function()
        require('luasnip').cleanup()
        vim.cmd [[so]]
    end,
    "[C]leanup snippets and source file")

-- Snippets
local ls = require('luasnip')
local s = ls.snippet
local i = ls.insert_node
local c = ls.choice_node
local t = ls.text_node
local f = ls.function_node
local fmt = require('luasnip.extras.fmt').fmt

local function comment_header(header)
    return string.rep("#", string.len(header[1][1]) + 6)
end

ls.add_snippets("lua", {
    s("chead", fmt([[
    -- {}
    --    {}
    -- {}

    ]], {
        f(comment_header, 1),
        i(1, 'header'),
        f(comment_header, 1),
    })),

    s("mod", fmt([[
    local M = {{}}

    {}

    return M
    ]], { i(0) }
    )),

    s("nmap", fmt([[
    nmap("{}", {}, "{}")
    ]], {
        c(1, { { t("<leader>"), i(1, "map") }, i(nil, 'map') }),
        c(2, { { t('"<cmd>'), i(1, "command"), t('<cr>"') }, i(nil, 'cmd') }),
        i(3, "description")
    })),
})
