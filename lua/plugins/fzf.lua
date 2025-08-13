--
-- LazyVim: Telescope + telescope-fzf-native.nvim (с поддержкой расширенного синтаксиса поиска fzf)
--
-- Положи файл в: ~/.config/nvim/lua/plugins/telescope-fzf.lua
-- Этот конфиг добавляет Telescope, ускоритель fzf-native и хоткеи.
-- Поддерживаются типы совпадений fzf:
--   sbtrkt      → нестрогое (fuzzy)
--   'quoted'    → точное
--   ^prefix     → по префиксу
--   suffix$     → по суффиксу
--   !pattern    → инверсное (исключающее)
-- Все эти варианты работают в любом поисковом запросе Telescope с активным fzf.
--
return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release || make",
        config = function()
          pcall(function()
            require("telescope").load_extension("fzf")
          end)
        end,
      },
      {
        -- Расширение, позволяющее добавлять/менять rg-глоб-фильтры прямо из UI
        -- Например: -g '!**/node_modules/**' или -g '!*.lock'
        "nvim-telescope/telescope-live-grep-args.nvim",
        config = function()
          pcall(function()
            require("telescope").load_extension("live_grep_args")
          end)
        end,
      },
    },
    opts = function(_, opts)
      opts = opts or {}
      opts.defaults = opts.defaults or {}
      opts.extensions = opts.extensions or {}

      opts.defaults = vim.tbl_deep_extend("force", opts.defaults, {
        sorting_strategy = "ascending",
        layout_config = { prompt_position = "top" },
        file_ignore_patterns = {
          ".git/",
          "node_modules/",
          "dist/",
          "build/",
          "target/",
          "venv/",
          "%.lock$",
        },
      })

      opts.extensions.fzf = {
        fuzzy = true,
        override_generic_sorter = true,
        override_file_sorter = true,
        case_mode = "smart_case",
      }

      -- Настройки live_grep_args: хоткеи для добавления -g фильтров в промпт
      local lga_actions = require("telescope-live-grep-args.actions")
      opts.extensions["live_grep_args"] = {
        auto_quoting = true, -- автоматические кавычки для пробелов
        mappings = {
          i = {
            ["<C-k>"] = lga_actions.quote_prompt(),                     -- обернуть запрос в кавычки
            ["<C-g>"] = lga_actions.quote_prompt({ postfix = " -g " }), -- начать добавление -g <glob>
            ["<C-n>"] = lga_actions.quote_prompt({ postfix = " -g !**/node_modules/**" }),
            ["<C-d>"] = lga_actions.quote_prompt({ postfix = " -g !**/dist/**" }),
            ["<C-l>"] = lga_actions.quote_prompt({ postfix = " -g !*.lock" }),
          },
        },
      }

      return opts
    end,
    keys = function()
      local builtin = require("telescope.builtin")
      local lga = require("telescope").extensions.live_grep_args
      return {
        { "<leader>ff", function() builtin.find_files({ hidden = true }) end, desc = "Поиск файлов (в т.ч. скрытые)" },
        { "<leader>fF", function() builtin.find_files({ hidden = true, no_ignore = true }) end, desc = "Файлы (игнор отключен)" },
        { "<leader>fo", builtin.oldfiles, desc = "Недавние файлы" },
        { "<leader>fb", builtin.buffers, desc = "Открытые буферы" },
        -- Заменяем обычный live_grep на live_grep_args, чтобы можно было интерактивно задавать -g фильтры
        { "<leader>sg", function() lga.live_grep_args() end, desc = "Глобальный поиск (интерактивные -g фильтры)" },
        { "<leader>sG", function() lga.live_grep_args({ default_text = "-g !**/node_modules/** -g !**/dist/** " }) end, desc = "Греп (исключая node_modules и dist)" },
        { "<leader>sw", builtin.grep_string, desc = "Слово под курсором" },
        { "<leader>sb", builtin.current_buffer_fuzzy_find, desc = "Поиск в буфере" },
        { "<leader>gs", builtin.git_status, desc = "Git статус" },
        { "<leader>gb", builtin.git_branches, desc = "Git ветки" },
        { "<leader>gc", builtin.git_commits, desc = "Git коммиты" },
        { "<leader>gC", builtin.git_bcommits, desc = "Git коммиты файла" },
        { "<leader>hh", builtin.help_tags, desc = "Help" },
        { "<leader>hk", builtin.keymaps, desc = "Клавиши" },
        { "<leader>hc", builtin.commands, desc = "Команды" },
        { "<leader>hm", builtin.man_pages, desc = "man-страницы" },
        { "<leader>ch", builtin.command_history, desc = "История команд" },
        { "<leader>sh", builtin.search_history, desc = "История поиска" },
        { "gd", builtin.lsp_definitions, desc = "LSP определения" },
        { "gr", builtin.lsp_references, desc = "LSP использования" },
        { "gi", builtin.lsp_implementations, desc = "LSP реализации" },
        { "gt", builtin.lsp_type_definitions, desc = "LSP типы" },
        { "<leader>sd", builtin.diagnostics, desc = "Диагностики проекта" },
        { "<leader>sD", function() builtin.diagnostics({ bufnr = 0 }) end, desc = "Диагностики файла" },
        { "<leader>sr", builtin.resume, desc = "Повторить поиск" },
        { "<leader>:", builtin.commands, desc = "Команды" },
      }
    end,
  },
}
