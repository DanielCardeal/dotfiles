local M = {}

function M.setup()
    local g = vim.g
    g.R_assign = 2 -- mapeia __ para ->
    g.R_auto_start = 1
end

return M
