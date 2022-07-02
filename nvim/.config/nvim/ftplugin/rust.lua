require('nani.utils.ftype_setup').bufEnter("*.rs", function(utils)
    utils.wk.register({
        m = {
            name = 'rust',
            c = { "<cmd>RustOpenCargo<cr>", 'open cargo' },
            m = { "<cmd>RustExpandMacro<cr>", 'expand macro' },
            r = { "<cmd>RustRunnables<cr>", 'run' },
            R = { "<cmd>RustReloadWorkspace<cr>", 'reload workspace' },
        }
    }, { prefix = '<leader>', buffer = utils.bufnr })
end)
