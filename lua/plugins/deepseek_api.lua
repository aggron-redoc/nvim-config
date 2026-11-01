-- lua/tools/deepseek_api.lua
local M = {}

local function api_key()
	local out = vim.fn.system({
		"secret-tool",
		"lookup",
		"service",
		"codecompanion",
		"key",
		"deepseek",
	})
	if vim.v.shell_error ~= 0 then
		return nil
	end
	local key = vim.trim(out or "")
	return key ~= "" and key or nil
end

-- Never let the key reach the LLM through an error string
local function make_scrubber(key)
	local pat = key:gsub("[%^%$%(%)%%%.%[%]%*%+%-%?]", "%%%0")
	return function(s)
		if type(s) ~= "string" then
			return s
		end
		return (s:gsub(pat, "<redacted>"))
	end
end

--- POST JSON to a DeepSeek tools endpoint.
--- The Authorization header travels on stdin via `curl --config -`,
--- so the key never appears in any process's argv.
--- @param endpoint string  e.g. '/v1/tools/search'
--- @param body table
--- @param cb fun(err: string|nil, res: table|nil)  runs on the main loop
--- @return vim.SystemObj|nil job
function M.post(endpoint, body, cb)
	local key = api_key()
	if not key then
		return cb(
			"DeepSeek key missing. Store it with:\n"
				.. "  secret-tool store --label='DeepSeek API key' service codecompanion key deepseek"
		)
	end

	local scrub = make_scrubber(key)

	local ok, job = pcall(
		vim.system,
		{
			"curl",
			"-sS",
			"--max-time",
			"30",
			"-X",
			"POST",
			"--config",
			"-",
			"-d",
			vim.json.encode(body),
			"https://api.deepseek.com" .. endpoint,
		},
		{
			text = true,
			-- curl config syntax; quotes are required
			stdin = 'header = "Authorization: Bearer ' .. key .. '"\n' .. 'header = "Content-Type: application/json"\n',
		},
		vim.schedule_wrap(function(out)
			if out.code ~= 0 then
				local stderr = vim.trim(out.stderr or "")
				if stderr == "" then
					stderr = vim.trim(out.stdout or "")
				end
				return cb(("curl exited %d: %s"):format(out.code, scrub(stderr):sub(1, 300)))
			end

			local stdout = out.stdout or ""
			local dec_ok, decoded = pcall(vim.json.decode, stdout)
			if not dec_ok then
				return cb("Bad JSON from DeepSeek: " .. scrub(stdout:sub(1, 300)))
			end
			if decoded.error then
				return cb(scrub(decoded.error.message or "DeepSeek API error"))
			end

			cb(nil, decoded)
		end)
	)

	if not ok then
		cb("Failed to spawn curl: " .. scrub(tostring(job)))
		return nil
	end
	return job
end

return M
