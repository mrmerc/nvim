return {
	"hrsh7th/nvim-cmp",
	enabled = false,
	event = { "InsertEnter", "CmdlineEnter" },
	dependencies = {
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		{
			"L3MON4D3/LuaSnip",
			version = "v2.*",
			build = "make install_jsregexp",
		},
		"saadparwaiz1/cmp_luasnip", -- for autocompletion
		"rafamadriz/friendly-snippets", -- useful snippets
		"onsails/lspkind.nvim", -- vs-code like pictograms
	},
	config = function()
		vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })

		local cmp = require("cmp")

		local luasnip = require("luasnip")

		local lspkind = require("lspkind")

		-- loads vscode style snippets from installed plugins (e.g. friendly-snippets)
		require("luasnip.loaders.from_vscode").lazy_load()

		-- For Vue props/events
		local function is_in_start_tag()
			local ts_utils = require("nvim-treesitter.ts_utils")
			local node = ts_utils.get_node_at_cursor()
			if not node then
				return false
			end
			local node_to_check = { "start_tag", "self_closing_tag", "directive_attribute" }
			return vim.tbl_contains(node_to_check, node:type())
		end

		local vue_props_events_filter = function(entry, ctx)
			-- Check if the buffer type is 'vue'
			if ctx.filetype ~= "vue" then
				return true
			end

			-- Use a buffer-local variable to cache the result of the Treesitter check
			local bufnr = ctx.bufnr
			local cached_is_in_start_tag = vim.b[bufnr]._vue_ts_cached_is_in_start_tag

			if cached_is_in_start_tag == nil then
				vim.b[bufnr]._vue_ts_cached_is_in_start_tag = is_in_start_tag()
			end
			-- If not in start tag, return true
			if vim.b[bufnr]._vue_ts_cached_is_in_start_tag == false then
				return true
			end

			local cursor_before_line = ctx.cursor_before_line
			-- For events
			if cursor_before_line:sub(-1) == "@" then
				return entry.completion_item.label:match("^@")
				-- For props also exclude events with `:on-` prefix
			elseif cursor_before_line:sub(-1) == ":" then
				return entry.completion_item.label:match("^:") and not entry.completion_item.label:match("^:on%-")
			else
				return true
			end
		end

		local key_mapping = {
			["<C-k>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "s", "c" }),
			["<C-j>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "s", "c" }),
			["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "s", "c" }),
			["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "s", "c" }),
			["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "s", "c" }),
			["<C-x>"] = cmp.mapping(cmp.mapping.abort(), { "i", "s", "c" }),
			["<CR>"] = cmp.mapping(cmp.mapping.confirm({ select = false }), { "i", "s", "c" }),
		}

		cmp.setup({
			completion = {
				completeopt = "menu,menuone,preview",
				keyword_length = 0,
			},
			window = {
				completion = cmp.config.window.bordered(),
				documentation = cmp.config.window.bordered(),
			},
			view = {
				entries = { name = "custom", selection_order = "near_cursor" },
			},
			snippet = { -- configure how nvim-cmp interacts with snippet engine
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			experimental = {
				-- only show ghost text when we show ai completions
				-- ghost_text = {
				-- 	hl_group = "CmpGhostText",
				-- },
				ghost_text = false,
			},
			mapping = cmp.mapping.preset.insert(key_mapping),
			-- sources for autocompletion
			sources = cmp.config.sources({
				-- { name = "codeium" },
				{
					name = "nvim_lsp",
					entry_filter = vue_props_events_filter,
				},
				{ name = "luasnip" }, -- snippets
				{ name = "buffer" }, -- text within current buffer
				{ name = "path" }, -- file system paths
			}),
			-- configure lspkind for vs-code like pictograms in completion menu
			formatting = {
				fields = { "kind", "abbr", "menu" },
				format = lspkind.cmp_format({
					mode = "symbol_text",
					maxwidth = 60,
					ellipsis_char = "...",
					show_labelDetails = true,
					symbol_map = { Codeium = "" },
				}),
			},
		})

		cmp.setup.cmdline({ "/", "?" }, {
			completion = {
				completeopt = "menu,menuone,noselect",
			},
			mapping = key_mapping,
			sources = {
				{ name = "buffer" },
			},
		})

		cmp.setup.cmdline(":", {
			completion = {
				completeopt = "menu,menuone,noselect",
			},
			mapping = key_mapping,
			sources = cmp.config.sources({
				{ name = "cmdline" },
				{ name = "path" },
			}),
			matching = { disallow_symbol_nonprefix_matching = false },
		})

		cmp.event:on("menu_closed", function()
			local bufnr = vim.api.nvim_get_current_buf()
			vim.b[bufnr]._vue_ts_cached_is_in_start_tag = nil
		end)
	end,
}
