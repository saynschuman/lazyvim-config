return {
  {
    "olimorris/onedarkpro.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("onedarkpro").setup({
        -- Тема по умолчанию (можно выбрать: "onedark", "onelight", "onedark_vivid", "onedark_dark", "vaporwave")
        colors = {},
        highlights = {},
        styles = {
          types = "NONE",
          methods = "NONE",
          numbers = "NONE",
          strings = "NONE",
          comments = "italic",
          keywords = "bold,italic",
          constants = "NONE",
          functions = "italic",
          operators = "NONE",
          variables = "NONE",
          parameters = "NONE",
          conditionals = "italic",
          virtual_text = "NONE",
        },
        filetypes = { all = true }, -- включить все подсветки для файлов
        plugins = { all = true },   -- включить все интеграции
        options = {
          cursorline = true,        -- подсветка строки курсора
          transparency = true,      -- прозрачный фон
          terminal_colors = true,   -- цвета в встроенном терминале
          highlight_inactive_windows = true,
        },
      })

      vim.cmd("colorscheme onedark")
    end,
  },

  -- Lualine — авто тема
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      options = {
        theme = "auto",
        globalstatus = true,
      },
    },
  },

  -- Указываем LazyVim, что тема — onedark
  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "onedark" },
  },
}
