return {
  "nvim-telescope/telescope-file-browser.nvim",
  dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
  config = function()
    local fb_actions = require("telescope").extensions.file_browser.actions
    local actions = require("telescope.actions")
    local function toggle_ignored_and_hidden(prompt_bufnr)
      fb_actions.toggle_hidden(prompt_bufnr)            -- .*, например .env
      fb_actions.toggle_respect_gitignore(prompt_bufnr) -- файлы из .gitignore
    end

    require("telescope").setup {
      extensions = {
        file_browser = {
          mappings = {
            ["i"] = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<A-c>"] = fb_actions.create,
              ["<A-r>"] = fb_actions.rename,
              ["<A-m>"] = fb_actions.move,
              ["<A-y>"] = fb_actions.copy,
              ["<A-d>"] = fb_actions.remove,
              ["<C-i>"] = toggle_ignored_and_hidden,
            },
            ["n"] = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["c"] = fb_actions.create,
              ["r"] = fb_actions.rename,
              ["m"] = fb_actions.move,
              ["y"] = fb_actions.copy,
              ["d"] = fb_actions.remove,
              ["<C-i>"] = toggle_ignored_and_hidden,
            },
          },
        },
      },
    }

    require("telescope").load_extension("file_browser")
  end
}
