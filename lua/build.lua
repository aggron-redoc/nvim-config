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
