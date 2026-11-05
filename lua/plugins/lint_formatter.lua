-- lua/plugins/lint_formatter.lua

vim.pack.add({
	{ src = "https://github.com/stevearc/conform.nvim.git" },
	{ src = "https://github.com/mfussenegger/nvim-lint.git" },
}, { load = function() end })

return {
	{
		"conform.nvim",
		-- Setup before the first buffer is written so `format_on_save` works.
		event = { "BufReadPre", "BufNewFile" },
		after = function()
			require("conform").setup({
				formatters_by_ft = {
					lua = { "stylua" },
				},

				format_on_save = {
					timeout_ms = 5000,
					lsp_format = "fallback",
				},
			})
		end,
	},

	{
		"nvim-lint",
		lazy = true,
		after = function()
			require("lint").linters_by_ft = {
				sh = { "shellcheck" },
				bash = { "shellcheck" },
				fish = { "fish" },
			}
		end,
	},
}
