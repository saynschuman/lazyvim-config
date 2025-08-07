return {
  "nvim-telescope/telescope.nvim",
  opts = function(_, opts)
    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")
    local function commit_from_status(prompt_bufnr)
      actions.close(prompt_bufnr)
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
    end
    opts.pickers = opts.pickers or {}
    opts.pickers.git_status = opts.pickers.git_status or {}
    opts.pickers.git_status.mappings = opts.pickers.git_status.mappings or {}
    for _, mode in ipairs({ "i", "n" }) do
      opts.pickers.git_status.mappings[mode] = opts.pickers.git_status.mappings[mode] or {}
    end
    opts.pickers.git_status.mappings.i["<C-c>"] = commit_from_status
    opts.pickers.git_status.mappings.n.c = commit_from_status
    return opts
  end,
  keys = {
    { "<leader>gs", function() require("telescope.builtin").git_status() end, desc = "Git status" },
    { "<leader>gc", function() require("telescope.builtin").git_commits() end, desc = "Git commits" },
    { "<leader>gb", function() require("telescope.builtin").git_branches() end, desc = "Git branches" },
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
