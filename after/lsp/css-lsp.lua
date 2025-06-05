---@type vim.lsp.Config
return {
	cmd = { "vscode-css-language-server", "--stdio" },
	filetypes = { "css", "scss" },
	root_markers = { ".git", "package.json" },
	init_options = { provideFormatter = true }, -- needed to enable formatting capabilities
	settings = {
		css = { validate = true },
		scss = { validate = true },
		less = { validate = true },
	},
}
