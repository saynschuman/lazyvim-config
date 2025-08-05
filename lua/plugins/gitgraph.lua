return {
  "isakbm/gitgraph.nvim",
  dependencies = { "sindrets/diffview.nvim" },
  opts = {
    hooks = {
      -- Открытие diff по одному коммиту
      on_select_commit = function(commit)
        vim.notify("DiffviewOpen " .. commit.hash .. "^!")
        vim.cmd("DiffviewOpen " .. commit.hash .. "^!")
      end,
      -- Дифф между двумя коммитами
      on_select_range_commit = function(from, to)
        vim.notify("DiffviewOpen " .. from.hash .. "~1.." .. to.hash)
        vim.cmd("DiffviewOpen " .. from.hash .. "~1.." .. to.hash)
      end,
    },
  },
  keys = {
    {
      "<leader>gL",
      function()
        require("gitgraph").draw({}, { all = true, max_count = 5000 })
      end,
      desc = "GitGraph - Full Graph",
    },
    {
      "<leader>gl",
      function()
        local handle = io.popen("git rev-parse --abbrev-ref HEAD")
        if not handle then
          vim.notify("Failed to get branch name", vim.log.levels.ERROR)
          return
        end
        local branch = handle:read("*l")
        handle:close()
        require("gitgraph").draw({ branches = { branch } }, { max_count = 1000 })
      end,
      desc = "GitGraph - Current Branch Only",
    },
  },
}
