--
-- LazyVim: Telescope + telescope-fzf-native.nvim (полный конфиг с grep_and_replace)
-- Полноэкранный режим, увеличенный preview, навигация Ctrl-j/Ctrl-k, вставка из буфера обмена в строку поиска.
-- Поддержка расширенного синтаксиса fzf в промпте и интерактивного grep с include/exclude.
-- Добавлено: <leader>rP — поиск и замена прямо из окна Telescope с исключением dist/node_modules/client-widgets
-- и безопасной обработкой символов вроде { }.
--
return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        -- Быстрый C-сортировщик fzf
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release || make",
        config = function()
          pcall(function()
            require("telescope").load_extension("fzf")
          end)
        end,
      },
      {
        -- Интерактивные аргументы для ripgrep (в т.ч. -g include/exclude)
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

      -- Полноэкранный layout с широким preview (целые размеры для plenary)
      opts.defaults.sorting_strategy = "ascending"
      opts.defaults.layout_strategy = "horizontal"
      opts.defaults.layout_config = {
        width = function(_, cols) return math.floor(cols) end,
        height = function(_, _, lines) return math.floor(lines) end,
        preview_width = function(_, cols) return math.floor(cols * 0.65) end,
        prompt_position = "top",
      }

      -- Базовые игноры (для файловых пикеров)
      opts.defaults.file_ignore_patterns = opts.defaults.file_ignore_patterns or {
        ".git/",
        "node_modules/",
        "dist/",
        "build/",
        "target/",
        "venv/",
        "%.lock$",
      }

      -- Навигация и вставка в промпте Telescope
      local actions = require("telescope.actions")
      opts.defaults.mappings = vim.tbl_deep_extend("force", opts.defaults.mappings or {}, {
        i = {
          ["<C-j>"] = actions.move_selection_next,
          ["<C-k>"] = actions.move_selection_previous,
          -- Вставка системного буфера обмена в промпт (эквивалент <C-r>+)
          ["<C-v>"] = function()
            local keys = vim.api.nvim_replace_termcodes("<C-r>+", true, false, true)
            vim.api.nvim_feedkeys(keys, "i", false)
          end,
          ["<S-Insert>"] = function()
            local keys = vim.api.nvim_replace_termcodes("<C-r>+", true, false, true)
            vim.api.nvim_feedkeys(keys, "i", false)
          end,
        },
        n = {
          ["<C-j>"] = actions.move_selection_next,
          ["<C-k>"] = actions.move_selection_previous,
          ["<C-v>"] = function()
            local keys = vim.api.nvim_replace_termcodes("i<C-r>+", true, false, true)
            vim.api.nvim_feedkeys(keys, "n", false)
          end,
        },
      })

      -- Настройки live_grep_args: авто-кавычки и быстрые -g
      local lga_actions = require("telescope-live-grep-args.actions")
      opts.extensions["live_grep_args"] = vim.tbl_deep_extend("force", opts.extensions["live_grep_args"] or {}, {
        auto_quoting = true,
        mappings = {
          i = {
            ["<C-g>"] = lga_actions.quote_prompt({ postfix = " -g " }), -- начать добавление -g
          },
        },
      })

      return opts
    end,

    keys = function()
      local builtin = require("telescope.builtin")
      local lga = require("telescope").extensions.live_grep_args

      -- Вспомогательные функции экранирования для Vim :s (буквальный режим \V)
      local function esc_search_literal(s)
        -- Для \V достаточно экранировать только обратный слэш и разделитель '#'
        return s:gsub("\\", "\\\\"):gsub("#", "\\#")
      end
      local function esc_replacement(s)
        -- В replacement экранируем \\, &, #
        return s:gsub("\\", "\\\\"):gsub("&", "\\&"):gsub("#", "\\#")
      end

      -- Поиск и замена прямо из Telescope (ripgrep + quickfix + :cdo)
      local function grep_and_replace()
        -- Буквальный поиск (чтобы символы вроде { } не ломали запрос) и исключение каталогов
        local default_args = "-g !**/dist/** -g !**/node_modules/** -g !**/client-widgets/** "
        lga.live_grep_args({
          default_text = default_args,
          attach_mappings = function(prompt_bufnr, map)
            local actions = require("telescope.actions")
            local action_state = require("telescope.actions.state")

            local function strip_flags(line)
              -- Убираем сервисные флаги, оставляя собственно строку поиска
              line = line:gsub("%-%-fixed%-strings", "")
              line = line:gsub("%-%-hidden", "")
              line = line:gsub("%-g%s+\".-\"", "") -- -g "..."
              line = line:gsub("%-g%s+%S+", "")    -- -g ...
              line = line:gsub("^%s+", ""):gsub("%s+$", "")
              return line
            end

            local function do_replace()
              local line = action_state.get_current_line()
              local search = strip_flags(line)
              local replace = vim.fn.input("Заменить на: ")
              if search == nil or search == "" or replace == nil then return end

              local pat = "\\V" .. esc_search_literal(search)
              local rep = esc_replacement(replace)

              actions.smart_send_to_qflist(prompt_bufnr)
              actions.open_qflist(prompt_bufnr)
              vim.cmd("cdo s#" .. pat .. "#" .. rep .. "#g | update")
              print("Готово: заменено во всех найденных файлах")
            end

            -- Внутри окна Telescope: Ctrl-r запускает фазу замены
            map("i", "<C-r>", do_replace)
            map("n", "<C-r>", do_replace)
            return true
          end,
        })
      end

      return {
        -- Файлы
        { "<leader>ff", function() builtin.find_files({ hidden = true }) end, desc = "Поиск файлов (в т.ч. скрытые)" },
        { "<leader>fF", function() builtin.find_files({ hidden = true, no_ignore = true }) end, desc = "Файлы (игнор отключен)" },
        { "<leader>fo", builtin.oldfiles, desc = "Недавние файлы" },
        { "<leader>fb", builtin.buffers, desc = "Открытые буферы 📖" },

        -- Текстовый поиск (ripgrep) с интерактивными -g
        { "<leader>gt", function() lga.live_grep_args() end, desc = "Глобальный поиск (интерактивные -g фильтры)" },
        {
          "<leader>gT",
          function()
            lga.live_grep_args({
              default_text =
              "-g !**/node_modules/** -g !**/dist/** -g !**/client-widgets/** "
            })
          end,
          desc = "Греп (исключая node_modules, dist, client-widgets)"
        },
        { "<leader>sw", builtin.grep_string, desc = "Слово под курсором" },
        { "<leader>sb", builtin.current_buffer_fuzzy_find, desc = "Поиск в буфере" },

        -- Git
        { "<leader>gs", builtin.git_status, desc = "Git статус" },
        { "<leader>gb", builtin.git_branches, desc = "Git ветки" },
        { "<leader>gc", builtin.git_commits, desc = "Git коммиты" },
        { "<leader>gC", builtin.git_bcommits, desc = "Git коммиты файла" },

        -- Help / Neovim
        { "<leader>hh", builtin.help_tags, desc = "Help" },
        { "<leader>hk", builtin.keymaps, desc = "Клавиши" },
        { "<leader>hc", builtin.commands, desc = "Команды" },
        { "<leader>hm", builtin.man_pages, desc = "man-страницы" },
        { "<leader>ch", builtin.command_history, desc = "История команд" },
        { "<leader>sh", builtin.search_history, desc = "История поиска" },

        -- LSP
        { "gd", builtin.lsp_definitions, desc = "LSP определения" },
        { "gr", builtin.lsp_references, desc = "LSP использования" },
        { "gi", builtin.lsp_implementations, desc = "LSP реализации" },
        { "gt", builtin.lsp_type_definitions, desc = "LSP типы" },
        { "<leader>sd", builtin.diagnostics, desc = "Диагностики проекта" },
        { "<leader>sD", function() builtin.diagnostics({ bufnr = 0 }) end, desc = "Диагностики файла" },

        -- Повтор поиска
        { "<leader>sr", builtin.resume, desc = "Повторить последний поиск" },
        { "<leader>:", builtin.commands, desc = "Команды" },

        -- === Поиск и ЗАМЕНА прямо из Telescope ===
        { "<leader>rP", grep_and_replace, desc = "Найти и заменить (исключая dist/node_modules/client-widgets)" },
      }
    end,
  },
}
