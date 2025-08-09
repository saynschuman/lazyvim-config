return {
  {
    "dgox16/oldworld.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("oldworld").setup({
        terminal_colors = true, -- включить терминальные цвета
        variant = "default",    -- варианты: "default", "oled", "cooler"
        styles = {
          comments = {},        -- стили для комментариев
          keywords = {},        -- стили для ключевых слов
          identifiers = {},     -- стили для идентификаторов
          functions = {},       -- стили для функций
          variables = {},       -- стили для переменных
          booleans = {},        -- стили для булевых значений
        },
        integrations = {
          alpha = true,
          cmp = true,
          flash = true,
          gitsigns = true,
          hop = false,
          indent_blankline = true,
          lazy = true,
          lsp = true,
          markdown = true,
          mason = true,
          navic = false,
          neo_tree = false,
          neogit = false,
          neorg = false,
          noice = true,
          notify = true,
          rainbow_delimiters = true,
          telescope = true,
          treesitter = true,
        },
        highlight_overrides = {},
      })

      vim.cmd.colorscheme("oldworld")
    end,
  },

  -- lualine с автоматической подстройкой под тему
  {
    "nvim-lualine/lualine.nvim",
    opts = { options = { theme = "auto", globalstatus = true } },
  },

  -- Указать LazyVim, что используется oldworld
  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "oldworld" },
  },
}
