local M = {}

function M.config()
    -- Linguagens que devem estar no sistema
    local linguagens = { "lua", "rust", "python", "c", "java", 'kotlin', }

    require('nvim-treesitter.configs').setup {
        ensure_installed = linguagens,
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
