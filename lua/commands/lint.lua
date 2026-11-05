-- nvim-lint is lazy-loaded, so this autocmd is installed once at startup and
-- asks lz.n to load the plugin before using it. `trigger_load` also runs the
-- spec's `after` hook, which sets `linters_by_ft`.
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	callback = function()
		require("lz.n").trigger_load("nvim-lint")

		-- try_lint without arguments runs the linters defined in `linters_by_ft`
		-- for the current filetype
		require("lint").try_lint()

		-- You can call `try_lint` with a linter name or a list of names to always
		-- run specific linters, independent of the `linters_by_ft` configuration
		require("lint").try_lint("cspell")
	end,
})
