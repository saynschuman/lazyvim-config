return {
  "nvim-telescope/telescope.nvim",
  opts = function(_, opts)
    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")

    local function add_file(prompt_bufnr)
      local selection = action_state.get_selected_entry()
      actions.close(prompt_bufnr)
      local file = selection.path or selection.filename or selection.value
      vim.fn.system({ "git", "add", file })
      if vim.v.shell_error ~= 0 then
        vim.notify("Add failed", vim.log.levels.ERROR)
      else
        vim.notify("Added " .. file, vim.log.levels.INFO)
      end
    end

    opts.pickers = opts.pickers or {}
    opts.pickers.find_files = opts.pickers.find_files or {}
    opts.pickers.find_files.mappings = opts.pickers.find_files.mappings or {}
    for _, mode in ipairs({ "i", "n" }) do
      opts.pickers.find_files.mappings[mode] = opts.pickers.find_files.mappings[mode] or {}
    end
    opts.pickers.find_files.mappings.i["<C-a>"] = add_file
    opts.pickers.find_files.mappings.n.a = add_file

    return opts
  end,
  keys = {
    { "<leader>ga", function() require("telescope.builtin").find_files() end, desc = "Git add file" },
    { "<leader>gc", function() require("telescope.builtin").git_commits() end, desc = "Git commits" },
    {
      "<leader>gC",
      function()
        vim.ui.input({ prompt = "Commit message: " }, function(input)
          if not input or input == "" then
            vim.notify("Commit aborted", vim.log.levels.WARN)
            return
          end
          vim.fn.system({ "git", "commit", "-m", input })
          if vim.v.shell_error ~= 0 then
            vim.notify("Commit failed", vim.log.levels.ERROR)
          else
            vim.notify("Committed", vim.log.levels.INFO)
          end
        end)
      end,
      desc = "Git commit",
    },
  },
}
