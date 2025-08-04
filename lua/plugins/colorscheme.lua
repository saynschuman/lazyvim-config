return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 3000,
    config = function()
      require("catppuccin").setup({
        float = {
          transparent = true,
          solid = false,
        },
        flavour = "mocha", -- latte, frappe, macchiato, mocha
        transparent_background = true,
      })
      vim.cmd.colorscheme("catppuccin")
    end,
  },
}
