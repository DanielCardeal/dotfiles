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
            -- "dap",
            -- "dashboard",
            "gitsigns",
            -- "hop",
            -- "indent-blankline",
            -- "lspsaga",
            "mini",
            -- "neogit",
            "nvim-cmp",
            -- "nvim-navic",
            "nvim-tree",
            "nvim-web-devicons",
            "sneak",
            "telescope",
            "trouble",
            "which-key",
        },
        lualine_style = "stealth",
    })
    vim.cmd [[ colorscheme material ]]
end

return M
