require('nani.utils.ftype_setup').bufEnter({ "*.c", "*.h" }, function(utils)
    utils.wk.register({
        m = {
            name = "c",
            s = { "<cmd>Telescope tags<cr>", "search tags" },
            d = { "<C-]>", "goto definition" }
        }
    }, { prefix = '<leader>', buffer = utils.bufnr })
end)
