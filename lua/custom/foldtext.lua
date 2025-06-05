local M = {}

local non_text_hl = vim.api.nvim_get_hl(0, { name = "NonText" })
local folded_hl = vim.api.nvim_get_hl(0, { name = "Folded" })

vim.api.nvim_set_hl(0, "Folded", vim.tbl_extend("force", folded_hl, { fg = non_text_hl.fg }))

M.get_foldtext = function()
	local line_count = vim.v.foldend - vim.v.foldstart + 1
	local line = vim.fn.getline(vim.v.foldstart)

	return string.format("%s    󰡍 %s lines", line, line_count)
end

return M
