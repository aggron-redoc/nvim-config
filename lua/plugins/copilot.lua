-- lua/plugins/copilot.lua
--
-- Both plugins are lazy by default: copilot.lua starts on the first insert (or
-- `:Copilot`), CopilotChat on its commands / the `<leader>c*` mappings.
-- Run `:Copilot auth` once to sign in.

vim.pack.add({
	{ src = "https://github.com/zbirenbaum/copilot.lua" },
	{ src = "https://github.com/CopilotC-Nvim/CopilotChat.nvim" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" }, -- hard dep of CopilotChat
}, { load = function() end })

return {
	-- CopilotChat calls into plenary for curl/async; nothing else needs it.
	{ "plenary.nvim", lazy = true },

	{
		"copilot.lua",
		-- The language server takes a moment to come up, so it starts on the
		-- first insert rather than on startup.
		event = "InsertEnter",
		cmd = "Copilot",
		after = function()
			require("copilot").setup({
				suggestion = {
					enabled = true,
					auto_trigger = true,
					hide_during_completion = true, -- don't fight blink.cmp
					keymap = {
						accept = "<M-l>",
						next = "<M-]>",
						prev = "<M-[>",
						dismiss = "<C-]>",
					},
				},

				panel = { enabled = true, auto_refresh = false },

				-- Suggestions are noise in some buffers.
				filetypes = {
					gitcommit = true,
					gitrebase = false,
					help = false,
					hgcommit = false,
					svn = false,
					cvs = false,
					["."] = false,
				},
			})
		end,
	},

	{
		"CopilotChat.nvim",
		cmd = {
			"CopilotChat",
			"CopilotChatOpen",
			"CopilotChatClose",
			"CopilotChatToggle",
			"CopilotChatStop",
			"CopilotChatReset",
			"CopilotChatSave",
			"CopilotChatLoad",
			"CopilotChatPrompts",
			"CopilotChatModels",
		},
		before = function()
			require("lz.n").trigger_load({ "plenary.nvim", "copilot.lua" })
		end,
		after = function()
			require("CopilotChat").setup({
				window = {
					layout = "float",
					border = "rounded",
					width = 0.8,
					height = 0.8,
					title = "Copilot Chat",
				},
				show_help = true,
				show_folds = true,
				-- `resources = 'selection'` is the default: the visual selection
				-- is picked up automatically.
			})
		end,
	},
}
