-- Highlight yandked text
vim.api.nvim_create_autocmd("TextYankPost", {
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({ priority = 250 })
	end,
})

-- package.json
vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "package.json",
	callback = function(data)
		require("custom.package-json").init(data.buf)
	end,
})
