-- lua/plugins/lsp.lua
--
-- Nothing here installs tools. Language servers, formatters and linters have
-- to be installed with the tool that owns them (brew, npm -g, cargo, pipx,
-- go install, ...) and are then enabled by hand — see the README.

vim.pack.add({
	{ src = "https://github.com/neovim/nvim-lspconfig.git" },
	{ src = "https://github.com/stevearc/conform.nvim.git" },
	{ src = "https://github.com/mfussenegger/nvim-lint.git" },
	{ src = "https://github.com/folke/lazydev.nvim.git" },
}, { load = function() end })

-- Uncomment the servers you have installed. `:checkhealth vim.lsp` lists the
-- ones Neovim can see on your $PATH.
local servers = {
	-- "lua_ls",
	-- "gopls",
	-- "ts_ls",
	-- "rust_analyzer",
	-- "pyright",
}

return {
	{
		"nvim-lspconfig",
		-- Load before the LSP client attaches to the first file.
		event = { "BufReadPre", "BufNewFile" },
		after = function()
			if #servers > 0 then
				vim.lsp.enable(servers)
			end
		end,
	},

	{
		"conform.nvim",
		-- Setup before the first buffer is written so `format_on_save` works.
		event = { "BufReadPre", "BufNewFile" },
		after = function()
			require("conform").setup({
				-- These formatters have to exist on your $PATH; conform itself
				-- installs nothing.
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
			-- Linters are external binaries too (`shellcheck`, `fish`, ...).
			require("lint").linters_by_ft = {
				sh = { "shellcheck" },
				bash = { "shellcheck" },
				fish = { "fish" },
			}
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
