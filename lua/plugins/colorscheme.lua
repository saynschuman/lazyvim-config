return {
  {
    "uloco/bluloco.nvim",
    lazy = false,
    priority = 1000,
    dependencies = { "rktjmp/lush.nvim" },
    config = function()
      require("bluloco").setup({
        style = "auto",                            -- "auto" | "dark" | "light"
        transparent = false,                       -- фон из темы (false) или прозрачный (true)
        italics = false,                           -- включить курсив для ключевых слов/комментариев
        terminal = vim.fn.has("gui_running") == 1, -- терминальные цвета темы (только для GUI)
        guicursor = true,                          -- цветной курсор
        rainbow_headings = false,                  -- разноцветные заголовки
      })

      vim.opt.termguicolors = true
      vim.cmd("colorscheme bluloco")
    end,
  },

  -- lualine: пусть сам подбирает стиль в зависимости от темы
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      options = { theme = "auto", globalstatus = true },
    },
  },

  -- чтобы LazyVim знал, какая тема активна
  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "bluloco" },
  },
}
