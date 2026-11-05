-- lua/plugins/neotest.lua

vim.pack.add({
	{ src = "https://github.com/nvim-neotest/neotest" },
	{ src = "https://github.com/nvim-neotest/nvim-nio" },
	-- Recommended by the neotest README: detaches CursorHold polling
	-- from 'updatetime'
	{ src = "https://github.com/antoinemadec/FixCursorHold.nvim" },

	-- Adapters — uncomment what you actually use
	-- { src = 'https://github.com/nvim-neotest/neotest-plenary' },
	-- { src = 'https://github.com/nvim-neotest/neotest-python' },
	-- { src = 'https://github.com/akinsho/neotest-go' },
	-- { src = 'https://github.com/rouge8/neotest-rust' },
	-- { src = 'https://github.com/haydenmeade/neotest-jest' },
	-- { src = 'https://github.com/marilari88/neotest-vitest' },
}, { load = function() end })

return {
	-- Only affects CursorHold handling, so it can wait until after startup.
	{ "FixCursorHold.nvim", event = "DeferredUIEnter" },

	-- neotest's Lua API depends on nvim-nio.
	{ "nvim-nio", lazy = true },

	{
		"neotest",
		lazy = true,
		cmd = "Neotest",
		before = function()
			require("lz.n").trigger_load("nvim-nio")
		end,
		after = function()
			require("neotest").setup({
				adapters = {
					-- require('neotest-plenary'),
					-- require('neotest-python')({ dap = { justMyCode = false } }),
					-- require('neotest-go'),
					-- require('neotest-rust'),
				},
			})
		end,
	},
}
