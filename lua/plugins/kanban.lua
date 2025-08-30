return {
  {
    "arakkkkk/kanban.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim", -- не обязательно, но удобно для поиска
    },
    config = function()
      require("kanban").setup({
        markdown = {
          description_folder = "./tasks/", -- Путь для заметок к задачам
          list_head = "## ",               -- Заголовки списков в markdown
        },
      })
    end,
    keys = {
      { "<leader>kb", ":KanbanOpen kanban.md<CR>",   desc = "Open Kanban board" },
      { "<leader>kc", ":KanbanCreate kanban.md<CR>", desc = "Create new Kanban board" },
    },
  },
}
