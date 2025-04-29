return {
	"chrisbra/NrrwRgn",
	init = function()
		vim.g.nrrw_rgn_nomap_nr = 1
		vim.g.nrrw_rgn_nomap_Nr = 1
		vim.g.nrrw_rgn_vert = 1
		vim.g.nrrw_rgn_resize_window = "relative"
		vim.g.nrrw_topbot_leftright = "botright"
		vim.g.nrrw_custom_options = {}
		vim.g.nrrw_custom_options["filetype"] = "css"
	end,
	keys = {
		{
			"<leader>nr",
			function()
				vim.ui.select({ "css" }, { prompt = "Narrow region" }, function(choice)
					vim.b.nrrw_aucmd_create = string.format("set filetype=%s", choice)
					vim.cmd("'<,'>NR")
					vim.cmd("LspRestart")
				end)
			end,
			desc = "Narrow region",
			mode = "x",
		},
	},
}
