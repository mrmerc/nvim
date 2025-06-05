-- TODO: https://github.com/sveltejs/language-tools/tree/master/packages/language-server
---@type vim.lsp.Config
return {
	cmd = { "svelteserver", "--stdio" },
	filetypes = { "svelte" },
	root_markers = { "package.json", ".git" },
}
