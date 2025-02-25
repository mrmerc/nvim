return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"saghen/blink.cmp",
		"williamboman/mason-lspconfig.nvim",
		{ "antosha417/nvim-lsp-file-operations", opts = {} },
		{ "folke/lazydev.nvim", opts = {}, ft = "lua" },
	},
	opts = {
		codelens = {
			enabled = true,
		},
		-- TODO: check LazyVim
		-- capabilities = {
		-- 	workspace = {
		-- 		fileOperations = {
		-- 			didRename = true,
		-- 			willRename = true,
		-- 		},
		-- 	},
		-- },
	},
	config = function(_, opts)
		local lspconfig = require("lspconfig")
		local mason_lspconfig = require("mason-lspconfig")

		local augroup = vim.api.nvim_create_augroup("UserLspConfig", {})
		-- local codelens_group = vim.api.nvim_create_augroup("CodeLens", {})

		-- TODO: For nvim 0.11
		-- vim.api.nvim_create_autocmd("LspNotify", {
		-- 	group = augroup,
		-- 	callback = function(args)
		-- 		if args.data.method == "textDocument/didOpen" then
		-- 			vim.lsp.foldclose("imports", vim.fn.bufwinid(args.buf))
		-- 		end
		-- 	end,
		-- })

		vim.api.nvim_create_autocmd("LspAttach", {
			group = augroup,
			callback = function(args)
				local client = vim.lsp.get_client_by_id(args.data.client_id)
				if not client then
					vim.notify(
						string.format("Unable to get client by id: %s", args.data.client_id),
						vim.log.levels.ERROR
					)
					return
				end

				-- local buffer = args.buf ---@type number

				-- TODO: For nvim 0.11
				-- if client:supports_method("textDocument/foldingRange") then
				-- 	vim.wo.foldexpr = "v:lua.vim.lsp.foldexpr()"
				-- end

				-- codelens
				if client.supports_method("textDocument/codeLens") and opts.codelens.enabled and vim.lsp.codelens then
					vim.defer_fn(function()
						vim.lsp.codelens.refresh()
					end, 500)

					-- vim.api.nvim_clear_autocmds({
					-- 	buffer = buffer,
					-- 	group = codelens_group,
					-- })
					-- vim.api.nvim_create_autocmd({ "BufEnter" }, {
					-- 	group = codelens_group,
					-- 	buffer = buffer,
					-- 	callback = function()
					-- 		vim.lsp.codelens.refresh()
					-- 	end,
					-- })
				end
			end,
		})

		vim.api.nvim_create_autocmd("LspAttach", {
			group = augroup,
			callback = function(args)
				local opts = { buffer = args.buf, silent = true } -- Buffer local mappings.

				local map = vim.keymap.set

				opts.desc = "See available code actions"
				map({ "n", "v" }, "<leader>la", vim.lsp.buf.code_action, opts)

				opts.desc = "Smart rename"
				map("n", "<leader>lrn", vim.lsp.buf.rename, opts)

				opts.desc = "LSP format"
				map("n", "<leader>lf", vim.lsp.buf.format, opts)

				opts.desc = "Show line diagnostics"
				map("n", "<leader>ld", vim.diagnostic.open_float, opts)

				map({ "n", "v" }, "<leader>lc", vim.lsp.codelens.run, { desc = "Run Codelens" })
				map("n", "<leader>lC", vim.lsp.codelens.refresh, { desc = "Refresh & Display Codelens" })

				opts.desc = "Go to previous diagnostic"
				map("n", "[d", vim.diagnostic.goto_prev, opts)

				opts.desc = "Go to next diagnostic"
				map("n", "]d", vim.diagnostic.goto_next, opts)

				opts.desc = "Show documentation for what is under cursor"
				map("n", "K", vim.lsp.buf.hover, opts)

				map("n", "gK", vim.lsp.buf.signature_help, { desc = "Signature Help" })

				opts.desc = "Restart LSP"
				map("n", "<leader>lrr", ":LspRestart<CR>", opts)
			end,
		})

		-- local capabilities = require("cmp_nvim_lsp").default_capabilities()
		local capabilities = require("blink.cmp").get_lsp_capabilities()

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

		local with_default = function(config)
			return vim.tbl_extend("error", config, default_config)
		end

		mason_lspconfig.setup_handlers({
			function(server_name)
				lspconfig[server_name].setup(default_config)
			end,
			["html"] = function()
				lspconfig.html.setup(with_default({
					filetypes = { "html", "gotmpl" },
				}))
			end,
			["emmet_ls"] = function()
				lspconfig["emmet_ls"].setup(with_default({
					filetypes = { "html", "css", "scss" },
				}))
			end,
			["lua_ls"] = function()
				lspconfig["lua_ls"].setup(with_default({
					settings = {
						Lua = {
							diagnostics = {
								globals = { "vim" },
							},
							completion = {
								callSnippet = "Replace",
							},
							hint = {
								enable = true,
							},
							codeLens = {
								enable = true,
							},
							workspace = {
								library = {
									vim.fn.expand("$VIMRUNTIME/lua"),
									vim.fn.expand("$VIMRUNTIME/lua/vim/lsp"),
									vim.fn.stdpath("data") .. "/lazy/lazy.nvim/lua/lazy",
									"${3rd}/luv/library",
								},
								maxPreload = 100000,
								preloadFileSize = 10000,
							},
						},
					},
				}))
			end,
			["volar"] = function()
				lspconfig.volar.setup(with_default({
					init_options = {
						vue = {
							hybridMode = true,
						},
					},
				}))
			end,
			["vtsls"] = function()
				lspconfig.vtsls.setup(with_default({
					filetypes = { "typescript", "javascript", "vue" },
					settings = {
						complete_function_calls = true,
						vtsls = {
							enableMoveToFileCodeAction = true,
							autoUseWorkspaceTsdk = true,
							experimental = {
								maxInlayHintLength = 30,
								completion = {
									enableServerSideFuzzyMatch = true,
								},
							},
							tsserver = {
								globalPlugins = {
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
							},
						},
						typescript = {
							updateImportsOnFileMove = { enabled = "always" },
							suggest = {
								completeFunctionCalls = true,
							},
							inlayHints = {
								enumMemberValues = { enabled = true },
								functionLikeReturnTypes = { enabled = true },
								parameterNames = { enabled = "literals" },
								parameterTypes = { enabled = true },
								propertyDeclarationTypes = { enabled = true },
								variableTypes = { enabled = false },
							},
							referencesCodeLens = {
								enabled = true,
								showOnAllFunctions = true,
							},
							implementationsCodeLens = {
								enabled = true,
								showOnInterfaceMethods = true,
							},
						},
					},
				}))
			end,
			-- TODO: check later
			-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/lang/go.lua
			["gopls"] = function()
				lspconfig.gopls.setup(with_default({
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
				}))
			end,
		})
	end,
}
