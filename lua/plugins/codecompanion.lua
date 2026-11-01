-- lua/plugins/codecompanion.lua

vim.pack.add({
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{
		src = "https://github.com/olimorris/codecompanion.nvim",
		version = vim.version.range("^19.0.0"),
	},
}, { load = false })

local M = { loaded = false }

function M.load()
	if M.loaded then
		return require("codecompanion")
	end
	M.loaded = true

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
					["web_search"] = {
						description = "Search the live web (DeepSeek Search)",
						path = "tools.deepseek_search",
					},
					["fetch_webpage"] = {
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
				window = {
					layout = "vertical",
					position = "right",
					width = 0.4,
					border = "rounded",
				},
			},
		},
	})

	return require("codecompanion")
end

return M
