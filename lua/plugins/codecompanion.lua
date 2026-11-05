-- lua/plugins/codecompanion.lua

vim.pack.add({
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{
		src = "https://github.com/olimorris/codecompanion.nvim",
		version = vim.version.range("^20.0.0"),
	},
}, { load = function() end })

return {
	{ "plenary.nvim", lazy = true },

	{
		"codecompanion.nvim",
		lazy = true,
		cmd = {
			"CodeCompanion",
		},
		before = function()
			-- codecompanion requires plenary, and the action palette uses the
			-- fzf-lua provider configured below.
			require("lz.n").trigger_load({ "plenary.nvim", "fzf-lua" })
		end,
		after = function()
			require("codecompanion").setup({
				opts = {
					log_level = "ERROR",
				},

				adapters = {
					http = {
						deepseek = function()
							return require("codecompanion.adapters").extend("deepseek", {
								env = {
									-- Resolved per request; never in vim.env, never on disk.
									api_key = "cmd:secret-tool lookup service codecompanion key deepseek",
								},
								schema = {
									-- DeepSeek V4 accepts "high" or "max".
									reasoning_effort = {
										default = "max",
									},
								},
							})
						end,
					},
					opts = {
						-- Keyring lookups can be slow on a cold unlock.
						cmd_timeout = 30000,
					},
				},

				interactions = {
					chat = {
						adapter = { name = "deepseek", model = "deepseek-v4-flash" },

						opts = {
							completion_provider = "blink",
						},

						tools = {
							opts = {
								approval_mode = "ask",
								-- DeepSeek fetch returns whole pages; cap what reaches the LLM.
								max_output_tokens = 30000,
							},

							-- DeepSeek Search/Fetch are raw JSON endpoints, so they are wrapped
							-- as client-side tools. Overriding these keys makes @{web_search}
							-- and @{fetch_webpage} resolve to them.
							["deepseek_search"] = {
								description = "Search the live web (DeepSeek Search)",
								path = "tools.deepseek_search",
							},
							["deepseek_fetch"] = {
								description = "Fetch a page as Markdown (DeepSeek Fetch)",
								path = "tools.deepseek_fetch",
							},
						},

						slash_commands = {
							-- Unrelated to DeepSeek: no markitdown binary here.
							["fetch"] = {
								opts = { adapter = "jina" },
							},
						},
					},

					inline = {
						adapter = { name = "deepseek", model = "deepseek-v4-flash" },
					},
				},

				display = {
					action_palette = {
						provider = "fzf_lua",
					},
					chat = {
						-- Expose adapter schema fields (including reasoning_effort)
						-- as an editable YAML block at the top of the chat buffer.
						show_settings = true,

						window = {
							layout = "vertical",
							position = "right",
							width = 0.4,
							border = "rounded",
						},
					},
				},
			})
		end,
	},
}
