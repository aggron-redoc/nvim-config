-- lua/plugins/witch_statusline.lua

vim.pack.add({
	{ src = "https://github.com/sontungexpt/witch-line.git" },
}, { load = function() end })

return {
	{
		"witch-line",
		lazy = false,
		after = function()
			require("witch-line").setup()
		end,
	},
}
