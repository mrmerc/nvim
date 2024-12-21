return {
	"saghen/blink.cmp",
	lazy = false, -- lazy loading handled internally
	version = "v0.*",
	dependencies = {
		"L3MON4D3/LuaSnip",
	},
	init = function()
		local pmenu_hl = vim.api.nvim_get_hl(0, { name = "PMenu" })
		vim.api.nvim_set_hl(0, "BlinkCmpMenuBorder", { link = "FloatBorder" })
		vim.api.nvim_set_hl(0, "PMenu", vim.tbl_extend("force", pmenu_hl, { bg = "none" }))
	end,
	opts = {
		keymap = { preset = "super-tab" },

		appearance = {
			nerd_font_variant = "normal",
		},

		sources = {
			default = { "lsp", "path", "luasnip", "buffer" },
			providers = {
				luasnip = {
					score_offset = 0,
				},
			},
		},

		completion = {
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

		snippets = {
			expand = function(snippet)
				require("luasnip").lsp_expand(snippet)
			end,
			active = function(filter)
				if filter and filter.direction then
					return require("luasnip").jumpable(filter.direction)
				end
				return require("luasnip").in_snippet()
			end,
			jump = function(direction)
				require("luasnip").jump(direction)
			end,
		},

		-- experimental signature help support
		signature = {
			enabled = true,
			window = {
				border = "rounded",
			},
		},
	},
}
