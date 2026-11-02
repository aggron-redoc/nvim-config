-- witch-line needs an attached UI. Defer setup until a UI connects so it is
-- configured exactly once, regardless of whether that is a TUI or a GUI.
vim.api.nvim_create_autocmd({ "UIEnter", "GUIEnter" }, {
	once = true,
	callback = function()
		require("witch-line").setup()
	end,
})
