vim.g.mapleader = " "

local map = vim.keymap.set

-- Highlihhts
map({ "n", "i" }, "<ESC>", "<cmd>nohl<CR><ESC>", { desc = "Clear search highlights" })

-- Save buffer
map({ "n", "v" }, "<C-s>", ":silent wa<CR>", { desc = "Save all buffers", silent = true })
map("i", "<C-s>", "<ESC>:silent wa<CR>", { desc = "Save all buffers", silent = true })

-- Toggle
map("n", "<leader>tr", "<cmd>set rnu!<CR>", { desc = "Toggle relative number" })

-- Up/Down for wrapped lines
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

-- Searching
map("n", "n", "'Nn'[v:searchforward].'zzzv'", { expr = true, desc = "Next Search Result" })
map("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
map("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
map("n", "N", "'nN'[v:searchforward].'zzzv'", { expr = true, desc = "Prev Search Result" })
map("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })
map("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })

-- void
map({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete (void)" })
map("x", "<leader>p", [["_dP]], { desc = "Paste (void)" })

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

-- Resize window using <shift> arrow keys
map("n", "<S-Up>", "<cmd>resize +2<CR>", { desc = "Window horizontal size up" })
map("n", "<S-Down>", "<cmd>resize -2<CR>", { desc = "Window horizontal size down" })
map("n", "<S-Left>", "<cmd>vertical resize -2<CR>", { desc = "Window vertical size up" })
map("n", "<S-Right>", "<cmd>vertical resize +2<CR>", { desc = "Window vertical size up" })

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
map("n", "<leader>qb", "<cmd>%bd|e#<CR>", { desc = "Quit all buffers except last" })
