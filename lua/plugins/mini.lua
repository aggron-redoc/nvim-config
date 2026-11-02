vim.pack.add({
	{ src = "https://github.com/nvim-mini/mini.icons.git" },
	{ src = "https://github.com/nvim-mini/mini.comment.git" },
	{ src = "https://github.com/nvim-mini/mini.pairs.git" },
	{ src = "https://github.com/nvim-mini/mini.surround.git" },
	{ src = "https://github.com/nvim-mini/mini.move.git" },
	{ src = "https://github.com/nvim-mini/mini.ai.git" },
	{ src = "https://github.com/nvim-mini/mini.statusline.git" },
})

require("mini.icons").setup()
MiniIcons.mock_nvim_web_devicons()

require("mini.pairs").setup()
require("mini.comment").setup()
require("mini.surround").setup()
require("mini.move").setup()
require("mini.ai").setup()
require("mini.statusline").setup()
