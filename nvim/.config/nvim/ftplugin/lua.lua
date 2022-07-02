require('nani.utils.ftype_setup').bufEnter("*.lua", function(utils)
    utils.wk.register({
        m = {
            name = "lua",
            S = { "<cmd>luafile %<cr>", "source file" },
        }
    }, { prefix = '<leader>', buffer = utils.bufnr })
end)
