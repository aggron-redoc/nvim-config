-- lua/util/sanitize.lua
local M = {}

-- Neovim's LuaJIT does not search luarocks' tree by default.
if not package.cpath:find("lua/5.1", 1, true) then
	package.cpath = package.cpath
		.. ";/usr/local/lib/lua/5.1/?.so"
		.. ";/usr/local/lib64/lua/5.1/?.so"
		.. ";/usr/lib/lua/5.1/?.so"
		.. ";/usr/lib64/lua/5.1/?.so"
		.. ";"
		.. vim.fn.expand("~/.luarocks/lib/lua/5.1")
		.. "/?.so"
end

local utf8 = (function()
	local ok, mod = pcall(require, "lua-utf8")
	if ok and type(mod) == "table" and type(mod.clean) == "function" then
		return mod
	end
	return nil
end)()

function M.available()
	return utf8 ~= nil
end

--- Replace invalid UTF-8 byte sequences with U+FFFD.
--- Returns the input unchanged when it is already valid.
function M.str(s)
	if not utf8 or type(s) ~= "string" or s == "" then
		return s
	end
	if utf8.isvalid and utf8.isvalid(s) then
		return s
	end
	return (utf8.clean(s))
end

--- Recursively clean every string in a table. Chat payloads are deeply nested.
function M.deep(v, depth)
	depth = depth or 0
	if type(v) == "string" then
		return M.str(v)
	end
	if type(v) ~= "table" or depth > 32 then
		return v
	end
	local out = {}
	for k, val in pairs(v) do
		out[k] = M.deep(val, depth + 1)
	end
	return out
end

return M
