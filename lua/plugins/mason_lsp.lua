-- lua/plugins/mason_lsp.lua

vim.pack.add({
	{ src = "https://github.com/neovim/nvim-lspconfig.git" },
	{ src = "https://github.com/mason-org/mason.nvim.git" },
	{ src = "https://github.com/mason-org/mason-lspconfig.nvim.git" },
	{ src = "https://github.com/folke/lazydev.nvim.git" },
}, { load = function() end })

return {
	{
		"nvim-lspconfig",
		-- Load before the LSP client attaches to the first file.
		event = { "BufReadPre", "BufNewFile" },
		after = function()
			-- mason must be set up before mason-lspconfig, so load them in
			-- order instead of relying on the handler's table iteration.
			require("lz.n").trigger_load({ "mason.nvim", "mason-lspconfig.nvim" })
		end,
	},

	{
		"mason.nvim",
		lazy = true,
		after = function()
			require("mason").setup()
		end,
	},

	{
		"mason-lspconfig.nvim",
		lazy = true,
		before = function()
			require("lz.n").trigger_load("mason.nvim")
		end,
		after = function()
			require("mason-lspconfig").setup()
		end,
	},

	{
		"lazydev.nvim",
		ft = "lua",
		after = function()
			require("lazydev").setup({
				library = {
					-- vim.uv (luv) types, shipped inside Neovim
					{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				},
			})
		end,
	},
}
