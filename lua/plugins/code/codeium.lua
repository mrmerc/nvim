return {
  "Exafunction/codeium.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  event = "BufEnter",
  opts = {
    enable_cmp_source = false,
    virtual_text = {
      enabled = true,
      manual = true,
    },
  },
  keys = {
    {
      "<M-c>",
      function()
        print("M_C")
        require('codeium.virtual_text').complete()
      end,
      mode = "i"
    },
  }
}
