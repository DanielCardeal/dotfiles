local wk = require('which-key')

-- Mappings do whichkey
wk.register({
	f = {
		name = "file",
		f = { "<cmd>Telescope find_files<cr>", "find files" },
		r = { "<cmd>Telescope oldfiles<cr>", "recent files" },
		s = { "<cmd>w<cr>", "save file" },
    },
	['.'] = { "<cmd>Telescope find_files<cr>", "find files" },
	[' '] = { "<cmd>Telescope git_files<cr>", "git files" },

	b = {
		name = "buffer",
		b = { "<cmd>Telescope buffers<cr>", "list buffers" },
		k = { "<cmd>bdelete<cr>", "delete buffer" },
	},
	[','] = { "<cmd>Telescope buffers<cr>", "list buffers" },

	w = {
		name = "window",
		w = { "<cmd>wNext<cr>", "window next" },
		s = { "<cmd>split<cr>", "split horiz" },
		v = { "<cmd>vsplit<cr>", "split vert" },
	},

    s = {
        name = "search",
        s = { "<cmd>Telescope current_buffer_fuzzy_find<cr>", "grep buffer" },
        t = { "<cmd>Telescope colorscheme<cr>", "themes" },
        m = { "<cmd>Telescope man_pages<cr>", "man pages" },
    },

    c = {
        name = "code",
        f = {"<cmd>lua vim.lsp.buf.formatting()<cr>", "format buffer" },
        f = {"<cmd>lua vim.lsp.buf.code_actions()<cr>", "format buffer" },
    },

    ["p"] = { "<cmd>Telescope projects<cr>", "projects" },
	["q"] = { "<cmd>q<cr>", "quit" },
    ["h"] = { "<cmd>Telescope help_tags<cr>", "help" },
    ["g"] = { "<cmd>Neogit<cr>", "git" },
    [":"] = { "<cmd>Telescope commands<cr>", "M-x" },
}, { prefix = "<leader>" })
