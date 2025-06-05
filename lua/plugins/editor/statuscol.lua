return {
  "luukvbaal/statuscol.nvim",
  opts = function()
    local builtin = require("statuscol.builtin")
    local statuscol = require("statuscol")

    statuscol.setup({
      ft_ignore = { "NvimTree" },
      relculright = true,
      segments = {
        {
          sign = {
            namespace = { "gitsigns" },
            maxwidth = 1,
            colwidth = 1,
            wrap = true,
            foldclosed = true
          },
          click = "v:lua.ScSa",
        },
        { text = { " " } },
        {
          sign = {
            namespace = { "diagnostic" },
            name = { ".*" },
            text = { ".*" },
            maxwidth = 1,
            colwidth = 2,
            auto = true,
            foldclosed = true
          },
          click = "v:lua.ScSa",
        },
        {
          text = { builtin.lnumfunc },
          click = "v:lua.ScLa",
        },
        { text = { " " } },
      },
    })
  end
}
