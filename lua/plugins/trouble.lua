-- lua/plugins/trouble.lua

vim.pack.add({
	{ src = "https://github.com/folke/trouble.nvim" },
}, { load = function() end })

return {
	{
		"trouble.nvim",
		-- `<CMD>Trouble …<CR>` mappings are backed by lz.n's command stubs,
		-- so the keymaps in lua/keymaps.lua need no changes.
		cmd = "Trouble",
		after = function()
			require("trouble").setup({
				focus = false, -- don't steal focus on open (default) [4]
				follow = true, -- follow the item under the cursor [4]
				auto_preview = true, -- preview in the main window [4]
				multiline = true, -- multi-line messages [4]
				warn_no_results = false,
				win = { border = "rounded" },
			})
		end,
	},
}
