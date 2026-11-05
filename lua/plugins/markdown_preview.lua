-- lua/plugins/markdown_preview.lua

vim.pack.add({
	{ src = "https://github.com/iamcco/markdown-preview.nvim" },
}, { load = function() end })

return {
	{
		"markdown-preview.nvim",
		ft = "markdown",
		-- The plugin reads these while sourcing plugin/mkdp.vim.
		before = function()
			vim.g.mkdp_theme = "dark"
			vim.g.mkdp_auto_start = 0
			vim.g.mkdp_auto_close = 1
		end,
	},
}
