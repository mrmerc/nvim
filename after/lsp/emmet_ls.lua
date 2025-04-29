---@type vim.lsp.Config
return {
	cmd = { "emmet-ls", "--stdio" },
	filetypes = {
		"css",
		"html",
		"scss",
	},
	root_markers = { ".git" },
}
