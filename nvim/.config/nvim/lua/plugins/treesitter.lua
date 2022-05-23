local M = {}

function M.config()
    require('nvim-treesitter.configs').setup {
        highlight = { enable = true },
        textobjects = {
            select = {
                enable = true,
                lookahead = true,
                keymaps = {
                    ["if"] = "@function.inner", ["af"] = "@function.outer",
                    ["ia"] = "@parameter.inner", ["aa"] = "@parameter.outer",
                    ["il"] = "@loop.inner", ["al"] = "@loop.outer",
                    ["ic"] = "@class.inner", ["ac"] = "@class.outer",
                }
            }
        }
    }
end

return M
