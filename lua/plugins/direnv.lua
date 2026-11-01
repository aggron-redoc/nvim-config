-- lua/plugins/direnv.lua

vim.pack.add({ "https://github.com/diniamo/direnv.nvim" }, { load = true })

require("direnv").setup({
	direnv = "direnv", -- default
	auto_load = true, -- default is false
	watch_envrc = true, -- default is false
})
