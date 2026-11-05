-- lua/keymaps.lua

local lz = require("lz.n")

-- `lz.keymap(plugin).set` has the same signature as `vim.keymap.set`, but it
-- loads `plugin` (and runs its `after` hook) before the mapping runs.
local function lazy(plugin)
	return lz.keymap(plugin).set
end

-- `lz.keymap` does not support buffer-local mappings, so trigger manually.
local function fzf_fn(name)
	return function()
		lz.trigger_load("fzf-lua")
		require("fzf-lua")[name]()
	end
end

-- replaces selected text WITHOUT losing what has been yanked
vim.keymap.set("x", "p", [["_dP]], { desc = "Paste over selection without yanking text" })

-- Delete text without saving it to any register
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete without yanking" })

vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines without moving cursor" })

vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "move down in buffer with cursor centered" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "move up in buffer with cursor centered" })

vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result cursor centered" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result cursor centered" })

vim.keymap.set(
	"n",
	"<leader>s",
	[[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
	{ desc = "Replace word cursor is on globally" }
)
vim.keymap.set("n", "<leader>X", "<cmd>!chmod +x %<CR>", { silent = true, desc = "makes file executable" })

-- native undotree
vim.keymap.set("n", "<leader>u", function()
	vim.cmd.packadd("nvim.undotree")
	require("undotree").open()
end, { desc = "Toggle Builtin Undotree" })

vim.keymap.set("n", "<leader>M", ":map ", { desc = "Prefills map command for seeing the custom shortcuts" })
vim.keymap.set("n", "<leader>C", ":command ", { desc = "Prefills :command for seeing the custom shortcuts" })

-- conform.nvim
lazy("conform.nvim")("n", "<leader>cf", function()
	require("conform").format({
		lsp_format = "fallback",
		async = false,
		timeout_ms = 5000,
	})
end, { desc = "Format current file or range with conform" })

-- oil.nvim
local oil = lazy("oil.nvim")
oil("n", "-", function()
	require("oil").open()
end, { desc = "Open parent directory" })
oil("n", "<leader>o", function()
	require("oil").open_float()
end, { desc = "Oil (float)" })

-- fzf-lua
local fzf = lazy("fzf-lua")
fzf("n", "<leader>ff", function() require("fzf-lua").files() end, { desc = "Files" })
fzf("n", "<leader>fg", function() require("fzf-lua").git_files() end, { desc = "Git files" })
fzf("n", "<leader>fr", function() require("fzf-lua").oldfiles() end, { desc = "Recent files" })
fzf("n", "<leader>fb", function() require("fzf-lua").buffers() end, { desc = "Buffers" })
fzf("n", "<leader>/", function() require("fzf-lua").live_grep() end, { desc = "Live grep" })
fzf("n", "<leader>fw", function() require("fzf-lua").grep_cword() end, { desc = "Grep word under cursor" })
fzf("n", "<leader>fW", function() require("fzf-lua").grep_cWORD() end, { desc = "Grep WORD under cursor" })
fzf("n", "<leader>fd", function() require("fzf-lua").diagnostics_document() end, { desc = "Diagnostics (buffer)" })
fzf(
	"n",
	"<leader>fD",
	function() require("fzf-lua").diagnostics_workspace() end,
	{ desc = "Diagnostics (workspace)" }
)
fzf("n", "<leader>fh", function() require("fzf-lua").help_tags() end, { desc = "Help" })
fzf("n", "<leader>fk", function() require("fzf-lua").keymaps() end, { desc = "Keymaps" })
fzf("n", "<leader>fc", function() require("fzf-lua").commands() end, { desc = "Commands" })
fzf("n", "<leader>fs", function() require("fzf-lua").lsp_document_symbols() end, { desc = "Document symbols" })
fzf("n", "<leader>fS", function() require("fzf-lua").lsp_workspace_symbols() end, { desc = "Workspace symbols" })
fzf("n", "<leader>fl", function() require("fzf-lua").resume() end, { desc = "Resume last picker" })

-- LSP-only (guarded so they don't error without a client)
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local bmap = function(lhs, fn, desc)
			vim.keymap.set("n", lhs, fn, { buffer = ev.buf, desc = desc })
		end
		bmap("gd", fzf_fn("lsp_definitions"), "Definitions")
		bmap("gr", fzf_fn("lsp_references"), "References")
		bmap("gi", fzf_fn("lsp_implementations"), "Implementations")
		bmap("gt", fzf_fn("lsp_typedefs"), "Type definitions")
	end,
})

-- LazyGit (the commands are lz.n stubs until the plugin is loaded)
vim.keymap.set("n", "<leader>gg", "<CMD>LazyGit<CR>", { desc = "Lazygit" })
vim.keymap.set("n", "<leader>gl", "<CMD>LazyGitLog<CR>", { desc = "Lazygit log" })
vim.keymap.set("n", "<leader>gf", "<CMD>LazyGitFilterCurrentFile<CR>", { desc = "Lazygit: file history" })

-- Direnv
vim.keymap.set("n", "<leader>da", "<CMD>Direnv allow<CR>", { desc = "Direnv allow" })
vim.keymap.set("n", "<leader>dr", "<CMD>Direnv reload<CR>", { desc = "Direnv reload" })
lazy("direnv.nvim")("n", "<leader>dc", function()
	require("direnv").check()
end, { desc = "Direnv check" })

-- Dadbodui
vim.keymap.set("n", "<leader>db", "<CMD>DBUIToggle<CR>", { desc = "DB UI toggle" })
vim.keymap.set("n", "<leader>da", "<CMD>DBUIAddConnection<CR>", { desc = "DB: add connection" })
vim.keymap.set("n", "<leader>df", "<CMD>DBUIFindBuffer<CR>", { desc = "DB: find buffer" })

-- ── DAP ─────────────────────────────────────────────────────────────
vim.keymap.set("n", "<leader>dc", "<CMD>DapContinue<CR>", { desc = "Dap continue / start" })
vim.keymap.set("n", "<leader>db", "<CMD>DapToggleBreakpoint<CR>", { desc = "Dap toggle breakpoint" })
vim.keymap.set("n", "<leader>dB", "<CMD>DapSetLogPoint<CR>", { desc = "Dap log point" })
vim.keymap.set("n", "<leader>di", "<CMD>DapStepInto<CR>", { desc = "Dap step into" })
vim.keymap.set("n", "<leader>do", "<CMD>DapStepOver<CR>", { desc = "Dap step over" })
vim.keymap.set("n", "<leader>dO", "<CMD>DapStepOut<CR>", { desc = "Dap step out" })
vim.keymap.set("n", "<leader>dt", "<CMD>DapTerminate<CR>", { desc = "Dap terminate" })
vim.keymap.set("n", "<leader>dr", "<CMD>DapRestartFrame<CR>", { desc = "Dap restart frame" })
vim.keymap.set("n", "<leader>dl", "<CMD>DapRunLast<CR>", { desc = "Dap run last" })
vim.keymap.set("n", "<leader>dx", "<CMD>DapDisconnect<CR>", { desc = "Dap disconnect" })

-- Loading nvim-dap sets up dap-ui in its `after` hook.
local dap = lazy("nvim-dap")
dap("n", "<leader>du", function()
	require("dapui").toggle()
end, { desc = "Dap UI toggle" })
dap("n", "<leader>de", function()
	require("dapui").eval()
end, { desc = "Dap eval expression" })
dap("v", "<leader>de", function()
	require("dapui").eval()
end, { desc = "Dap eval selection" })

local function float(id)
	return function()
		require("dapui").float_element(id)
	end
end

dap("n", "<leader>ds", float("scopes"), { desc = "Dap float scopes" })
dap("n", "<leader>dt", float("stacks"), { desc = "Dap float stacks" })
dap("n", "<leader>dw", float("watches"), { desc = "Dap float watches" })
dap("n", "<leader>db", float("breakpoints"), { desc = "Dap float breakpoints" })
dap("n", "<leader>dr", float("repl"), { desc = "Dap float repl" })

-- ── NEOTEST ─────────────────────────────────────────────────────────
local neotest = lazy("neotest")
neotest("n", "<leader>tt", function()
	require("neotest").run.run()
end, { desc = "Test nearest" })
neotest("n", "<leader>tf", function()
	require("neotest").run.run(vim.fn.expand("%"))
end, { desc = "Test file" })
neotest("n", "<leader>tl", function()
	require("neotest").run.run_last()
end, { desc = "Test last" })
neotest("n", "<leader>td", function()
	---@diagnostic disable-next-line: missing-fields
	require("neotest").run.run({ strategy = "dap" })
end, { desc = "Debug nearest test" })
neotest("n", "<leader>ts", function()
	require("neotest").run.stop()
end, { desc = "Test stop" })
neotest("n", "<leader>ta", function()
	require("neotest").run.attach()
end, { desc = "Test attach" })
neotest("n", "<leader>to", function()
	require("neotest").output.open({ enter = true })
end, { desc = "Test output" })
neotest("n", "<leader>tO", function()
	require("neotest").output_panel.toggle()
end, { desc = "Test output panel" })
neotest("n", "<leader>tS", function()
	require("neotest").summary.toggle()
end, { desc = "Test summary" })
neotest("n", "<leader>tw", function()
	require("neotest").watch.toggle(vim.fn.expand("%"))
end, { desc = "Test watch file" })

-- ── TROUBLE ─────────────────────────────────────────────────────────
vim.keymap.set("n", "<leader>xx", "<CMD>Trouble diagnostics toggle<CR>", { desc = "Diagnostics" })
vim.keymap.set("n", "<leader>xX", "<CMD>Trouble diagnostics toggle filter.buf=0<CR>", { desc = "Buffer diagnostics" })
vim.keymap.set("n", "<leader>xs", "<CMD>Trouble symbols toggle focus=false<CR>", { desc = "Symbols" })
vim.keymap.set(
	"n",
	"<leader>xl",
	"<CMD>Trouble lsp toggle focus=false win.position=right<CR>",
	{ desc = "LSP defs/refs" }
)
vim.keymap.set("n", "<leader>xL", "<CMD>Trouble loclist toggle<CR>", { desc = "Location list" })
vim.keymap.set("n", "<leader>xQ", "<CMD>Trouble qflist toggle<CR>", { desc = "Quickfix list" })

-- ── COPILOT ─────────────────────────────────────────────────────────
-- Completion suggestions. `lazy()` loads copilot.lua and runs its `after`
-- hook (setup + auth) before the command is executed.
local copilot = lazy("copilot.lua")

copilot("n", "<leader>cp", function()
	vim.cmd("Copilot panel") -- cycle through the suggestions for this buffer
end, { desc = "Copilot: suggestion panel" })

copilot("n", "<leader>cP", function()
	vim.cmd("Copilot toggle") -- attach/detach Copilot for this buffer
end, { desc = "Copilot: toggle for buffer" })

-- ── COPILOT CHAT ────────────────────────────────────────────────────
-- CopilotChat reads the visual selection itself (`resources = 'selection'`),
-- so the same mappings work in normal and visual mode.
local chat = function(cmd)
	return function()
		lz.trigger_load("CopilotChat.nvim")
		vim.cmd(cmd)
	end
end

vim.keymap.set({ "n", "v" }, "<leader>cc", chat("CopilotChatToggle"), { desc = "CopilotChat: toggle" })
vim.keymap.set({ "n", "v" }, "<leader>ce", chat("CopilotChat Explain"), { desc = "CopilotChat: explain" })
vim.keymap.set({ "n", "v" }, "<leader>cr", chat("CopilotChat Review"), { desc = "CopilotChat: review" })
vim.keymap.set("n", "<leader>ca", chat("CopilotChatPrompts"), { desc = "CopilotChat: prompt picker" })
vim.keymap.set("n", "<leader>cs", chat("CopilotChatOpen"), { desc = "CopilotChat: open" })
vim.keymap.set("n", "<leader>cm", chat("CopilotChatModels"), { desc = "CopilotChat: model picker" })
vim.keymap.set("n", "<leader>cx", chat("CopilotChatReset"), { desc = "CopilotChat: reset" })
