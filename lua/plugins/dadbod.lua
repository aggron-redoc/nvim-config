-- lua/plugins/dadbod.lua

-- Connections, per the README's Lua form [1].
-- NOTHING SECRET HERE — see the note at the bottom of this message.
-- vim.g.dbs = {
--   { name = 'dev', url = 'postgres://localhost:5432/app_dev' },
--   { name = 'prod', url = function() return vim.fn.system('pass show db/prod'):gsub('\n', '') end },
-- }

vim.pack.add({
	{ src = "https://github.com/tpope/vim-dadbod" },
	{ src = "https://github.com/kristijanhusak/vim-dadbod-ui" },
	{ src = "https://github.com/kristijanhusak/vim-dadbod-completion" },
}, { load = function() end })

return {
	-- dadbod-ui calls into vim-dadbod's autoload/ functions.
	{ "vim-dadbod", lazy = true },

	-- blink's `dadbod` source requires `vim_dadbod_completion.blink`.
	{ "vim-dadbod-completion", ft = { "sql", "mysql", "plsql" } },

	{
		"vim-dadbod-ui",
		cmd = {
			"DBUI",
			"DBUIToggle",
			"DBUIClose",
			"DBUIAddConnection",
			"DBUIFindBuffer",
			"DBUIRenameBuffer",
			"DBUILastQueryInfo",
		},
		before = function()
			-- Read by plugin/db_ui.vim while it is sourced.
			vim.g.db_ui_use_nerd_fonts = 1
			vim.g.db_ui_winwidth = 35
			vim.g.db_ui_show_help = 0
			-- default: ~/.local/share/db_ui
			-- vim.g.db_ui_save_location = vim.fn.stdpath('data') .. '/db_ui'

			require("lz.n").trigger_load("vim-dadbod")
		end,
	},
}
