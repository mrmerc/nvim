---@param exclude string[] | nil
---@return nil
local function enable_lsp(exclude)
	local path = vim.fn.stdpath("config") .. "/after/lsp"
	local lsp_list = vim.fn.glob(path .. "/*", false, true)

	for _, lsp_path in ipairs(lsp_list) do
		local lsp_name = vim.fn.fnamemodify(lsp_path, ":t:r")

		if exclude and vim.tbl_contains(exclude, lsp_name) then
			goto continue
		end

		vim.lsp.enable(lsp_name)

		::continue::
	end
end

---@type string[]
local second_lsps = {
	"volar",
	"svelte",
}

---@param client_id integer
---@return boolean
local is_second_lsp = function(client_id)
	local client = vim.lsp.get_client_by_id(client_id)

	if client and vim.tbl_contains(second_lsps, client.name) then
		return true
	end

	return false
end

local default_capabilities = vim.tbl_deep_extend(
	"force",
	{},
	vim.lsp.protocol.make_client_capabilities(),
	require("blink.cmp").get_lsp_capabilities(),
	{
		--- @type lsp.WorkspaceClientCapabilities
		workspace = {
			fileOperations = {
				didRename = true,
				willRename = true,
			},
		},
	}
)

vim.lsp.config("*", {
	capabilities = default_capabilities,
})

enable_lsp()

local lsp_group = vim.api.nvim_create_augroup("UserLspConfig", {})

-- autofold imports
vim.api.nvim_create_autocmd("LspNotify", {
	group = lsp_group,
	callback = function(args)
		if is_second_lsp(args.data.client_id) then
			return
		end

		if args.data.method == "textDocument/didOpen" then
			-- do not autofold imports in Diffview tab
			local ok, tab_name = pcall(vim.api.nvim_tabpage_get_var, vim.api.nvim_get_current_tabpage(), "name")
			if ok and tab_name == "Diffview" then
				return
			end

			vim.lsp.foldclose("imports", vim.fn.bufwinid(args.buf))
		end
	end,
})

vim.api.nvim_create_autocmd("LspAttach", {
	group = lsp_group,
	callback = function(args)
		if is_second_lsp(args.data.client_id) then
			return
		end

		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if not client then
			vim.notify(string.format("Unable to get client by id: %s", args.data.client_id), vim.log.levels.ERROR)
			return
		end

		-- lsp foldexpr
		if client:supports_method("textDocument/foldingRange") then
			local win = vim.api.nvim_get_current_win()
			vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
		end
	end,
})

vim.api.nvim_create_autocmd("LspAttach", {
	group = lsp_group,
	callback = function(args)
		if is_second_lsp(args.data.client_id) then
			return
		end

		local options = { buffer = args.buf, silent = true } -- Buffer local mappings.

		local map = vim.keymap.set

		options.desc = "See available code actions"
		map({ "n", "v" }, "<leader>la", vim.lsp.buf.code_action, options)

		options.desc = "Smart rename"
		map("n", "<leader>lrn", vim.lsp.buf.rename, options)

		options.desc = "LSP format"
		map("n", "<leader>lf", vim.lsp.buf.format, options)

		options.desc = "Show line diagnostics"
		map("n", "<leader>ld", vim.diagnostic.open_float, options)

		options.desc = "Go to previous diagnostic"
		map("n", "[d", function()
			vim.diagnostic.jump({ count = -1, float = true })
		end, options)

		options.desc = "Go to next diagnostic"
		map("n", "]d", function()
			vim.diagnostic.jump({ count = 1, float = true })
		end, options)

		options.desc = "Show documentation for what is under cursor"
		map("n", "K", function()
			vim.lsp.buf.hover({ max_width = 80 })
		end, options)

		map("n", "gK", function()
			vim.lsp.buf.signature_help({ max_width = 80 })
		end, { desc = "Signature Help" })
	end,
})
