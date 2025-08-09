return {
  {
    "luisiacc/gruvbox-baby",
    lazy = false,
    priority = 1000,
    config = function()
      -- Настройки должны быть ДО colorscheme
      vim.g.gruvbox_baby_background_color = "medium" -- "medium" или "dark"
      vim.g.gruvbox_baby_transparent_mode = 1        -- прозрачный фон
      vim.g.gruvbox_baby_telescope_theme = 1         -- стиль Telescope

      -- Стили для синтаксиса
      vim.g.gruvbox_baby_function_style = "bold"
      vim.g.gruvbox_baby_keyword_style = "italic"
      vim.g.gruvbox_baby_string_style = "nocombine"
      vim.g.gruvbox_baby_variable_style = "NONE"
      vim.g.gruvbox_baby_comment_style = "italic"

      -- При желании можно переопределить цвета:
      -- local colors = require("gruvbox-baby.colors").config()
      -- vim.g.gruvbox_baby_highlights = { Normal = { fg = colors.orange, bg = "NONE" } }

      -- Применяем тему
      vim.cmd.colorscheme("gruvbox-baby")
    end,
  },

  -- Lualine с темой gruvbox-baby
  {
    "nvim-lualine/lualine.nvim",
    opts = { options = { theme = "gruvbox-baby", globalstatus = true } },
  },

  -- Для LazyVim, чтобы он знал, какая тема
  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "gruvbox-baby" },
  },
}
