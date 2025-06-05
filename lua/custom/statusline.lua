local M = {}

local file_symbols = {
	modified = "", -- Text to show when the file is modified.
	readonly = "󰮕", -- Text to show when the file is non-modifiable or readonly.
	unnamed = "󰘥", -- Text to show for unnamed buffers.
}

local statusline = ""

local SPACING = 3

local get_delimeter = function(length)
	local result = ""

	for _ = 1, length do
		result = result .. " "
	end

	return result
end

local get_filetype_icon = function()
	local icon, icon_highlight_group
	local ok, devicons = pcall(require, "nvim-web-devicons")

	if not ok then
		vim.notify("nvim-web-devicons is not found!", vim.log.levels.ERROR)
		return ""
	end

	icon, icon_highlight_group = devicons.get_icon(vim.fn.expand("%:t"))
	if icon == nil then
		icon, icon_highlight_group = devicons.get_icon_by_filetype(vim.bo.filetype)
	end

	if icon == nil and icon_highlight_group == nil then
		icon = ""
		icon_highlight_group = "DevIconDefault"
	end

	-- Colored icon
	-- icon = "%#" .. icon_highlight_group .. "#" .. icon .. "%* "
	icon = icon .. " "

	return icon
end

M.get_diagnostics = function()
	local result = ""

	if not vim.diagnostic.is_enabled() then
		return result
	end

	--- @type table<vim.diagnostic.Severity, number>
	local current_diagnostics = vim.diagnostic.count(0)
	local signs = vim.diagnostic.config().signs.text

	if not signs then
		signs = {
			[vim.diagnostic.severity.ERROR] = "E",
			[vim.diagnostic.severity.WARN] = "W",
			[vim.diagnostic.severity.INFO] = "I",
			[vim.diagnostic.severity.HINT] = "H",
		}
	end

	local diagnostics = {}
	for severity, count in pairs(current_diagnostics) do
		local severity_name = string.lower(vim.diagnostic.severity[severity])
		local hl = "%#DiagnosticSign" .. (severity_name:gsub("^%l", string.upper)) .. "#"

		table.insert(diagnostics, hl .. signs[severity] .. " " .. count .. "%*")
	end

	result = table.concat(diagnostics, " ")

	return result .. get_delimeter(SPACING)
end

M.get_filename_with_icon = function()
	local tail = vim.fn.expand("%:t")

	local symbols = {}

	if tail == "" then
		tail = "No name"
		table.insert(symbols, file_symbols.unnamed)
	end

	if vim.bo.modified then
		table.insert(symbols, file_symbols.modified)
	end

	if vim.bo.modifiable == false or vim.bo.readonly == true then
		table.insert(symbols, file_symbols.readonly)
	end

	local file_name = tail .. (#symbols > 0 and " " .. table.concat(symbols, " ") or "")

	return get_filetype_icon() .. file_name
end

M.get_search = function()
	if vim.v.hlsearch ~= 1 then
		return ""
	end

	local ok, searchcount = pcall(vim.fn.searchcount)

	if not ok or searchcount["total"] == 0 then
		return ""
	end

	return get_delimeter(3) .. "⚲ " .. searchcount["current"] .. "∕" .. searchcount["total"]
end

M.get_macro = function()
	local recording_register = vim.fn.reg_recording()

	if recording_register == "" then
		return ""
	end

	return get_delimeter(SPACING) .. "Rec @" .. recording_register
end

M.get_codeium = function()
	local ok, codeium = pcall(require, "codeium.virtual_text")

	if not ok then
		vim.notify("codeium.virtual_text is not found!", vim.log.levels.ERROR)
		return ""
	end

	codeium.set_statusbar_refresh(function()
		vim.api.nvim__redraw({
			statusline = true,
		})
	end)

	local status = codeium.status()

	if status.state == "idle" then
		-- Output was cleared, for example when leaving insert mode
		return ""
	end

	local base_text = get_delimeter(SPACING) .. "Codeium: "

	if status.state == "waiting" then
		-- Waiting for response
		return base_text .. "waiting..."
	end

	if status.state == "completions" and status.total > 0 then
		return base_text .. string.format("%d∕%d", status.current, status.total)
	end

	return base_text .. "0"
end

M.get_statusline = function()
	statusline = statusline .. "%="

	-- Diagnostics
	statusline = statusline .. "%{%v:lua.require('custom.statusline').get_diagnostics()%}"

	-- Filename
	statusline = statusline .. "%{%v:lua.require('custom.statusline').get_filename_with_icon()%}"

	-- Extra info
	statusline = statusline .. "%#Comment#"
	statusline = statusline .. "%{v:lua.require('custom.statusline').get_search()}"
	statusline = statusline .. "%{v:lua.require('custom.statusline').get_macro()}"
	statusline = statusline .. "%{v:lua.require('custom.statusline').get_codeium()}"
	statusline = statusline .. "%*"
	statusline = statusline .. "%="

	return statusline
end

return M
