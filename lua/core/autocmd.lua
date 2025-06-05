-- Add new line to the end of the file
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  group = vim.api.nvim_create_augroup("UserOnSave", {}),
  pattern = "*",
  callback = function()
    local n_lines = vim.api.nvim_buf_line_count(0)
    local last_nonblank = vim.fn.prevnonblank(n_lines)
    if last_nonblank <= n_lines then
      vim.api.nvim_buf_set_lines(0, last_nonblank, n_lines, true, { "" })
    end
  end,
})

-- Highlight yandked text
vim.api.nvim_create_autocmd({ "TextYankPost" }, {
  pattern = "*",
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Dashboard
local guicursor_cache = vim.opt.guicursor
local mousescroll_cache = vim.opt.mousescroll
vim.api.nvim_create_autocmd("User", {
  pattern = "SnacksDashboardOpened",
  callback = function()
    -- vim.opt.cmdheight = 0
    vim.opt.foldenable = false
    vim.opt.laststatus = 0
    vim.opt.mousescroll = "ver:1,hor:0"
    vim.cmd([[ hi Cursor blend=100 ]])
    vim.opt.guicursor = "a:Cursor/lCursor"
  end,
})
vim.api.nvim_create_autocmd("User", {
  pattern = "SnacksDashboardClosed",
  callback = function()
    -- vim.opt.cmdheight = 1
    vim.opt.foldenable = true
    vim.opt.laststatus = 3
    vim.opt.mousescroll = mousescroll_cache
    vim.opt.guicursor = guicursor_cache
  end,
})
