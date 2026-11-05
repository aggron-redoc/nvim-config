-- lua/plugins/base_16.lua

vim.pack.add({
	{ src = "https://github.com/RRethy/base16-nvim" },
}, { load = function() end })

-- `matugen.setup()` (called from init.lua after lz.n has loaded everything)
-- requires `base16-colorscheme`, so this one must be loaded at startup.
return {
	{ "base16-nvim", lazy = false, priority = 100 },
}
