local M = {}

function M.config()
    require("zen-mode").setup {
        window = {
            backdrop = 0.85, -- shade the backdrop of the Zen window. Set to 1 to keep the same as Normal
        },
    }
end

return M
