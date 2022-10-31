local M = {}

function M.setup(style)
    vim.g.material_style = style or "darker"
end

function M.config()
    require("material").setup({
        contrast = {
            sidebars = true,
            floating_windows = true,
            popup_menu = true,
        },
        styles = {
            comments = { italic = true },
            strings = { bold = true },
            keywords = { bold = true },
        },
        plugins = {
            "gitsigns",
            "mini",
            "nvim-cmp",
            "nvim-tree",
            "telescope",
            "which-key",
            "trouble",
            -- "dap",
            -- "dashboard",
            -- "hop",
            -- "indent-blankline",
            -- "lspsaga",
            -- "neogit",
            -- "nvim-navic",
            -- "sneak",
        },
        lualine_style = "stealth",
    })
    vim.cmd [[ colorscheme material ]]
end

return M
