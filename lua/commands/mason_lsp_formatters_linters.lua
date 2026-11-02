vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	callback = function()
		-- try_lint without arguments runs the linters defined in `linters_by_ft`
		-- for the current filetype
		require("lint").try_lint()

		-- You can call `try_lint` with a linter name or a list of names to always
		-- run specific linters, independent of the `linters_by_ft` configuration
		require("lint").try_lint("cspell")
	end,
})

--lazydev for nvim apis
vim.api.nvim_create_autocmd("FileType", {
	pattern = "lua",
	once = true,
	callback = function()
		vim.cmd.packadd("lazydev.nvim")
		require("lazydev").setup({
			library = {
				-- vim.uv (luv) types, shipped inside Neovim
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		})
	end,
})

vim.api.nvim_create_autocmd({ "CmdlineEnter", "UIEnter", "GUIEnter" }, {
	once = true,
	callback = function()
		local blink = require("commands.blink")
		blink()
		require("mason").setup()
		require("mason-lspconfig").setup()
		require("conform").setup({
			formatters_by_ft = {
				lua = { "stylua" },
			},

			format_on_save = {
				timeout_ms = 5000,
				lsp_format = "fallback",
			},
		})

		require("lint").linters_by_ft = {
			sh = { "shellcheck" },
			bash = { "shellcheck" },
			fish = { "fish" },
		}
		require("plugins.dap")
	end,
})
