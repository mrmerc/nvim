--- @see https://github.com/vuejs/language-tools/wiki/Neovim
---@type vim.lsp.Config
return {
	cmd = { "vue-language-server", "--stdio" },
	filetypes = { "vue" },
	root_markers = { "package.json" },
	on_init = function(client)
		client.handlers["tsserver/request"] = function(_, result, context)
			local clients = vim.lsp.get_clients({ bufnr = context.bufnr, name = "vtsls" })
			if #clients == 0 then
				vim.notify(
					"Could not found `vtsls` lsp client, vue_lsp would not work without it.",
					vim.log.levels.ERROR
				)
				return
			end
			local ts_client = clients[1]

			local param = unpack(result)
			local id, command, payload = unpack(param)
			ts_client:exec_cmd({
				title = "vue_request_forward", -- You can give title anything as it's used to represent a command in the UI, `:h Client:exec_cmd`
				command = "typescript.tsserverRequest",
				arguments = {
					command,
					payload,
				},
			}, { bufnr = context.bufnr }, function(_, r)
				local response = r and r.body
				-- TODO: handle error or response nil here, e.g. logging
				-- NOTE: Do NOT return if there's an error or no response, just return nil back to the vue_ls to prevent memory leak
				local response_data = { { id, response } }

				---@diagnostic disable-next-line: param-type-mismatch
				client:notify("tsserver/response", response_data)
			end)
		end
	end,
	on_attach = function(client)
		client.server_capabilities.documentFormattingProvider = false

		-- NOTE: to be fixed in https://github.com/vuejs/language-tools/issues/5542
		-- TODO: should be fixed in 3.0.5
		client.server_capabilities.semanticTokensProvider.full = true
		vim.api.nvim_set_hl(0, "@lsp.type.component", { link = "@type" })
	end,
}
