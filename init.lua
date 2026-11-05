require("vim._core.ui2").enable({})
require("build")
require("commands.packer")
require("commands.lint_lazydev")
require("options")

-- lz.n has to be on 'runtimepath' before its specs can be imported. Every
-- other package is only installed by `vim.pack.add(..., { load = function() end })`;
-- lz.n decides when it is actually loaded (see `:h lz.n`).
require("plugins.lazy_n")
require("lz.n").load("plugins")

require("keymaps")

local ok, matugen = pcall(require, "matugen")
if ok then
	matugen.setup()
end
