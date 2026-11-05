-- lua/plugins/mini.lua

vim.pack.add({
	{ src = "https://github.com/nvim-mini/mini.icons.git" },
	{ src = "https://github.com/nvim-mini/mini.comment.git" },
	{ src = "https://github.com/nvim-mini/mini.pairs.git" },
	{ src = "https://github.com/nvim-mini/mini.surround.git" },
	{ src = "https://github.com/nvim-mini/mini.move.git" },
	{ src = "https://github.com/nvim-mini/mini.ai.git" },
	{ src = "https://github.com/nvim-mini/mini.statusline.git" },
}, { load = function() end })

return {
	-- mini.icons is used by other plugins while they load, so it stays eager.
	{
		"mini.icons",
		lazy = false,
		priority = 60,
		after = function()
			require("mini.icons").setup()
			MiniIcons.mock_nvim_web_devicons()
		end,
	},

	-- These only create mappings and set options, so they can be set up right
	-- after startup but before the first keypress.
	{
		"mini.pairs",
		event = "DeferredUIEnter",
		after = function()
			require("mini.pairs").setup()
		end,
	},
	{
		"mini.comment",
		event = "DeferredUIEnter",
		after = function()
			require("mini.comment").setup()
		end,
	},
	{
		"mini.surround",
		event = "DeferredUIEnter",
		after = function()
			require("mini.surround").setup()
		end,
	},
	{
		"mini.move",
		event = "DeferredUIEnter",
		after = function()
			require("mini.move").setup()
		end,
	},
	{
		"mini.ai",
		event = "DeferredUIEnter",
		after = function()
			require("mini.ai").setup()
		end,
	},

	-- mini.statusline is the statusline itself, so it stays eager: `laststatus=3`
	-- means every window renders it from the moment the first one is drawn.
	-- Priority keeps it after mini.icons, which provides its icons.
	{
		"mini.statusline",
		lazy = false,
		priority = 55,
		after = function()
			require("mini.statusline").setup()
		end,
	},
}
