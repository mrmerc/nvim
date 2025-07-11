return {
	"saghen/blink.cmp",
	version = "1.*",
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

		sources = {
			providers = {
				lsp = {
					transform_items = function(_, items)
						if vim.bo.filetype ~= "vue" then
							return items
						end

						---@param item blink.cmp.CompletionItem
						return vim.tbl_filter(function(item)
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
						end, items)
					end,
				},
			},
		},

		completion = {
			list = {
				max_items = 20,
				selection = {
					auto_insert = false,
				},
			},
			menu = {
				draw = {
					treesitter = { "lsp" },
					columns = { { "source_name" }, { "kind_icon", "kind" }, { "label", "label_description", gap = 1 } },
				},
			},
			documentation = {
				auto_show = true,
			},
			accept = {
				auto_brackets = {
					enabled = true,
					kind_resolution = {
						enabled = true,
						blocked_filetypes = { "typescriptreact", "javascriptreact" },
					},
				},
			},
			trigger = {
				show_on_insert = true,
				show_on_backspace = true,
			},
		},

		signature = {
			enabled = true,
			window = {
				max_height = 10,
			},
		},

		cmdline = {
			keymap = {
				preset = "inherit",
			},
			completion = { menu = { auto_show = true } },
		},
	},
}
