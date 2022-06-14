local M = {}

function M.config()
    local null_ls = require('null-ls')
    null_ls.setup {
        sources = {
            -- Python
            null_ls.builtins.formatting.black,
            null_ls.builtins.formatting.isort,
        }
    }
end

return M
