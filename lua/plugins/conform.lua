return {
  "stevearc/conform.nvim",
  init = function()
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "php",
      callback = function()
        vim.b.autoformat = false
      end,
    })
  end,
  keys = {
    {
      "<leader>cp",
      function()
        require("conform").format({ async = true, lsp_fallback = true, formatters = { "prettier" } })
      end,
      desc = "Format with Prettier",
    },
  },
}
