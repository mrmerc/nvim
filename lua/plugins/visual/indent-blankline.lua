return {
  "lukas-reineke/indent-blankline.nvim",
  enabled = false,
  event = { "BufReadPre", "BufNewFile" },
  main = "ibl",
  config = function()
    local ibl = require("ibl")

    ibl.setup({
      indent = { char = "▏" },
      scope = { show_start = false, show_end = false },
    })

    local hooks = require("ibl.hooks")

    hooks.register(
      hooks.type.ACTIVE,
      function(bufnr)
        return vim.api.nvim_buf_line_count(bufnr) < 5000
      end
    )

    hooks.register(
      hooks.type.VIRTUAL_TEXT,
      function(_, _, _, virt_text)
        if virt_text[1] and virt_text[1][1] == '▏' then
          virt_text[1] = { ' ', { "@ibl.whitespace.char.1" } }
        end

        return virt_text
      end
    )
  end,
}
