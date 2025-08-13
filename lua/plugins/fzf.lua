--
-- LazyVim: Telescope + telescope-fzf-native.nvim (переписанный, аккуратный вариант)
--
-- Положи файл в: ~/.config/nvim/lua/plugins/telescope-fzf.lua
-- Он добавляет Telescope, ускоритель fzf-native и полный набор хоткеев.
-- Комментарии — на русском.
--
return {
  {
    -- Основной плагин Telescope
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        -- Очень быстрый сортировщик/матчер на C
        "nvim-telescope/telescope-fzf-native.nvim",
        -- Предпочитаем cmake; если не установлен — попробуем make (macOS/Linux)
        -- На macOS с Homebrew обычно достаточно: brew install cmake
        build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release || make",
        config = function()
          -- Загружаем расширение fzf после инициализации telescope
          pcall(function()
            require("telescope").load_extension("fzf")
          end)
        end,
      },
    },

    -- Настройки Telescope и расширения fzf
    opts = function(_, opts)
      opts = opts or {}
      opts.defaults = opts.defaults or {}
      opts.extensions = opts.extensions or {}

      -- Общие дефолты
      opts.defaults = vim.tbl_deep_extend("force", opts.defaults, {
        sorting_strategy = "ascending", -- Промпт сверху, результаты снизу
        layout_config = { prompt_position = "top" },
        -- Игнорируем шумовые директории (дополняй под свой проект)
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

      -- Настройки расширения fzf
      opts.extensions.fzf = {
        fuzzy = true,                   -- Нестрогий поиск (fuzzy)
        override_generic_sorter = true, -- Заменяем общий сортировщик Telescope
        override_file_sorter = true,    -- Заменяем файловый сортировщик
        case_mode = "smart_case",       -- Умный регистр
      }

      return opts
    end,

    -- Горячие клавиши (which-key получит описания из desc)
    keys = function()
      local builtin = require("telescope.builtin")

      return {
        -- ::::::::::::: ФАЙЛЫ ::::::::::::: --
        {
          "<leader>ff",
          function()
            -- Поиск файлов, включая скрытые (учитывает .gitignore)
            builtin.find_files({ hidden = true })
          end,
          desc = "Поиск файлов (в т.ч. скрытые)",
          noremap = true,
          silent = true,
        },
        {
          "<leader>fF",
          function()
            -- Полный поиск без игнора: если файл скрыт правилами .gitignore
            builtin.find_files({ hidden = true, no_ignore = true })
          end,
          desc = "Файлы (игнор отключен)",
        },
        { "<leader>fo", builtin.oldfiles, desc = "Недавние файлы" },
        { "<leader>fb", builtin.buffers, desc = "Открытые буферы" },

        -- ::::::::::::: ТЕКСТОВЫЙ ПОИСК (GREP) ::::::::::::: --
        { "<leader>sg", builtin.live_grep, desc = "Глобальный поиск по проекту (ripgrep)" },
        {
          "<leader>sG",
          function()
            -- Глобальный поиск + скрытые файлы + без .gitignore
            builtin.live_grep({ additional_args = { "--hidden", "--no-ignore" } })
          end,
          desc = "Греп со скрытыми файлами и без .gitignore",
        },
        { "<leader>sw", builtin.grep_string, desc = "Искать слово под курсором" },
        { "<leader>sb", builtin.current_buffer_fuzzy_find, desc = "Поиск в текущем буфере" },

        -- ::::::::::::: GIT ::::::::::::: --
        { "<leader>gs", builtin.git_status, desc = "Git статус (изменённые файлы)" },
        { "<leader>gb", builtin.git_branches, desc = "Git ветки" },
        { "<leader>gc", builtin.git_commits, desc = "Коммиты репозитория" },
        { "<leader>gC", builtin.git_bcommits, desc = "Коммиты текущего файла" },

        -- ::::::::::::: ПОМОЩЬ / НЕОВИМ ::::::::::::: --
        { "<leader>hh", builtin.help_tags, desc = "Help-теги Neovim" },
        { "<leader>hk", builtin.keymaps, desc = "Список горячих клавиш" },
        { "<leader>hc", builtin.commands, desc = "Команды Neovim" },
        { "<leader>hm", builtin.man_pages, desc = "man-страницы" },
        { "<leader>ch", builtin.command_history, desc = "История команд (\":\")" },
        { "<leader>sh", builtin.search_history, desc = "История поисков Telescope" },

        -- ::::::::::::: LSP (если настроен) ::::::::::::: --
        { "gd", builtin.lsp_definitions, desc = "LSP: переход к определению" },
        { "gr", builtin.lsp_references, desc = "LSP: все использования" },
        { "gi", builtin.lsp_implementations, desc = "LSP: реализации" },
        { "gt", builtin.lsp_type_definitions, desc = "LSP: определения типов" },
        { "<leader>sd", builtin.diagnostics, desc = "Диагностики проекта" },
        {
          "<leader>sD",
          function()
            builtin.diagnostics({ bufnr = 0 }) -- Только текущий файл
          end,
          desc = "Диагностики текущего файла",
        },

        -- ::::::::::::: ПРОЧЕЕ ::::::::::::: --
        { "<leader>sr", builtin.resume, desc = "Повторить последний поиск" },
        { "<leader>:", builtin.commands, desc = "Список команд (альтернатива)" },
      }
    end,
  },
}
