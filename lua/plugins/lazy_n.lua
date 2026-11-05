-- Bootstrap lz.n. This is the only package `vim.pack.add` loads eagerly:
-- `require("lz.n")` below only works once it is on 'runtimepath'.
vim.pack.add({
	{ src = "https://github.com/lumen-oss/lz.n.git" },
})

-- The module is imported by `require("lz.n").load("plugins")`. Listing it
-- here keeps it in the spec so lz.n loads it first (highest priority).
return {
	{ "lz.n", lazy = false, priority = 1000 },
}
