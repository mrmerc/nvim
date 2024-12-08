-- Add new line to the end of the file
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	group = vim.api.nvim_create_augroup("UserOnSave", {}),
	pattern = "*",
	callback = function()
		local n_lines = vim.api.nvim_buf_line_count(0)
		local last_nonblank = vim.fn.prevnonblank(n_lines)
		if last_nonblank <= n_lines then
			vim.api.nvim_buf_set_lines(0, last_nonblank, n_lines, true, { "" })
		end
	end,
})

-- Highlight yandked text
vim.api.nvim_create_autocmd({ "TextYankPost" }, {
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({ timeout = 250 })
	end,
})

-- Statusline
vim.api.nvim_create_autocmd("DiagnosticChanged", {
	callback = function()
		vim.api.nvim__redraw({
			statusline = true,
		})
	end,
})

-- Floats
vim.api.nvim_create_autocmd("WinNew", {
	pattern = "*",
	callback = function()
		local window = vim.api.nvim_win_get_config(0)

		local is_good = window.relative ~= "" and window.focusable == true
		if not is_good then
			return
		end

		vim.wo.concealcursor = "nc"
	end,
})

-- Dashboard Cursor
vim.api.nvim_create_autocmd("User", {
	pattern = "SnacksDashboardOpened",
	callback = function()
		vim.opt.guicursor:append("n:Cursor")
		vim.cmd("hi Cursor blend=100")

		vim.api.nvim_create_autocmd("User", {
			once = true,
			pattern = "SnacksDashboardClosed",
			callback = function()
				vim.opt.guicursor:remove("n:Cursor")
				vim.cmd("hi Cursor blend=0")
			end,
		})
	end,
})
