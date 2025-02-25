return {
	"brenoprata10/nvim-highlight-colors",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		render = "virtual",
		enable_named_colors = false,
	},
}
