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
		local lspconfig = require("lspconfig")
		local mason_lspconfig = require("mason-lspconfig")

		local augroup = vim.api.nvim_create_augroup("UserLspConfig", {})

		-- TODO: For nvim 0.11
		-- vim.api.nvim_create_autocmd("LspNotify", {
		-- 	group = augroup,
		-- 	callback = function(args)
		-- 		if args.data.method == "textDocument/didOpen" then
		-- 			vim.lsp.foldclose("imports", vim.fn.bufwinid(args.buf))
		-- 		end
		-- 	end,
		-- })

		-- TODO: For nvim 0.11
		-- vim.api.nvim_create_autocommand("LspAttach", {
		-- 	group = augroup,
		-- 	callback = function(args)
		-- 		local client = vim.lsp.get_client_by_id(args.data.client_id)
		-- 		if not client then
		-- 			vim.notify(
		-- 				string.format("Unable to get client by id: %s", args.data.client_id),
		-- 				vim.log.levels.ERROR
		-- 			)
		-- 			return
		-- 		end
		--
		-- 		if client:supports_method("textDocument/foldingRange") then
		-- 			vim.wo.foldexpr = "v:lua.vim.lsp.foldexpr()"
		-- 		end
		-- 	end,
		-- })

		vim.api.nvim_create_autocmd("LspAttach", {
			group = augroup,
			callback = function(args)
				local opts = { buffer = args.buf, silent = true } -- Buffer local mappings.

				local map = vim.keymap.set

				opts.desc = "Show LSP references"
				map("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)

				opts.desc = "Go to declaration"
				map("n", "gD", vim.lsp.buf.declaration, opts)

				opts.desc = "Show LSP definitions"
				map("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)

				opts.desc = "Show LSP implementations"
				map("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

				opts.desc = "Show LSP type definitions"
				map("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

				opts.desc = "See available code actions"
				map({ "n", "v" }, "<leader>la", vim.lsp.buf.code_action, opts)

				opts.desc = "Smart rename"
				map("n", "<leader>lrn", vim.lsp.buf.rename, opts)

				opts.desc = "Show buffer diagnostics"
				map("n", "<leader>lD", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

				opts.desc = "Show line diagnostics"
				map("n", "<leader>ld", vim.diagnostic.open_float, opts)

				opts.desc = "Go to previous diagnostic"
				map("n", "[d", vim.diagnostic.goto_prev, opts)

				opts.desc = "Go to next diagnostic"
				map("n", "]d", vim.diagnostic.goto_next, opts)

				opts.desc = "Show documentation for what is under cursor"
				map("n", "K", vim.lsp.buf.hover, opts)

				opts.desc = "Restart LSP"
				map("n", "<leader>lrr", ":LspRestart<CR>", opts)
			end,
		})

		-- enable autocompletion (assign to every lsp server config)
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
							codelens = {
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
			["ts_ls"] = function()
				lspconfig.ts_ls.setup(with_default({
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
							-- Codelens preferences
							implementationsCodeLens = { enabled = true },
							referencesCodeLens = { enabled = true, showOnAllFunctions = true },
						},
					},
					filetypes = { "typescript", "javascript" },
				}))
			end,
			["volar"] = function()
				lspconfig.volar.setup({
					filetypes = { "vue" },
					init_options = {
						vue = {
							hybridMode = false,
						},
					},
				})
			end,
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
