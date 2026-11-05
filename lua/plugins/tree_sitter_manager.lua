-- lua/plugins/tree_sitter_manager.lua

vim.pack.add({
	{ src = "https://github.com/romus204/tree-sitter-manager.nvim" },
}, { load = function() end })

return {
	{
		"tree-sitter-manager.nvim",
		-- setup() registers the FileType autocmds that enable highlighting,
		-- so it has to run before the first buffer gets a filetype.
		event = { "BufReadPre", "BufNewFile" },
		cmd = { "TSManager", "TSInstall", "TSInstallSync", "TSUninstall", "TSUpdate", "TSUpdateSync" },
		after = function()
			require("tree-sitter-manager").setup()
		end,
	},
}
