local M = {}

function M.setup(style)
    style = style or "darker"
    vim.g.material_style = style
end

function M.config()
    require("material").setup({
        contrast = {
            sidebars = true,
            floating_windows = true,
            popup_menu = true,
        },
        italics = {
            comments = true,
        },
        lualine_style = "stealth",
    })
    vim.cmd [[ colorscheme material ]]
end

return M
