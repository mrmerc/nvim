return {
	"windwp/nvim-autopairs",
	event = { "InsertEnter" },
	config = function()
		-- import nvim-autopairs
		local autopairs = require("nvim-autopairs")

		local Rule = require("nvim-autopairs.rule")
		local Cond = require("nvim-autopairs.conds")

		-- configure autopairs
		autopairs.setup({
			check_ts = true, -- enable treesitter
			ts_config = {
				lua = { "string" }, -- don't add pairs in lua string treesitter nodes
				-- javascript = { "template_string" }, -- don't add pairs in javscript template_string treesitter nodes
			},
			ignored_next_char = "[%w%.]", -- will ignore alphanumeric and `.` symbol
			enable_check_bracket_line = false,
			fast_wrap = {},
		})

		autopairs.add_rules({
			-- Auto-pair <> for generics
			Rule("<", ">", {
				-- if you use nvim-ts-autotag, you may want to exclude these filetypes from this rule
				-- so that it doesn't conflict with nvim-ts-autotag
				"-html",
				"-javascriptreact",
				"-typescriptreact",
			}):with_pair(
				-- regex will make it so that it will auto-pair on
				-- `a<` but not `a <`
				-- The `:?:?` part makes it also
				-- work on Rust generics like `some_func::<T>()`
				Cond.before_regex("%a+:?:?$", 3)
			):with_move(function(opts)
				return opts.char == ">"
			end),
		})
	end,
}
