return {
  "karb94/neoscroll.nvim",
  event = "VeryLazy",
  opts = {
    stop_eof = false,
    respect_scrolloff = true,
    easing = "linear",
    pre_hook = function()
      vim.wo.cursorline = false
      vim.cmd("normal! M")
    end,
    post_hook = function()
      vim.wo.cursorline = true
    end,
  },
}
