vim.pack.add({
	{
		src = "https://github.com/neovim/nvim-lspconfig.git",
	},
	{
		src = "https://github.com/mason-org/mason.nvim.git",
	},
	{
		src = "https://github.com/mason-org/mason-lspconfig.nvim.git",
	},
	{
		src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim.git",
	},
	{
		src = "https://github.com/stevearc/conform.nvim.git",
	},
	{
		src = "https://github.com/mfussenegger/nvim-lint.git",
	},
	{
		src = "https://github.com/folke/lazydev.nvim.git",
	},
})

require("mason").setup()
require("mason-lspconfig").setup()
require("mason-tool-installer").setup({
	ensure_installed = {
		"stylua",
	},
})

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
