local M = {}

function M.config()
    local t = require('telescope')
    t.setup {
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
    t.load_extension('fzf')
end

return M
