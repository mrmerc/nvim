return {
  "folke/tokyonight.nvim",
  priority = 1000,
  lazy = false,
  opts = function()
    local transparent = true -- set to true if you would like to enable transparency

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
      dim_inactive = true,
      transparent = transparent,
      styles = {
        sidebars = transparent and "transparent" or "dark",
        floats = transparent and "transparent" or "dark",
      },
      on_colors = function(colors)
        colors.bg = bg
        colors.bg_dark = transparent and colors.none or bg_dark
        colors.bg_float = transparent and colors.none or bg_dark
        colors.bg_highlight = bg_highlight
        colors.bg_popup = bg_dark
        colors.bg_search = bg_search
        colors.bg_sidebar = transparent and colors.none or bg_dark
        colors.bg_statusline = transparent and colors.none or bg_dark
        colors.bg_visual = bg_visual
        colors.border = border
        colors.fg = fg
        colors.fg_dark = fg_dark
        colors.fg_float = fg
        colors.fg_gutter = fg_gutter
        colors.fg_sidebar = fg_dark
      end,
      on_highlights = function(highlights)
        highlights.IblIndent = { fg = bg }
        highlights.IblScope = { fg = fg_scope }
        highlights.DiffAdd = {
          bg = "#112638",
        }
        highlights.DiffChange = {
          bg = "#112230",
        }
        highlights.DiffDelete = {
          bg = "#34212a",
          fg = border,
        }
        highlights.DiffText = {
          bg = "#2c4353",
        }
        highlights.Folded = {
          bg = bg,
          fg = "#20303b",
        }
        highlights.NvimTreeGitIgnored = {
          fg = fg_scope,
        }
        highlights.LazyGitFloat = {
          bg = bg_dark,
        }
        ---@diagnostic disable-next-line: param-type-mismatch
        highlights.LspInlayHint = vim.tbl_deep_extend("force", highlights.LspInlayHint, { bg = "" })
      end,
    })

    vim.cmd("colorscheme tokyonight")
  end,
}
