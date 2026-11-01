-- lua/plugins/markdown_preview.lua

vim.g.mkdp_theme = "dark"
vim.g.mkdp_auto_start = 0
vim.g.mkdp_auto_close = 1

vim.pack.add({ "https://github.com/iamcco/markdown-preview.nvim" }, { load = true })
