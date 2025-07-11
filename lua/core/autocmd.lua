local userGroup = vim.api.nvim_create_augroup("UserAutoCmds", {})

-- Highlight yandked text
vim.api.nvim_create_autocmd("TextYankPost", {
	group = userGroup,
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({ priority = 250 })
	end,
})

-- Return to last cursor position
vim.api.nvim_create_autocmd("BufReadPost", {
	group = userGroup,
	callback = function()
		local mark = vim.api.nvim_buf_get_mark(0, '"')
		local lcount = vim.api.nvim_buf_line_count(0)
		if mark[1] > 0 and mark[1] <= lcount then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

-- package.json
-- vim.api.nvim_create_autocmd("BufEnter", {
-- 	pattern = "package.json",
-- 	callback = function(data)
-- 		require("custom.package-json").init(data.buf)
-- 	end,
-- })
