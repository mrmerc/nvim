local M = {}

local icons = require("custom.icons")

local hl_normal = vim.api.nvim_get_hl(0, { name = "Normal" })
local hl_curslor_line = vim.api.nvim_get_hl(0, { name = "CursorLine" })
local hl_tabline_fill = vim.api.nvim_get_hl(0, { name = "TabLineFill" })
local hl_tabline_sel = vim.api.nvim_get_hl(0, { name = "TabLineSel" })
vim.api.nvim_set_hl(0, "TabLineFill", vim.tbl_extend("force", hl_tabline_fill, { bg = "none" }))
vim.api.nvim_set_hl(
	0,
	"TabLineSel",
	vim.tbl_extend("force", hl_tabline_sel, { bg = hl_curslor_line.bg, fg = hl_normal.fg })
)

local get_title = function(current_buf)
	local filename = vim.api.nvim_buf_get_name(current_buf)
	local buftype = vim.api.nvim_get_option_value("buftype", { buf = current_buf })
	local filetype = vim.api.nvim_get_option_value("filetype", { buf = current_buf })

	if buftype == "help" then
		return "help:" .. vim.fn.fnamemodify(filename, ":t:r")
	elseif buftype == "quickfix" then
		return "quickfix"
	elseif filetype == "TelescopePrompt" then
		return "Telescope"
	elseif filetype == "NvimTree" then
		return "NvimTree"
	elseif buftype == "terminal" then
		local term_title = vim.api.nvim_buf_get_var(current_buf, "term_title")
		if term_title ~= nil and term_title ~= "" then
			return term_title
		end

		local _, mtch = string.match(filename, "term:(.*):(%a+)")
		return mtch ~= nil and mtch or vim.fn.fnamemodify(vim.env.SHELL, ":t")
	elseif filename == "" then
		return "[No Name]"
	else
		return vim.fn.pathshorten(vim.fn.fnamemodify(filename, ":p:~:t"))
	end
end

local get_tab = function(tab_id)
	local hl = (vim.api.nvim_get_current_tabpage() == tab_id and "%#TabLineSel#" or "%#TabLine#")

	vim.api.nvim_tabpage_list_wins(tab_id)

	local current_window_in_tabpage = vim.api.nvim_tabpage_get_win(tab_id)
	local current_buf = vim.api.nvim_win_get_buf(current_window_in_tabpage)

	local tab_label = get_title(current_buf)

	local ok, tab_name = pcall(vim.api.nvim_tabpage_get_var, tab_id, "name")

	if ok and tab_name ~= nil and tab_name ~= "" then
		tab_label = tab_name
	end

	local tab_modified_text = vim.api.nvim_get_option_value("modified", { buf = current_buf }) == 1
			and icons.file_status.modified .. " "
		or ""

	return hl .. " " .. tab_label .. " " .. tab_modified_text
end

M.get_tabline = function()
	local line = ""

	local tabpages = vim.api.nvim_list_tabpages()

	for _, tab_id in ipairs(tabpages) do
		line = line .. get_tab(tab_id)
	end

	line = line .. "%#TabLineFill#%="

	return line
end

return M
