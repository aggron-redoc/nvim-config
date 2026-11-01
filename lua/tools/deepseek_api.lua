-- lua/tools/deepseek_api.lua
local M = {}

local function key()
	local out = vim.fn.system({
		"secret-tool",
		"lookup",
		"service",
		"codecompanion",
		"key",
		"deepseek",
	})
	return vim.trim(out or "")
end

--- Collapse anything JSON can produce into a plain string.
function M.text(v)
	if v == nil or v == vim.NIL then
		return ""
	end
	if type(v) ~= "table" then
		return tostring(v)
	end
	if vim.islist(v) then
		return table.concat(vim.tbl_map(M.text, v), "\n")
	end
	return M.text(v.content or v.data or v.text or vim.inspect(v))
end

--- POST JSON to https://api.deepseek.com<endpoint>.
--- Headers go on stdin via `curl --config -`, so the key never appears in argv.
--- Calls cb(err, response_table) on the main loop.
function M.post(endpoint, body, cb)
	local k = key()
	if k == "" then
		return cb(
			'No DeepSeek key. Run: secret-tool store --label="DeepSeek API key"'
				.. " service codecompanion key deepseek"
		)
	end

	local ok, job = pcall(
		vim.system,
		{
			"curl",
			"-sS",
			"--max-time",
			"30",
			"--config",
			"-",
			"-d",
			vim.json.encode(body),
			"https://api.deepseek.com" .. endpoint,
		},
		{
			text = true,
			stdin = ('header = "Authorization: Bearer %s"\n'):format(k)
				.. 'header = "Content-Type: application/json"\n',
		},
		vim.schedule_wrap(function(out)
			if out.code ~= 0 then
				return cb(vim.trim(out.stderr) ~= "" and vim.trim(out.stderr) or ("curl exited " .. out.code))
			end

			local raw = out.stdout or ""
			-- luanil: JSON null becomes nil, not the truthy vim.NIL userdata
			local decoded_ok, res = pcall(vim.json.decode, raw, {
				luanil = { object = true, array = true },
			})
			if not decoded_ok then
				return cb("Bad JSON from DeepSeek: " .. raw:sub(1, 200))
			end
			if res.error then
				return cb(res.error.message or "DeepSeek API error")
			end

			cb(nil, res)
		end)
	)

	if not ok then
		return cb(tostring(job))
	end
	return job
end

return M
