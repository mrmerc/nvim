return {
	"folke/tokyonight.nvim",
	priority = 1000,
	lazy = false,
	opts = function()
		local fg = "#CBE0F0"
		local fg_dark = "#B4D0E9"
		local fg_gutter = "#2f597d"
		local fg_scope = "#07243d"

		local bg = "#011628"
		local bg_dark = "#011423"
		local bg_highlight = fg_scope
		local bg_search = "#0A64AC"
		local bg_visual = "#082b47"
		local border = "#2a3d4d"

		require("tokyonight").setup({
			style = "night",
			transparent = true,
			styles = {
				sidebars = "transparent",
				floats = "transparent",
			},
			on_colors = function(colors)
				colors.bg = bg
				colors.bg_dark = colors.none
				colors.bg_float = colors.none
				colors.bg_highlight = bg_highlight
				colors.bg_popup = bg_dark
				colors.bg_search = bg_search
				colors.bg_sidebar = colors.none
				colors.bg_statusline = colors.none
				colors.bg_visual = bg_visual
				colors.border = border
				colors.fg = fg
				colors.fg_dark = fg_dark
				colors.fg_float = fg
				colors.fg_gutter = fg_gutter
				colors.fg_sidebar = fg_dark
			end,
			on_highlights = function(highlights)
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

				-- Syntax hl
				highlights["@variable.builtin"] = "@type.builtin"
				highlights["@variable.parameter"] = {
					bold = true,
					fg = "#a6e3f5",
				}
			end,
		})

		vim.cmd("colorscheme tokyonight")
	end,
}
