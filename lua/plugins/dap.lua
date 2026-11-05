-- lua/plugins/dap.lua

vim.pack.add({
	{ src = "https://github.com/mfussenegger/nvim-dap" },
	{ src = "https://github.com/nvim-neotest/nvim-nio" }, -- hard dep of dap-ui
	{ src = "https://github.com/rcarriga/nvim-dap-ui" },
	{ src = "https://github.com/jay-babu/mason-nvim-dap.nvim" },
}, { load = function() end })

return {
	{ "nvim-nio", lazy = true },
	{ "nvim-dap-ui", lazy = true },
	{ "mason-nvim-dap.nvim", lazy = true },

	{
		"nvim-dap",
		lazy = true,
		-- `<CMD>Dap…<CR>` mappings are backed by lz.n's command stubs.
		cmd = {
			"DapSetLogLevel",
			"DapShowLog",
			"DapContinue",
			"DapToggleBreakpoint",
			"DapClearBreakpoints",
			"DapToggleRepl",
			"DapStepOver",
			"DapStepInto",
			"DapStepOut",
			"DapPause",
			"DapTerminate",
			"DapDisconnect",
			"DapRestartFrame",
			"DapNew",
			"DapEval",
		},
		before = function()
			-- mason-nvim-dap assumes mason is already configured.
			require("lz.n").trigger_load("mason.nvim")
		end,
		after = function()
			-- Load the dependencies first; they have no `after` hooks of
			-- their own, everything is configured below.
			require("lz.n").trigger_load({ "nvim-nio", "nvim-dap-ui", "mason-nvim-dap.nvim" })

			local dap = require("dap")
			local dapui = require("dapui")

			-- dap-ui needs nvim-dap + nvim-nio present, nothing else [1]
			dapui.setup({
				icons = { expanded = "▾", collapsed = "▸", current_frame = "▷" },

				layouts = {
					{
						elements = {
							{ id = "scopes", size = 0.35 },
							{ id = "breakpoints", size = 0.20 },
							{ id = "stacks", size = 0.25 },
							{ id = "watches", size = 0.20 },
						},
						size = 40,
						position = "left",
					},
					{
						elements = {
							{ id = "repl", size = 0.6 },
							{ id = "console", size = 0.4 },
						},
						size = 0.30,
						position = "bottom",
					},
				},

				floating = {
					border = "rounded",
					mappings = { close = { "q", "<Esc>" } },
				},
			})

			-- Auto open/close the UI on session lifecycle [1]
			dap.listeners.before.attach.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.launch.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated.dapui_config = function()
				dapui.close()
			end
			dap.listeners.before.event_exited.dapui_config = function()
				dapui.close()
			end

			-- Adapter names here are dap names, NOT mason package names [2].
			-- e.g. 'python' (not 'debugpy'), 'delve' for Go, 'codelldb' for Rust/C/C++
			require("mason-nvim-dap").setup({
				ensure_installed = {
					"python",
					-- 'delve',
					-- 'codelldb',
					-- 'dap-node',      -- JS/TS
				},
				automatic_installation = false, -- default [2]
				handlers = {}, -- predefined setup for every adapter [2]
			})

			-- Breakpoint / stopped signs. Uses your base16-derived diagnostic groups,
			-- so they follow the matugen palette automatically.
			vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError" })
			vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DiagnosticWarn" })
			vim.fn.sign_define("DapLogPoint", { text = "◆", texthl = "DiagnosticInfo" })
			vim.fn.sign_define("DapBreakpointRejected", { text = "○", texthl = "DiagnosticHint" })
			vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticOk", linehl = "Visual" })
		end,
	},
}
