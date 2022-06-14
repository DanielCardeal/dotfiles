local M = {}

function M.config()
    vim.g.tokyonight_lualine_bold = true
    vim.cmd [[ colorscheme tokyonight ]]
end

return M
