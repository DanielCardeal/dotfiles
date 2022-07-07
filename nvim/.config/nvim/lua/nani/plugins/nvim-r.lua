local M = {}

function M.setup()
    local g = vim.g
    g.R_auto_start = 1
    g.R_min_editor_width = 80
    -- Mapeia -- para <-
    g.R_assign_map = "--"
    -- Garante que o console será aberto em baixo fazendo ele ser muito largo
    g.R_rconsole_width = 1000
end

return M
