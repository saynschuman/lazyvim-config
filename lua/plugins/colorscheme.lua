return {
  "briones-gabriel/darcula-solid.nvim",
  dependencies = { "rktjmp/lush.nvim", "nvim-treesitter/nvim-treesitter" },
  config = function()
    vim.cmd.colorscheme("darcula-solid-custom")
    vim.cmd("set termguicolors")
  end
}
