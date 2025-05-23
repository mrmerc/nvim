local function debounce(ms, fn)
	local timer = vim.uv.new_timer()

	if timer == nil then
		vim.print("Error: timer is nil")
		return
	end

	return function(...)
		local argv = { ... }
		timer:start(ms, 0, function()
			timer:stop()
			vim.schedule_wrap(fn)(unpack(argv))
		end)
	end
end

---@param names string[]
---@param base_path string
---@return string|nil
local function find_config(names, base_path)
	return vim.fs.find(names, { path = base_path, upward = true })[1]
end

return {
	"mfussenegger/nvim-lint",
	event = { "BufEnter" },
	init = function()
		vim.env.ESLINT_D_PPID = vim.fn.getpid()
		vim.env.ESLINT_D_MISS = "ignore"
	end,
	opts = {
		-- Events to trigger linters
		events = { "BufWritePost", "BufReadPost", "InsertLeave", "CursorHold" },
		linters_by_ft = {
			javascript = { "eslint_d", "biomejs" },
			typescript = { "eslint_d", "biomejs" },
			vue = { "eslint_d", "stylelint" },
			svelte = { "eslint_d", "stylelint" },
			css = { "stylelint", "biomejs" },
			scss = { "stylelint", "biomejs" },

			sql = { "sqlfluff" },
			json = { "jq", "biomejs" },
			yaml = { "yq" },
			-- Use the "*" filetype to run linters on all filetypes.
			-- ['*'] = { 'global linter' },
			-- Use the "_" filetype to run linters on filetypes that don't have other linters configured.
			-- ['_'] = { 'fallback linter' },
		},
		-- Extension to easily override linter options or add custom linters.
		---@type table<string,table>
		linters = {
			eslint_d = {
				-- `condition` is extension that allows you to
				-- dynamically enable/disable linters based on the context.
				condition = function(ctx)
					return find_config({ "eslint.config.js" }, ctx.filename)
				end,
			},
			stylelint = {
				condition = function(ctx)
					return find_config({ ".stylelintrc.cjs" }, ctx.filename)
				end,
			},
			biomejs = {
				condition = function(ctx)
					return find_config({ "biome.json" }, ctx.filename)
				end,
			},
		},
	},
	config = function(_, opts)
		local lint = require("lint")

		-- sqlfluff
		-- lint.linters.sqlfluff.args[3] = "--dialect=postgres"

		for name, linter in pairs(opts.linters) do
			if type(linter) == "table" and type(lint.linters[name]) == "table" then
				lint.linters[name] = vim.tbl_deep_extend("force", lint.linters[name], linter)
				if type(linter.prepend_args) == "table" then
					lint.linters[name].args = lint.linters[name].args or {}
					vim.list_extend(lint.linters[name].args, linter.prepend_args)
				end
			else
				lint.linters[name] = linter
			end
		end
		lint.linters_by_ft = opts.linters_by_ft

		local function lint_file()
			-- Use nvim-lint's logic first:
			-- * checks if linters exist for the full filetype first
			-- * otherwise will split filetype by "." and add all those linters
			-- * this differs from conform.nvim which only uses the first filetype that has a formatter
			local names = lint._resolve_linter_by_ft(vim.bo.filetype)

			-- Create a copy of the names table to avoid modifying the original.
			names = vim.list_extend({}, names)

			-- Add fallback linters.
			if #names == 0 then
				vim.list_extend(names, lint.linters_by_ft["_"] or {})
			end

			-- Add global linters.
			vim.list_extend(names, lint.linters_by_ft["*"] or {})

			local ctx = { filename = vim.api.nvim_buf_get_name(0) }
			ctx.dirname = vim.fn.fnamemodify(ctx.filename, ":h")

			-- Filter out linters that don't exist or don't match the condition.
			names = vim.tbl_filter(function(name)
				local linter = lint.linters[name]
				if not linter then
					vim.notify("Linter not found: " .. name, vim.log.levels.WARN)
				end

				return linter and not (type(linter) == "table" and linter.condition and not linter.condition(ctx))
			end, names)

			-- Run linters.
			if #names > 0 then
				lint.try_lint(names)
			end
		end

		vim.api.nvim_create_autocmd(opts.events, {
			group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
			callback = debounce(100, lint_file),
		})

		vim.keymap.set("n", "<leader>ll", function()
			lint_file()
		end, { desc = "Lint current file" })
	end,
}
