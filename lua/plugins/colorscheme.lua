return {
  {
    "everviolet/nvim",
    name = "evergarden",
    lazy = false,
    priority = 1000,
    opts = {
      theme = {
        variant = "fall", -- варианты: "winter", "fall", "spring", "summer"
        accent = "green", -- можно заменить на "blue", "orange" и др.
      },
      editor = {
        transparent_background = true, -- прозрачный фон везде
        override_terminal = true,      -- цвета терминала как в теме
        sign = { color = "none" },     -- иконки без фона
        float = {
          color = "none",              -- прозрачные popups (Telescope и др.)
          solid_border = false,
        },
        completion = {
          color = "none", -- прозрачный фон в меню автодополнения
        },
      },
      style = {
        tabline = { "reverse" },
        search = { "italic", "reverse" },
        incsearch = { "italic", "reverse" },
        types = { "italic" },
        keyword = { "italic" },
        comment = { "italic" },
      },
      integrations = {
        blink_cmp = true,
        cmp = true,
        fzf_lua = true,
        gitsigns = true,
        indent_blankline = { enable = true, scope_color = "green" },
        mini = { enable = true },
        nvimtree = true,
        rainbow_delimiters = true,
        symbols_outline = true,
        telescope = true,
        which_key = true,
        neotree = true,
      },
      overrides = {
        Normal = { nil, "NONE" }, -- полностью прозрачный фон
      },
    },
    config = function(_, opts)
      require("evergarden").setup(opts)
      vim.cmd("colorscheme evergarden")
    end,
  },

  -- Автоматическая тема для lualine
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      options = {
        theme = "auto",
        globalstatus = true,
      },
    },
  },

  -- Устанавливаем тему для LazyVim
  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "evergarden" },
  },
}
