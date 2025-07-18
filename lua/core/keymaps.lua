vim.g.mapleader = " "

local map = vim.keymap.set

-- Highlights
map("n", "<ESC>", "<cmd>nohlsearch<CR><ESC>", { desc = "Clear search highlights" })

-- Save buffer
map({ "n", "v" }, "<C-s>", ":silent wa<CR>", { desc = "Save all buffers", silent = true })
map("i", "<C-s>", "<ESC>:silent wa<CR>", { desc = "Save all buffers", silent = true })

-- Options
map("n", "<leader>or", "<cmd>set rnu!<CR>", { desc = "Toggle relative number" })

-- Better Redo
map("n", "U", "<C-r>", { desc = "Redo" })

-- Execute macro over a visual region.
vim.keymap.set("x", "@", function()
	return ":norm @" .. vim.fn.getcharstr() .. "<cr>"
end, { expr = true })

-- Up/Down for wrapped lines
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

-- Move lines up/down
map("n", "<A-j>", "<cmd>move .+1<CR>==", { desc = "Move line down" })
map("n", "<A-k>", "<cmd>move .-2<CR>==", { desc = "Move line up" })
map("v", "<A-j>", ":move '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "<A-k>", ":move '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Duplicate lines up/down
map("n", "<S-A-j>", "<cmd>copy .-1<CR>==", { desc = "Duplicate line down" })
map("n", "<S-A-k>", "<cmd>copy .<CR>==", { desc = "Duplicate line up" })
map("v", "<S-A-j>", ":copy '<-1<CR>gv=gv", { desc = "Duplicate selection down" })
map("v", "<S-A-k>", ":copy '><CR>gv=gv", { desc = "Duplicate selection up" })

-- Searching
map("n", "n", "'Nn'[v:searchforward].'zzzv'", { expr = true, desc = "Next Search Result" })
map("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
map("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
map("n", "N", "'nN'[v:searchforward].'zzzv'", { expr = true, desc = "Prev Search Result" })
map("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })
map("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })

-- void
map({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete (void)" })

-- Replace
map("n", "<leader>rr", ":%s/", { desc = "Replace (buffer)" })
map("n", "<leader>rw", ":%s/<C-r><C-w>", { desc = "Replace word under cursor (buffer)" })
map("v", "<leader>rr", ":s/", { desc = "Replace within selection" })
map("v", "<leader>rs", "y:%s/\\V<C-r>0", { desc = "Replace selected (buffer)" })

-- Better indenting
map("v", "<Tab>", ">gv")
map("v", "<S-Tab>", "<gv")
map("i", "<ESC>", "<Space><BS><ESC>", { desc = "Preserve indent on new empty line", noremap = true })

-- Add undo break-points
map("i", ",", ",<c-g>u")
map("i", ".", ".<c-g>u")
map("i", ";", ";<c-g>u")

-- Windows
map("n", "<leader>wr", "<C-w>v", { desc = "Split window vertically" })
map("n", "<leader>wb", "<C-w>s", { desc = "Split window horizontally" })
map("n", "<leader>we", "<C-w>=", { desc = "Make splits equal size" })
map("n", "<leader>wx", "<cmd>close<CR>", { desc = "Close current split" })
map("n", "<C-j>", "<C-W>j", { desc = "Move down to window" })
map("n", "<C-k>", "<C-W>k", { desc = "Move up to window" })
map("n", "<C-h>", "<C-W>h", { desc = "Move left to window" })
map("n", "<C-l>", "<C-W>l", { desc = "Move right to window" })
map("n", "<S-j>", "<cmd>resize -2<CR>", { desc = "Window horizontal size down" })
map("n", "<S-k>", "<cmd>resize +2<CR>", { desc = "Window horizontal size up" })
map("n", "<S-h>", "<cmd>vertical resize -2<CR>", { desc = "Window vertical size up" })
map("n", "<S-l>", "<cmd>vertical resize +2<CR>", { desc = "Window vertical size up" })

-- Tabs
map("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
map("n", "]<tab>", "<cmd>tabnext<cr>", { desc = "Next Tab" })
map("n", "[<tab>", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })
map("n", "<leader><tab>x", "<cmd>tabclose<cr>", { desc = "Close Tab" })
map("n", "<leader><tab>o", "<cmd>tabonly<cr>", { desc = "Close Other Tabs" })

-- Code comments
map("n", "<leader>/", "gcc", { desc = "Toggle comment", remap = true })
map("v", "<leader>/", "gc", { desc = "Toggle comment", remap = true })

-- Quit
map("n", "<leader>qq", "<cmd>qa<CR>", { desc = "Quit nvim" })
map("n", "<leader>qb", function()
	local opened_buffers = vim.api.nvim_list_bufs()
	local closed_buffers = 0

	for _, id in ipairs(opened_buffers) do
		local current_buffer = vim.api.nvim_win_get_buf(0)

		if current_buffer ~= id then
			vim.api.nvim_buf_delete(id, {})
			closed_buffers = closed_buffers + 1
		end
	end

	vim.notify(string.format("Closed %d buffers", closed_buffers))
end, { desc = "Quit all buffers except current" })
