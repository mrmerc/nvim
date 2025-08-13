---@type vim.lsp.Config
return {
	cmd = { "vtsls", "--stdio" },
	filetypes = {
		"javascript",
		"javascriptreact",
		"javascript.jsx",
		"typescript",
		"typescriptreact",
		"typescript.tsx",
		"vue",
	},
	root_markers = { "tsconfig.json", "package.json", "jsconfig.json", ".git" },
	settings = {
		vtsls = {
			enableMoveToFileCodeAction = true,
			autoUseWorkspaceTsdk = true,
			experimental = {
				completion = {
					enableServerSideFuzzyMatch = true,
					entriesLimit = 20,
				},
			},
			tsserver = {
				useSyntaxServer = "always",
				globalPlugins = {
					{
						name = "@vue/typescript-plugin",
						location = vim.fn.expand(
							"$MASON/packages/vue-language-server/node_modules/@vue/language-server"
						),
						languages = { "vue" },
						configNamespace = "typescript",
						enableForWorkspaceTypeScriptVersions = true,
					},
					-- {
					-- 	name = "typescript-svelte-plugin",
					-- 	location = vim.fn.expand(
					-- 		"$MASON/packages/svelte-language-server/node_modules/typescript-svelte-plugin"
					-- 	),
					-- 	enableForWorkspaceTypeScriptVersions = true,
					-- },
				},
			},
		},
		typescript = {
			disableAutomaticTypeAcquisition = true,
			updateImportsOnFileMove = { enabled = "always" },
			preferences = {
				preferTypeOnlyAutoImports = true,
				importModuleSpecifier = "non-relative",
			},
		},
	},
}
