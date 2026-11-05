-- lua/plugins/oil.lua

vim.pack.add({
	{ src = "https://github.com/stevearc/oil.nvim" },
}, { load = function() end })

return {
	{
		-- Oil only takes over directory buffers once it is set up, so `nvim .`
		-- falls back to netrw (no icons) unless oil is loaded at startup.
		-- Loading eagerly also guarantees mini.icons is set up first, which is
		-- what provides the "icon" column.
		"oil.nvim",
		lazy = false,
		after = function()
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
		end,
	},
}
