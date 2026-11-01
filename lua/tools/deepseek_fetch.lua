-- lua/tools/deepseek_fetch.lua
local api = require("tools.deepseek_api")

return {
	name = "deepseek_fetch",
	kind = "fetch",
	description = "Fetch a web page as Markdown with DeepSeek Fetch",

	schema = {
		type = "function",
		["function"] = {
			name = "deepseek_fetch",
			description = "Retrieve one public HTTP or HTTPS page. " .. "Returns its title and Markdown content.",
			parameters = {
				type = "object",
				properties = {
					url = {
						type = "string",
						description = "Absolute URL, up to 8192 chars. No credentials allowed.",
					},
				},
				required = { "url" },
				additionalProperties = false,
			},
			strict = true,
		},
	},

	cmds = {
		function(_, args, opts)
			local done = vim.schedule_wrap(opts.output_cb)

			local job = api.post("/v1/tools/fetch", { url = args.url }, function(err, res)
				if err then
					return done({ status = "error", data = err })
				end
				if not res.content or res.content == "" then
					return done({ status = "error", data = "No content at " .. args.url })
				end
				done({
					status = "success",
					data = ("# %s\n\n%s"):format(res.title or args.url, res.content),
				})
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
				content = "deepseek_fetch failed: " .. api.text(stderr and stderr[#stderr]),
			})
		end,
		prompt = function(self)
			return ("Fetch %s?"):format(self.args.url or "")
		end,
		cmd_string = function(self)
			return ('deepseek_fetch("%s")'):format(self.args.url or "")
		end,
	},
}
