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

local trigger_events = { "BufWritePost", "BufReadPost", "InsertLeave" }

return {
	"mfussenegger/nvim-lint",
	event = trigger_events,
	config = function()
		local lint = require("lint")

		vim.env.ESLINT_D_PPID = vim.fn.getpid()
		vim.env.ESLINT_D_MISS = "ignore"

		lint.linters_by_ft = {
			javascript = { "eslint_d" },
			typescript = { "eslint_d" },
			vue = { "eslint_d" },
			sql = { "sqlfluff" },
		}

		local function lint_file()
			local names = lint._resolve_linter_by_ft(vim.bo.filetype)

			-- Create a copy of the names table to avoid modifying the original.
			names = vim.list_extend({}, names)

			-- Filter out linters that don't exist or don't match the condition.
			names = vim.tbl_filter(function(name)
				local linter = lint.linters[name]

				if not linter then
					vim.notify("Linter not found: " .. name, vim.log.levels.WARN)
					return false
				end

				return true
			end, names)

			-- Run linters.
			if #names > 0 then
				lint.try_lint(names)
			end
		end

		-- sqlfluff
		-- lint.linters.sqlfluff.args[3] = "--dialect=postgres"

		vim.api.nvim_create_autocmd(trigger_events, {
			group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
			callback = debounce(100, lint_file),
		})

		vim.keymap.set("n", "<leader>ll", function()
			lint.try_lint()
		end, { desc = "Lint current file" })
	end,
}
