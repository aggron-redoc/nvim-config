-- lua/tools/deepseek_search.lua
local api = require("tools.deepseek_api")

return {
	name = "web_search",
	kind = "search",
	description = "Search the live web with DeepSeek Search",

	schema = {
		type = "function",
		["function"] = {
			name = "web_search",
			description = "Search the web for current information. "
				.. "Returns titles, URLs, summaries and publication dates.",
			parameters = {
				type = "object",
				properties = {
					query = {
						type = "string",
						description = "Search query, 1-128 chars. Supports operators: "
							.. 'site:example.com, -site:example.com, -term, "exact phrase", '
							.. "lang:zh,en, after:2025-01-01, before:2026-06-01",
					},
					count = {
						type = "integer",
						description = "Number of results, 1-50. Default 5.",
					},
					need_content = {
						type = "boolean",
						description = "Also return full page content. Uses many more tokens. Default false.",
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
			local cb = vim.schedule_wrap(opts.output_cb)

			local job = api.post("/v1/tools/search", {
				query = args.query,
				count = math.min(math.max(args.count or 5, 1), 50),
				need_content = args.need_content == true,
			}, function(err, res)
				if err then
					return cb({ status = "error", data = err })
				end

				local results = res.results or {}
				if #results == 0 then
					return cb({ status = "success", data = "No results for: " .. args.query })
				end

				local out = {}
				for i, r in ipairs(results) do
					table.insert(
						out,
						("%d. %s\n   %s\n   %s"):format(
							i,
							r.title or "(untitled)",
							r.url or "",
							r.summary or r.snippet or ""
						)
					)
					if r.date then
						table.insert(out, "   published: " .. r.date)
					end
					if r.authority and r.authority >= 3 then
						table.insert(out, "   highly authoritative source")
					end
					if r.content and r.content ~= "" then
						table.insert(out, "   content: " .. r.content:sub(1, 4000))
					end
				end

				cb({ status = "success", data = table.concat(out, "\n\n") })
			end)

			if job then
				opts.register_job(job)
			end
		end,
	},

	output = {
		success = function(self, stdout, meta)
			return meta.tools.chat:add_tool_output(self, { content = tostring(stdout[#stdout]) })
		end,
		error = function(self, stderr, meta)
			return meta.tools.chat:add_tool_output(
				self,
				{ content = "web_search failed: " .. tostring(stderr[#stderr]) }
			)
		end,
		prompt = function(self)
			return ('Search the web for "%s"?'):format(self.args.query or "")
		end,
		cmd_string = function(self)
			return ('web_search("%s")'):format(self.args.query or "")
		end,
	},
}
