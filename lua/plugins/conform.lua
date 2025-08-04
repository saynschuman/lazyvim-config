return {
  "stevearc/conform.nvim",
  opts = function(_, opts)
    opts.format_on_save = function(bufnr)
      if vim.bo[bufnr].filetype == "php" then
        return false
      end
      return { timeout_ms = 500, lsp_fallback = true }
    end
  end,
  keys = {
    {
      "<leader>cp",
      function()
        require("conform").format({ async = true, lsp_fallback = true })
      end,
      desc = "Format with Prettier",
    },
  },
}
