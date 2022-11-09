local M = {}

function M.config()
    require('orgmode').setup_ts_grammar()
    require('orgmode').setup {
        -- Agenda
        org_agenda_files = { '~/Documentos/org/agenda/*' },
        org_default_notes_file = '~/Documentos/org/refile.org',
        -- Estéticos
        org_hide_leading_stars = true,
        org_hide_emphasis_markers = true,
    }
end

return M
