-- Download the prebuilt binary on install/update.
-- install.sh only fetches a tarball from GitHub releases via curl/wget + tar [2],
-- so no Node, no yarn, no OpenSSL legacy provider.
vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(ev)
		if ev.data.spec.name ~= "markdown-preview.nvim" then
			return
		end
		if ev.data.kind ~= "install" and ev.data.kind ~= "update" then
			return
		end

		local res = vim.system({ "./install.sh" }, { cwd = ev.data.path .. "/app" }):wait()

		if res.code ~= 0 then
			vim.notify("markdown-preview: binary download failed\n" .. (res.stderr or ""), vim.log.levels.ERROR)
		else
			vim.notify("markdown-preview: binary installed", vim.log.levels.INFO)
		end
	end,
})

-- Build the Rust fuzzy matcher on install/update.
-- Without this, blink falls back to the Lua matcher (slower) or, if the
-- prebuilt download fails, warns on every startup.
vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(ev)
		if ev.data.spec.name == "blink.cmp" and (ev.data.kind == "install" or ev.data.kind == "update") then
			vim.system({ "cargo", "build", "--release" }, { cwd = ev.data.path }):wait()
		end
	end,
})
