return {
	"NeogitOrg/neogit",
	dependencies = {
		"nvim-lua/plenary.nvim", -- required
	},
	opts = {
		-- "ascii"   is the graph the git CLI generates
		-- "unicode" is the graph like https://github.com/rbong/vim-flog
		-- "kitty"   is the graph like https://github.com/isakbm/gitgraph.nvim - use https://github.com/rbong/flog-symbols if you don't use Kitty
		graph_style = "unicode",
		-- Show message with spinning animation when a git command is running.
		process_spinner = true,
		-- Change the default way of opening neogit
		kind = "floating",
		signs = {
			-- { CLOSED, OPENED }
			item = { "", "" },
			section = { "", "" },
		},
	},
	keys = {
		{
			"<leader>gg",
			"<cmd>Neogit<CR>",
			desc = "Neogit",
		},
	},
}
