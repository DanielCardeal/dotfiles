local M = {}

function M.config()
    require('nvim-treesitter.configs').setup {
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = { 'org' }
        },
        textobjects = {
            select = {
                enable = true,
                lookahead = true,
                keymaps = {
                    ["if"] = "@function.inner", ["af"] = "@function.outer",
                    ["ia"] = "@parameter.inner", ["aa"] = "@parameter.outer",
                    ["il"] = "@loop.inner", ["al"] = "@loop.outer",
                }
            }
        },
        ensure_installed = { 'org' },
        -- Extensão treesitter-playground
        playground = {
            enable = true,
        }
    }
end

return M
