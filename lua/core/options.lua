vim.diagnostic.config({
	virtual_text = false,
	-- virtual_text = {
	--   prefix = "",
	--   spacing = 3,
	-- },
	update_in_insert = false,
	severity_sort = true,
	float = {
		border = "rounded",
	},
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "󰅚",
			[vim.diagnostic.severity.WARN] = "󰗖",
			[vim.diagnostic.severity.HINT] = "󰰂",
			[vim.diagnostic.severity.INFO] = "󰰅",
		},
	},
})

vim.opt.statusline = require("custom.statusline").get_statusline()

vim.opt.scrolloff = 10

vim.opt.relativenumber = true -- Show line numbers in relative format
vim.opt.number = true -- Show current line number
vim.opt.numberwidth = 1

vim.opt.signcolumn = "yes:1"

vim.opt.confirm = true -- Confirm to save changes before exiting modified buffer
vim.opt.laststatus = 3 -- global status line
vim.opt.ruler = false
vim.opt.showtabline = 1 -- show tabs only if more than one

vim.opt.cmdheight = 0
-- Reduce command line messages since we can't see them properly anyway with
vim.opt.shortmess:append("C")
vim.opt.shortmess:append("S") -- We have our own search counter
vim.opt.shortmess:append("c")
vim.opt.shortmess:append("s")

vim.opt.mouse = "a" -- Enable mouse mode
vim.opt.showmode = false -- If in Insert, Replace or Visual mode put a message on the last line.
vim.opt.updatetime = 250 -- If this many milliseconds nothing is typed the swap file will be written to disk
vim.opt.timeoutlen = 300
vim.opt.virtualedit = "block" -- Allow cursor to move where there is no text in visual block mode
vim.opt.smoothscroll = true
vim.opt.undofile = true

-- Tabs & indentation
vim.opt.tabstop = 2 -- 2 spaces for tabs
vim.opt.shiftwidth = 2 -- 2 spaces for indent width
vim.opt.expandtab = true -- expand tab to spaces
vim.opt.autoindent = true
vim.opt.smartindent = true -- Insert indents automatically
vim.opt.shiftround = true -- Round indent
vim.opt.shiftwidth = 2 -- Size of an indent

vim.opt.linebreak = true -- Wrap lines at convenient points
vim.opt.wrap = true

-- Search settings
vim.opt.ignorecase = true -- ignore case when searching
vim.opt.smartcase = true -- if you include mixed case in your search, assumes you want case-sensitive

-- Highlight current line
vim.opt.cursorline = true

-- Theme
vim.opt.termguicolors = true
vim.opt.background = "dark"
vim.opt.signcolumn = "yes"

-- Clipboard
vim.opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus" -- Sync with system clipboard

-- Split windows behaviouself
vim.opt.splitright = true -- vertical to the right
vim.opt.splitbelow = true -- horizontal to the bottom
vim.opt.splitkeep = "screen"

-- Spelling
vim.opt.spell = false
vim.opt.spelllang = { "en,ru" }

-- Fold
vim.opt.foldlevel = 99
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldtext = ""

-- Custom icons
vim.opt.fillchars = {
	foldopen = "",
	foldclose = "",
	foldsep = " ",
	diff = "╱",
	eob = " ",
}

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0

vim.g.loaded_node_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
