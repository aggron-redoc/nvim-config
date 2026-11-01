-- lua/tools/deepseek_fetch.lua
local api = require("tools.deepseek_api")

return {
	name = "fetch_webpage",
	kind = "fetch",
	description = "Fetch a web page as Markdown with DeepSeek Fetch",

	schema = {
		type = "function",
		["function"] = {
			name = "fetch_webpage",
			description = "Retrieve one public HTTP/HTTPS page and return its title " .. "and Markdown content.",
			parameters = {
				type = "object",
				properties = {
					url = {
						type = "string",
						description = "Absolute HTTP or HTTPS URL, up to 8192 chars. "
							.. "Must not contain a username or password.",
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
			local cb = vim.schedule_wrap(opts.output_cb)

			local job = api.post("/v1/tools/fetch", { url = args.url }, function(err, res)
				if err then
					return cb({ status = "error", data = err })
				end

				local content = res.content or ""
				if content == "" then
					return cb({ status = "error", data = "No extractable content at " .. args.url })
				end

				cb({
					status = "success",
					data = ("# %s\n\n%s"):format(res.title or args.url, content),
				})
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
				{ content = "fetch_webpage failed: " .. tostring(stderr[#stderr]) }
			)
		end,
		prompt = function(self)
			return ("Fetch %s?"):format(self.args.url or "")
		end,
		cmd_string = function(self)
			return ('fetch_webpage("%s")'):format(self.args.url or "")
		end,
	},
}
