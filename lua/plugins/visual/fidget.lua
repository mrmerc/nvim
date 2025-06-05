return {
  "j-hui/fidget.nvim",
  lazy = false,
  tag = "v1.4.5",
  opts = function()
    require("fidget").setup({
      notification = {
        override_vim_notify = true,
        window = {
          winblend = 0,
          y_padding = 1,
        },
        configs = {
          default = vim.tbl_extend(
            "force",
            require("fidget.notification").default_config,
            { name = "", icon = "" }
          ),
        },
      },
      integration = {
        ["nvim-tree"] = {
          enable = false,
        },
      },
    })
  end,
}
