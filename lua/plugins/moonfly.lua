-- lua/plugins/moonfly.lua

vim.pack.add({
	{ src = "https://github.com/bluz71/vim-moonfly-colors", name = "moonfly" },
}, { load = function() end })

return {
	{
		"moonfly",
		-- The colorscheme has to exist before the first window is drawn.
		lazy = false,
		priority = 100,
		after = function()
			vim.g.moonflyCursorColor = true
			vim.cmd.colorscheme("moonfly")
		end,
	},
}
