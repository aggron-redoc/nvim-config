-- lua/tools/deepseek_search.lua
local api = require("tools.deepseek_api")

--- One result -> a few readable lines.
local function format(r, i)
	local lines = {
		("%d. %s"):format(i, r.title or "(untitled)"),
		"   " .. (r.url or ""),
		"   " .. (r.summary or r.snippet or ""),
	}
	if r.date then
		lines[#lines + 1] = "   published: " .. r.date
	end
	if (r.authority or -1) >= 3 then
		lines[#lines + 1] = "   authoritative source"
	end
	if r.content and r.content ~= "" then
		lines[#lines + 1] = "   content: " .. r.content:sub(1, 3000)
	end
	return table.concat(lines, "\n")
end

return {
	name = "deepseek_search",
	kind = "search",
	description = "Search the live web with DeepSeek Search",

	schema = {
		type = "function",
		["function"] = {
			name = "deepseek_search",
			description = "Search the web for current information. " .. "Returns titles, URLs, summaries and dates.",
			parameters = {
				type = "object",
				properties = {
					query = {
						type = "string",
						description = "Query, 1-128 chars. Supports site:, -site:, -term, "
							.. '"exact phrase", lang:en, after:2025-01-01, before:2026-06-01',
					},
					count = { type = "integer", description = "Results, 1-50. Default 5." },
					need_content = {
						type = "boolean",
						description = "Also return page content. Costs tokens. Default false.",
					},
				},
				required = { "query" },
				additionalProperties = false,
			},
			strict = true,
		},
	},

	cmds = {
		function(_, args, opts)
			local done = vim.schedule_wrap(opts.output_cb)

			local job = api.post("/v1/tools/search", {
				query = args.query,
				count = math.min(math.max(args.count or 5, 1), 50),
				need_content = args.need_content == true,
			}, function(err, res)
				if err then
					return done({ status = "error", data = err })
				end

				local results = res.results or {}
				if #results == 0 then
					return done({ status = "success", data = "No results for: " .. args.query })
				end

				local parts = {}
				for i, r in ipairs(results) do
					parts[i] = format(r, i)
				end
				done({ status = "success", data = table.concat(parts, "\n\n") })
			end)

			if job then
				opts.register_job(job)
			end
		end,
	},

	output = {
		success = function(self, stdout, meta)
			meta.tools.chat:add_tool_output(self, { content = api.text(stdout and stdout[#stdout]) })
		end,
		error = function(self, stderr, meta)
			meta.tools.chat:add_tool_output(self, {
				content = "deepseek_search failed: " .. api.text(stderr and stderr[#stderr]),
			})
		end,
		prompt = function(self)
			return ('Search the web for "%s"?'):format(self.args.query or "")
		end,
		cmd_string = function(self)
			return ('deepseek_search("%s")'):format(self.args.query or "")
		end,
	},
}
