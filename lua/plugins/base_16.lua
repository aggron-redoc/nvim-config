-- lua/plugins/base_16.lua

vim.pack.add({
	{ src = "https://github.com/RRethy/base16-nvim" },
}, { load = function() end })

-- Kept eager so it is on 'runtimepath' before any colorscheme call.
-- `moonfly` below has a higher priority and is the one actually applied.
return {
	{ "base16-nvim", lazy = false, priority = 90 },
}
