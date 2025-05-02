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

local default_options = {
	codelens = {
		enabled = true,
	},
	---@type lsp.ClientCapabilities
	capabilities = {
		workspace = {
			fileOperations = {
				didRename = true,
				willRename = true,
			},
		},
	},
}

local default_capabilities = vim.tbl_deep_extend(
	"force",
	{},
	vim.lsp.protocol.make_client_capabilities(),
	require("blink.cmp").get_lsp_capabilities(),
	default_options.capabilities or {}
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

		-- codelens
		if
			client:supports_method("textDocument/codeLens")
			and default_options.codelens.enabled
			and vim.lsp.codelens
		then
			vim.defer_fn(function()
				vim.lsp.codelens.refresh()
			end, 500)
		end
	end,
})

vim.api.nvim_create_autocmd("LspAttach", {
	group = lsp_group,
	callback = function(args)
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

		map({ "n", "v" }, "<leader>lc", vim.lsp.codelens.run, { desc = "Run Codelens" })
		map("n", "<leader>lC", vim.lsp.codelens.refresh, { desc = "Refresh & Display Codelens" })

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

		options.desc = "Restart LSP"
		map("n", "<leader>lrr", ":LspRestart<CR>", options)
	end,
})
