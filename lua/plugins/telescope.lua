return {
  "nvim-telescope/telescope.nvim",
  opts = function(_, opts)
    local actions = require("telescope.actions")

    local function commit(prompt_bufnr)
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
      opts.pickers.git_status.mappings[mode]["<space>"] = actions.git_staging_toggle
      opts.pickers.git_status.mappings[mode]["<CR>"] = commit
    end

    return opts
  end,
  keys = {
    { "ga", function() require("telescope.builtin").git_status() end, desc = "Git add" },
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
