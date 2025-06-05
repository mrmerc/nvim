local M = {
	---@type table<vim.diagnostic.Severity, string>
	diagnostic = {
		[vim.diagnostic.severity.ERROR] = "󰅚",
		[vim.diagnostic.severity.WARN] = "󰗖",
		[vim.diagnostic.severity.HINT] = "󰰂",
		[vim.diagnostic.severity.INFO] = "󰰅",
	},
	---@type table<"modified" | "readonly" | "unnamed", string>
	file_status = {
		modified = "", -- Text to show when the file is modified.
		readonly = "󰮕", -- Text to show when the file is non-modifiable or readonly.
		unnamed = "󰘥", -- Text to show for unnamed buffers.
	},
}

return M
