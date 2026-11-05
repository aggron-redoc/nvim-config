-- lua/plugins/blink.lua

vim.pack.add({
	{ src = "https://github.com/Saghen/blink.cmp", version = vim.version.range("1") },
	{ src = "https://github.com/rafamadriz/friendly-snippets" },
}, { load = function() end })

return {
	-- blink's registry scans 'runtimepath' for a directory matching
	-- 'friendly.snippets', so the snippets have to be packadd'ed first.
	{ "friendly-snippets", lazy = false, priority = 90 },

	{
		"blink.cmp",
		-- Kept eager on purpose: blink extends the default LSP capabilities
		-- during setup, and servers may attach before `InsertEnter`.
		lazy = false,
		priority = 80,
		after = function()
			require("blink.cmp").setup({
				-- 'default' doesn't map <CR>, so mini.pairs keeps working.
				keymap = { preset = "default" },

				appearance = { nerd_font_variant = "mono" },

				completion = {
					documentation = { auto_show = false, auto_show_delay_ms = 500 },
					menu = { border = "rounded" },
					ghost_text = { enabled = true },
				},

				signature = { enabled = true },

				sources = {
					default = { "lsp", "path", "snippets", "buffer" },

					per_filetype = {
						sql = { "snippets", "dadbod", "buffer" },
					},

					providers = {
						dadbod = {
							name = "Dadbod",
							module = "vim_dadbod_completion.blink",
						},
						snippets = {
							opts = {
								-- Default is already true. Stated explicitly because this is the
								-- only link between blink and friendly-snippets: blink's registry
								-- scans 'runtimepath' for a dir matching 'friendly.snippets'.
								-- Nothing else connects them — no require, no loader call.
								friendly_snippets = true,
							},
						},
					},
				},

				-- `snippets` intentionally omitted. Leaving it unset selects the built-in
				-- 'default' preset (vim.snippet), which reads friendly-snippets directly
				-- from 'runtimepath'. Setting preset = 'luasnip' would require LuaSnip.

				fuzzy = {
					implementation = "prefer_rust_with_warning",
					prebuilt_binaries = { download = true },
				},

				cmdline = { enabled = true },
			})
		end,
	},
}
