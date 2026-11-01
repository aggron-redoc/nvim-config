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
}, { load = true })

require("neotest").setup({
	adapters = {
		-- require('neotest-plenary'),
		-- require('neotest-python')({ dap = { justMyCode = false } }),
		-- require('neotest-go'),
		-- require('neotest-rust'),
	},
})
