local M = {}

local statuscolumn = ""

M.get_statuscolumn = function()
	local signs = "%s"
	local folds = "%C"
	local line_number =
		"%{v:virtnum > 0 ? '' : (&nu ? (&rnu ? (v:relnum ? v:relnum : v:lnum) : v:lnum) : (&rnu ? v:relnum : ''))}"

	statuscolumn = signs .. "%=" .. folds .. "%=" .. line_number .. " "

	return statuscolumn
end

-- NvimTree set default statuscolumn
vim.api.nvim_create_autocmd("BufWinEnter", {
	pattern = "NvimTree_1",
	callback = function()
		vim.opt_local.statuscolumn = ""
	end,
})

return M
