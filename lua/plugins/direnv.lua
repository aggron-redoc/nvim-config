-- lua/plugins/direnv.lua

vim.pack.add({
	{ src = "https://github.com/diniamo/direnv.nvim" },
}, { load = function() end })

return {
	{
		"direnv.nvim",
		-- `auto_load` needs the BufEnter autocmds from setup, but nothing is
		-- needed before the first real buffer is opened.
		event = "DeferredUIEnter",
		cmd = "Direnv",
		after = function()
			require("direnv").setup({
				direnv = "direnv", -- default
				auto_load = true, -- default is false
				watch_envrc = true, -- default is false
			})
		end,
	},
}
