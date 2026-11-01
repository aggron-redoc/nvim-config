vim.pack.add({ "https://github.com/stevearc/oil.nvim" }, { load = true })

require("oil").setup({
	default_file_explorer = true,
	columns = { "icon" },
	delete_to_trash = true,
	watch_for_changes = true,

	buf_options = {
		buflisted = false,
		bufhidden = "hide",
	},

	view_options = {
		show_hidden = true,
		is_hidden_file = function(name)
			return vim.startswith(name, ".")
		end,
	},
	float = {
		max_height = 0.4,
		max_width = 0.6,
		border = "rounded",
	},
})
