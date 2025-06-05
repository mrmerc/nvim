---@alias Terminal {buf_id: integer, win_id: integer}
---@alias TerminalList table<integer, Terminal>

local M = {}

---@type TerminalList
local terminal_list = {}

---@param buf_id integer
local get_terminal_title = function(buf_id)
	local term_title = vim.api.nvim_buf_get_var(buf_id, "term_title")
	if term_title ~= nil and term_title ~= "" then
		return term_title
	end

	return vim.api.nvim_buf_get_name(buf_id)
end

---@param buf_id integer
local set_terminal_buf_keymaps = function(buf_id)
	vim.keymap.set("t", "<C-q>", "<cmd>q<CR>", { desc = "Hide terminal", buffer = buf_id })
	vim.keymap.set("n", "q", "<cmd>q<CR>", { desc = "Hide terminal", buffer = buf_id })
	vim.keymap.set("n", "Q", "<cmd>bd<CR>", { desc = "Quit terminal", buffer = buf_id })
end

---@param buf_id integer?
---@param terminal_title string?
---@return Terminal
local create_floating_window = function(buf_id, terminal_title)
	local columns = vim.opt.columns:get()
	local lines = vim.opt.lines:get()

	local width = math.floor(columns * 0.8)
	local height = math.floor(lines * 0.8)

	local center_x = math.floor((columns - width) / 2)
	local center_y = math.floor((lines - height) / 2)

	local terminal_buffer_id = nil
	if buf_id ~= nil and vim.api.nvim_buf_is_valid(buf_id) then
		terminal_buffer_id = buf_id
	else
		terminal_buffer_id = vim.api.nvim_create_buf(false, true)
	end

	---@type vim.api.keyset.win_config
	local win_config = {
		relative = "editor",
		width = width,
		height = height,
		col = center_x,
		row = center_y,
		style = "minimal",
		border = "rounded",
		title = terminal_title or "Terminal",
		title_pos = "center",
		footer = " [q] Close | [Q] Quit ",
	}

	local terminal_window_id = vim.api.nvim_open_win(terminal_buffer_id, true, win_config)

	return { buf_id = terminal_buffer_id, win_id = terminal_window_id }
end

vim.api.nvim_create_autocmd({ "TermOpen", "BufEnter" }, {
	pattern = "*",
	callback = function(args)
		if vim.api.nvim_get_option_value("buftype", { buf = args.buf }) ~= "terminal" then
			return
		end

		set_terminal_buf_keymaps(args.buf)

		vim.cmd("startinsert")
		vim.api.nvim_set_option_value("statusline", "%=%{b:term_title}%=", { scope = "local" })
	end,
})

vim.api.nvim_create_autocmd("TermClose", {
	group = vim.api.nvim_create_augroup("merc/terminal", { clear = true }),
	callback = function(args)
		for index, terminal in pairs(terminal_list) do
			if terminal.buf_id == args.buf then
				table.remove(terminal_list, index)
			end
		end
	end,
})

---@param buf_id integer
local run_terminal = function(buf_id)
	local buftype = vim.api.nvim_get_option_value("buftype", { buf = buf_id })

	if buftype ~= "terminal" then
		vim.cmd("term")
		-- for some reason this doesn't work
		-- vim.api.nvim_open_term(buf_id, {})
		-- if need to send command to terminal
		-- local chan = vim.api.nvim_open_term(buf_id, {})
		-- vim.api.nvim_chan_send(chan, "clear\n")
	end
end

---@param buf_id integer?
---@param terminal_title string?
local create_terminal = function(buf_id, terminal_title)
	local float_payload = create_floating_window(buf_id, terminal_title)

	table.insert(terminal_list, float_payload)

	run_terminal(float_payload.buf_id)
end

---@param buf_id integer
---@param terminal_title string
local open_terminal = function(buf_id, terminal_title)
	local terminal = vim.iter(terminal_list):find(function(terminal)
		return terminal.buf_id == buf_id
	end)

	if terminal == nil then
		return
	end

	if not vim.api.nvim_win_is_valid(terminal.win_id) then
		local float_payload = create_floating_window(terminal.buf_id, terminal_title)
		terminal.win_id = float_payload.win_id
		terminal.buf_id = float_payload.buf_id

		run_terminal(terminal.buf_id)
	else
		vim.api.nvim_win_hide(terminal.win_id)
	end
end

local show_terminal_list_window = function()
	---@type table<{title: string, win_id: integer?, buf_id: integer?}>
	local select_list = {}

	for _, terminal in pairs(terminal_list) do
		table.insert(
			select_list,
			{ title = get_terminal_title(terminal.buf_id), win_id = terminal.win_id, buf_id = terminal.buf_id }
		)
	end

	table.insert(select_list, { title = "Create terminal" })

	vim.ui.select(select_list, {
		prompt = "Select or create terminal",
		format_item = function(item)
			return item.title
		end,
	}, function(selectedItem)
		if selectedItem == nil then
			return
		end

		if selectedItem.buf_id ~= nil then
			open_terminal(selectedItem.buf_id, selectedItem.title)
			return
		end

		create_terminal()
	end)
end

M.open_list_or_create_terminal = function()
	if #terminal_list > 0 then
		show_terminal_list_window()
		return
	end

	create_terminal()
end

return M
