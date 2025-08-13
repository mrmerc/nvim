return {
	"chrisbra/NrrwRgn",
	dependencies = { "stevearc/conform.nvim" },
	init = function()
		vim.g.nrrw_rgn_nomap_nr = 1
		vim.g.nrrw_rgn_nomap_Nr = 1
		vim.g.nrrw_rgn_vert = 1
		vim.g.nrrw_rgn_resize_window = "relative"
		vim.g.nrrw_topbot_leftright = "botright"
	end,
	keys = {
		{
			"<leader>cr",
			function()
				vim.ui.select({ "sql", "css" }, { prompt = "Narrow region" }, function(choice)
					local formatCmd = ":lua require('conform').format()"

					vim.b.nrrw_aucmd_create = string.format("set filetype=%s|%s", choice, formatCmd)
					vim.b.nrrw_aucmd_close = formatCmd
					vim.b.nrrw_aucmd_written = ":w"

					vim.cmd("'<,'>NR")
				end)
			end,
			desc = "Narrow region",
			mode = "x",
		},
	},
}
