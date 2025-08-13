return {
	"folke/tokyonight.nvim",
	priority = 1000,
	lazy = false,
	opts = function()
		-- local mColors = require("utils.colors")

		local transparent = true

		local bg = "#010f1c"
		-- local bg = "#080808"

		-- local bg_dark = mColors.colors.bg
		local bg_dark = "#0d0d0d"

		local border = "#2a3d4d"

		require("tokyonight").setup({
			style = "night",
			transparent = transparent,
			styles = {
				sidebars = "dark",
				floats = "dark",
			},
			on_colors = function(colors)
				colors.bg = transparent and colors.none or bg
				colors.bg_dark = bg_dark
				colors.bg_float = bg_dark
				colors.bg_popup = bg_dark
				colors.bg_sidebar = bg_dark
				colors.bg_statusline = colors.none
				colors.border = border
				colors.border_highlight = "#171b1f"
			end,

			on_highlights = function(highlights, colors)
				highlights.DiffAdd = {
					bg = "#112638",
				}
				highlights.DiffChange = {
					bg = "#112230",
				}
				highlights.DiffDelete = {
					bg = "#34212a",
				}
				highlights.DiffText = {
					bg = "#2c4353",
				}
				highlights.Folded = {
					bg = bg,
					fg = "#20303b",
				}
				highlights.SnacksInputBorder = {
					bg = colors.bg_float,
					fg = colors.border_highlight,
				}
				highlights.SnacksInputTitle = {
					bg = colors.bg_float,
					fg = colors.blue1,
				}
				highlights.SnacksInputNormal = {
					bg = colors.bg_float,
				}

				highlights["@variable.parameter"] = {
					italic = true,
				}
			end,
		})

		vim.cmd("colorscheme tokyonight")
	end,
}
