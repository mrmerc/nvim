return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"williamboman/mason-lspconfig.nvim",
		{ "antosha417/nvim-lsp-file-operations", opts = {} },
		{ "folke/lazydev.nvim", opts = {}, ft = "lua" },
	},
	config = function()
		-- print(vim.inspect(require("mason-registry").get_installed_packages()))
		-- import lspconfig plugin
		local lspconfig = require("lspconfig")

		-- import mason_lspconfig plugin
		local mason_lspconfig = require("mason-lspconfig")

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				-- Buffer local mappings.
				-- See `:help vim.lsp.*` for documentation on any of the below functions
				local opts = { buffer = ev.buf, silent = true }

				local map = vim.keymap.set
				-- set keybinds
				opts.desc = "Show LSP references"
				map("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

				opts.desc = "Go to declaration"
				map("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

				opts.desc = "Show LSP definitions"
				map("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions

				opts.desc = "Show LSP implementations"
				map("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

				opts.desc = "Show LSP type definitions"
				map("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

				opts.desc = "See available code actions"
				map({ "n", "v" }, "<leader>la", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

				opts.desc = "Smart rename"
				map("n", "<leader>lrn", vim.lsp.buf.rename, opts) -- smart rename

				opts.desc = "Show buffer diagnostics"
				map("n", "<leader>lD", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

				opts.desc = "Show line diagnostics"
				map("n", "<leader>ld", vim.diagnostic.open_float, opts) -- show diagnostics for line

				opts.desc = "Go to previous diagnostic"
				map("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

				opts.desc = "Go to next diagnostic"
				map("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

				opts.desc = "Show documentation for what is under cursor"
				map("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

				opts.desc = "Restart LSP"
				map("n", "<leader>lrr", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
			end,
		})

		-- used to enable autocompletion (assign to every lsp server config)
		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		local handlers_opts = {
			border = "rounded",
			max_width = 80,
		}

		local handlers = {
			["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, handlers_opts),
			["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, handlers_opts),
		}

		local default_config = {
			capabilities = capabilities,
			handlers = handlers,
		}

		mason_lspconfig.setup_handlers({
			-- default handler for installed servers
			function(server_name)
				lspconfig[server_name].setup(default_config)
			end,
			["html"] = function()
				lspconfig.html.setup(vim.tbl_extend("error", {
					filetypes = { "html", "gotmpl" },
				}, default_config))
			end,
			["emmet_ls"] = function()
				lspconfig["emmet_ls"].setup(vim.tbl_extend("error", {
					filetypes = { "html", "css", "scss" },
				}, default_config))
			end,
			["lua_ls"] = function()
				lspconfig["lua_ls"].setup(vim.tbl_extend("error", {
					settings = {
						Lua = {
							-- make the language server recognize "vim" global
							diagnostics = {
								globals = { "vim" },
							},
							completion = {
								callSnippet = "Replace",
							},
							hint = {
								enable = true,
							},
							codelens = {
								enable = true,
							},
						},
					},
				}, default_config))
			end,
			["ts_ls"] = function()
				lspconfig.ts_ls.setup(vim.tbl_extend("error", {
					init_options = {
						plugins = {
							{
								name = "@vue/typescript-plugin",
								location = require("mason-registry")
									.get_package("vue-language-server")
									:get_install_path() .. "/node_modules/@vue/language-server",
								languages = { "vue" },
								configNamespace = "typescript",
								enableForWorkspaceTypeScriptVersions = true,
							},
						},
						preferences = {
							-- Inlay Hints preferences
							interactiveInlayHints = true,
							includeInlayParameterNameHints = "all",
							includeInlayParameterNameHintsWhenArgumentMatchesName = true,
							includeInlayFunctionParameterTypeHints = true,
							includeInlayVariableTypeHints = true,
							includeInlayVariableTypeHintsWhenTypeMatchesName = true,
							includeInlayPropertyDeclarationTypeHints = true,
							includeInlayFunctionLikeReturnTypeHints = true,
							includeInlayEnumMemberValueHints = true,
							-- Code Lens preferences
							implementationsCodeLens = { enabled = true },
							referencesCodeLens = { enabled = true, showOnAllFunctions = true },
						},
					},
					filetypes = { "typescript", "javascript", "vue" },
				}, default_config))
			end,
			["gopls"] = function()
				lspconfig.gopls.setup(vim.tbl_extend("error", {
					settings = {
						gopls = {
							gofumpt = true,
							codelenses = {
								gc_details = false,
								generate = true,
								regenerate_cgo = true,
								run_govulncheck = true,
								test = true,
								tidy = true,
								upgrade_dependency = true,
								vendor = true,
							},
							hints = {
								rangeVariableTypes = true,
								parameterNames = true,
								constantValues = true,
								assignVariableTypes = true,
								compositeLiteralFields = true,
								compositeLiteralTypes = true,
								functionTypeParameters = true,
							},
							analyses = {
								fieldalignment = true,
								nilness = true,
								unusedparams = true,
								unusedwrite = true,
								useany = true,
							},
							usePlaceholders = true,
							completeUnimported = true,
							staticcheck = true,
							directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
							semanticTokens = true,
						},
					},
					on_attach = function(client)
						if not client.server_capabilities.semanticTokensProvider then
							local semantic = client.config.capabilities.textDocument.semanticTokens
							client.server_capabilities.semanticTokensProvider = {
								full = true,
								legend = {
									tokenTypes = semantic.tokenTypes,
									tokenModifiers = semantic.tokenModifiers,
								},
								range = true,
							}
						end
					end,
				}, default_config))
			end,
		})
	end,
}
