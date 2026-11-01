-- lua/plugins/fzf-lua.lua

vim.pack.add({ "https://github.com/ibhagwan/fzf-lua" }, { load = true })

local fzf = require("fzf-lua")

-- Open lazygit for the directory of whatever is under the fzf cursor.
-- lazygit(path) appends `-p <dir>` when given a directory; the :LazyGit*
-- commands take no arguments, so this must call the Lua function directly.
local function lazygit_at_selection(selected)
	if not selected or #selected == 0 then
		return
	end

	local entry = vim.trim(selected[1])

	-- fzf lines can be "path", "path:line:col", or prefixed with icons/markers.
	-- Take the first whitespace-free token that looks path-ish, then strip :N:N.
	local candidate = entry:match("^(%S+)") or entry
	candidate = candidate:gsub(":%d+:%d+$", ""):gsub(":%d+$", "")

	if candidate == "" then
		return
	end

	local dir = vim.fn.isdirectory(candidate) == 1 and candidate or vim.fn.fnamemodify(candidate, ":h")

	if dir == "" or vim.fn.isdirectory(dir) ~= 1 then
		dir = vim.fn.getcwd()
	end

	require("lazygit").lazygit(dir)
end

fzf.setup({
	"default-title",

	keymap = {
		builtin = {
			["<C-g>"] = lazygit_at_selection,

			["<C-f>"] = "toggle-preview",
			["<C-u>"] = "preview-page-up",
			["<C-d>"] = "preview-page-down",
			["<C-a>"] = "toggle-all",
		},
	},

	winopts = {
		height = 0.85,
		width = 0.80,
		row = 0.35,
		col = 0.50,
		border = "rounded",
		preview = {
			layout = "flex",
			vertical = "down:45%",
			horizontal = "right:50%",
			title = true,
			scrollbar = "float",
		},
	},

	files = {
		prompt = "Files❯ ",
		multiprocess = true,
		git_icons = true,
		file_icons = true,
		color_icons = true,
		fd_opts = "--color=never --type f --hidden --follow --exclude .git",
	},

	grep = {
		prompt = "Rg❯ ",
		input_prompt = "Grep For❯ ",
		git_icons = true,
		file_icons = true,
		color_icons = true,
	},

	fzf_opts = {
		["--layout"] = "reverse-list",
		["--info"] = "inline",
		["--no-scrollbar"] = true,
	},

	defaults = {
		formatter = "path.filename_first",
	},
})

-- Route vim.ui.select through fzf-lua (LSP code actions, diagnostics, etc.)
fzf.register_ui_select()
