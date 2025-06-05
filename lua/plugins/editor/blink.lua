return {
	"saghen/blink.cmp",
	version = "*",
	dependencies = {
		"L3MON4D3/LuaSnip",
	},
	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {
		enabled = function()
			return vim.tbl_contains({ "snacks_input" }, vim.bo.filetype)
				or (vim.bo.buftype ~= "prompt" and vim.b.completion ~= false)
		end,

		keymap = { preset = "super-tab" },

		appearance = {
			nerd_font_variant = "normal",
		},

		fuzzy = {
			sorts = { "exact", "score", "sort_text" },
		},

		snippets = {
			preset = "luasnip",
		},

		sources = {
			providers = {
				lsp = {
					transform_items = function(_, items)
						return vim.iter(items)
							:filter(
								---@param item blink.cmp.CompletionItem
								function(item)
									-- FIXME: remove if ok with text from lsp
									-- filter out text items from lsp
									-- if item.kind == require("blink.cmp.types").CompletionItemKind.Text then
									-- 	return false
									-- end

									if vim.bo.filetype ~= "vue" then
										return true
									end

									local kind = require("blink.cmp.types").CompletionItemKind
									local label = item.label

									-- filter out v-bind: and v-on: for vue files
									if
										(item.kind == kind.Field and label:match("v-bind"))
										or (item.kind == kind.Event and label:match("v-on"))
									then
										return false
									end

									return true
								end
							)
							:totable()
					end,
				},
			},
		},

		completion = {
			list = {
				max_items = 50,
				selection = {
					auto_insert = false,
				},
			},
			menu = {
				border = "rounded",
				draw = {
					treesitter = { "lsp" },
					columns = { { "kind_icon", "kind" }, { "label", "label_description", gap = 1 } },
				},
			},
			documentation = {
				auto_show = true,
				window = {
					border = "rounded",
				},
			},
		},

		signature = {
			enabled = true,
			window = {
				border = "rounded",
			},
		},
	},
}
