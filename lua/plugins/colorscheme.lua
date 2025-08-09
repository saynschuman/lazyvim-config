return {
  {
    "xero/miasma.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      -- включаем тему
      vim.cmd.colorscheme("miasma")
    end,
  },

  -- если хочешь, чтобы LazyVim знал, какая тема используется
  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "miasma" },
  },
}
