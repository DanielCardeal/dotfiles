local M = {}

function M.config()
    local setup = {
        extensions = {
            -- Extensão para fuzzy search com padrões inteligentes
            fzf = {
                fuzzy = true,
                override_generic_sorter = true,
                override_file_sorter = true,
            }
        },
        pickers = {
            find_files = {
                -- Mostra arquivos ocultos em <leader>ff
                hidden = true,
                file_ignore_patterns = { '.git' },
            },
            live_grep = {
                -- Busca em arquivos oculto em <leader>sp
                additional_args = function(opts)
                    return { '--hidden' }
                end,
                file_ignore_patterns = { '.git' },
            }
        }
    }

    -- Temas
    local themes = {
        ivy = {},
        dropdown = { 'find_files', 'old_files', 'git_files', 'buffers', 'oldfiles' },
        cursor = {},
    }
    for theme, pickers in pairs(themes) do
        for _, picker in ipairs(pickers) do
            setup.pickers[picker] = setup[picker] or {}
            setup.pickers[picker].theme = theme
        end
    end

    -- Inicialização e extensões
    local t = require('telescope')
    t.setup(setup)
    t.load_extension('fzf')
end

return M
