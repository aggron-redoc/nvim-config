vim.g.mapleader = " "

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

vim.keymap.set({ "n", "v" }, "<leader>cf", function()
	require("conform").format({
		lsp_format = "fallback",
		async = false,
		timeout_ms = 5000,
	})
end, { desc = "Format current file or range with conform" })

--oil

vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- TODO float is taking screen space in a very bad way
vim.keymap.set("n", "<leader>o", function()
	require("oil").open_float()
end, { desc = "Oil (float)" })

--fzf-lua
local fzf = require("fzf-lua")
local map = function(lhs, fn, desc)
	vim.keymap.set("n", lhs, fn, { desc = desc })
end

map("<leader>ff", fzf.files, "Files")
map("<leader>fg", fzf.git_files, "Git files")
map("<leader>fr", fzf.oldfiles, "Recent files")
map("<leader>fb", fzf.buffers, "Buffers")
map("<leader>/", fzf.live_grep, "Live grep")
map("<leader>fw", fzf.grep_cword, "Grep word under cursor")
map("<leader>fW", fzf.grep_cWORD, "Grep WORD under cursor")
map("<leader>fd", fzf.diagnostics_document, "Diagnostics (buffer)")
map("<leader>fD", fzf.diagnostics_workspace, "Diagnostics (workspace)")
map("<leader>fh", fzf.help_tags, "Help")
map("<leader>fk", fzf.keymaps, "Keymaps")
map("<leader>fc", fzf.commands, "Commands")
map("<leader>fs", fzf.lsp_document_symbols, "Document symbols")
map("<leader>fS", fzf.lsp_workspace_symbols, "Workspace symbols")
map("<leader>fl", fzf.resume, "Resume last picker")

-- LSP-only (guarded so they don't error without a client)
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local bmap = function(lhs, fn, desc)
			vim.keymap.set("n", lhs, fn, { buffer = ev.buf, desc = desc })
		end
		bmap("gd", fzf.lsp_definitions, "Definitions")
		bmap("gr", fzf.lsp_references, "References")
		bmap("gi", fzf.lsp_implementations, "Implementations")
		bmap("gt", fzf.lsp_typedefs, "Type definitions")
	end,
})

--LazyGit
vim.keymap.set("n", "<leader>gg", "<CMD>LazyGit<CR>", { desc = "Lazygit" })
vim.keymap.set("n", "<leader>gl", "<CMD>LazyGitLog<CR>", { desc = "Lazygit log" })
vim.keymap.set("n", "<leader>gf", "<CMD>LazyGitFilterCurrentFile<CR>", { desc = "Lazygit: file history" })

--Direnv
vim.keymap.set("n", "<leader>da", "<CMD>Direnv allow<CR>", { desc = "Direnv allow" })
vim.keymap.set("n", "<leader>dr", "<CMD>Direnv reload<CR>", { desc = "Direnv reload" })
vim.keymap.set("n", "<leader>dc", function()
	require("direnv").check()
end, { desc = "Direnv check" })

--Dadbodui
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

vim.keymap.set("n", "<leader>du", function()
	require("dapui").toggle()
end, { desc = "Dap UI toggle" })
vim.keymap.set("n", "<leader>de", function()
	require("dapui").eval()
end, { desc = "Dap eval expression" })
vim.keymap.set("v", "<leader>de", function()
	require("dapui").eval()
end, { desc = "Dap eval selection" })

local function float(id)
	return function()
		require("dapui").float_element(id)
	end
end

vim.keymap.set("n", "<leader>ds", float("scopes"), { desc = "Dap float scopes" })
vim.keymap.set("n", "<leader>dt", float("stacks"), { desc = "Dap float stacks" })
vim.keymap.set("n", "<leader>dw", float("watches"), { desc = "Dap float watches" })
vim.keymap.set("n", "<leader>db", float("breakpoints"), { desc = "Dap float breakpoints" })
vim.keymap.set("n", "<leader>dr", float("repl"), { desc = "Dap float repl" })

-- ── NEOTEST ─────────────────────────────────────────────────────────
vim.keymap.set("n", "<leader>tt", function()
	require("neotest").run.run()
end, { desc = "Test nearest" })
vim.keymap.set("n", "<leader>tf", function()
	require("neotest").run.run(vim.fn.expand("%"))
end, { desc = "Test file" })
vim.keymap.set("n", "<leader>tl", function()
	require("neotest").run.run_last()
end, { desc = "Test last" })
vim.keymap.set("n", "<leader>td", function()
	---@diagnostic disable-next-line: missing-fields
	require("neotest").run.run({ strategy = "dap" })
end, { desc = "Debug nearest test" })
vim.keymap.set("n", "<leader>ts", function()
	require("neotest").run.stop()
end, { desc = "Test stop" })
vim.keymap.set("n", "<leader>ta", function()
	require("neotest").run.attach()
end, { desc = "Test attach" })
vim.keymap.set("n", "<leader>to", function()
	require("neotest").output.open({ enter = true })
end, { desc = "Test output" })
vim.keymap.set("n", "<leader>tO", function()
	require("neotest").output_panel.toggle()
end, { desc = "Test output panel" })
vim.keymap.set("n", "<leader>tS", function()
	require("neotest").summary.toggle()
end, { desc = "Test summary" })
vim.keymap.set("n", "<leader>tw", function()
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

-- Code companion
-- lua/keymaps.lua

local cc = function(cmd)
	return function()
		require("plugins.codecompanion").load()
		vim.cmd(cmd)
	end
end

vim.keymap.set({ "n", "v" }, "<leader>ca", cc("CodeCompanionActions"), { desc = "CC actions" })
vim.keymap.set({ "n", "v" }, "<leader>cc", cc("CodeCompanionChat Toggle"), { desc = "CC chat toggle" })
vim.keymap.set("v", "<leader>cA", cc("'<,'>CodeCompanionChat Add"), { desc = "CC add selection" })
vim.keymap.set("n", "<leader>ci", cc("CodeCompanion"), { desc = "CC inline prompt" })
vim.keymap.set("n", "<leader>cr", cc("CodeCompanionCodeReview"), { desc = "CC code review" })
vim.keymap.set("n", "<leader>cx", cc("CodeCompanionChat Changes"), { desc = "CC changed files" })
vim.keymap.set("n", "<leader>cs", cc("CodeCompanionChat"), { desc = "CC new chat" })
