return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release || make",
        config = function() pcall(function() require("telescope").load_extension("fzf") end) end,
      },
      {
        "nvim-telescope/telescope-live-grep-args.nvim",
        config = function() pcall(function() require("telescope").load_extension("live_grep_args") end) end,
      },
      {
        "nvim-telescope/telescope-file-browser.nvim",
        config = function() pcall(function() require("telescope").load_extension("file_browser") end) end,
      },
    },

    opts = function(_, opts)
      opts                               = opts or {}
      opts.defaults                      = opts.defaults or {}
      opts.extensions                    = opts.extensions or {}

      -- ===== Layout (фуллскрин) =====
      opts.defaults.sorting_strategy     = "ascending"
      opts.defaults.layout_strategy      = "horizontal"
      opts.defaults.layout_config        = {
        width = function(_, cols) return math.floor(cols) end,
        height = function(_, _, lines) return math.floor(lines) end,
        preview_width = function(_, cols) return math.floor(cols * 0.65) end,
        prompt_position = "top",
      }

      -- Скрываем цветные ленты-заголовки (исчезнет белый “File Browser”)
      opts.defaults.prompt_title         = false
      opts.defaults.results_title        = false
      opts.defaults.preview_title        = false

      -- Бордеры – тонкие линии, без заливки
      opts.defaults.border               = true
      opts.defaults.borderchars          = {
        prompt  = { "─", "│", " ", "│", "╭", "╮", "│", "│" },
        results = { "─", "│", "─", "│", "│", "│", "╯", "╰" },
        preview = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
      }

      -- Единый фон для всех окон Telescope
      opts.defaults.winhighlight         =
      "Normal:Normal,NormalFloat:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None"

      -- Игноры
      opts.defaults.file_ignore_patterns = opts.defaults.file_ignore_patterns or {
        ".git/", "node_modules/", "dist/", "build/", "target/", "venv/", "%.lock$",
      }

      -- ==== Маппинги в промпте ====
      local actions                      = require("telescope.actions")
      opts.defaults.mappings             = vim.tbl_deep_extend("force", opts.defaults.mappings or {}, {
        i = {
          ["<C-j>"] = actions.move_selection_next,
          ["<C-k>"] = actions.move_selection_previous,
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

      -- ==== live_grep_args ====
      local lga_actions                  = require("telescope-live-grep-args.actions")
      opts.extensions["live_grep_args"]  = vim.tbl_deep_extend("force", opts.extensions["live_grep_args"] or {}, {
        auto_quoting = true,
        mappings = { i = { ["<C-g>"] = lga_actions.quote_prompt({ postfix = " -g " }) } },
      })

      -- ==== file_browser ====
      local fb_actions                   = require("telescope").extensions.file_browser.actions
      local function toggle_ignored_and_hidden(prompt_bufnr)
        fb_actions.toggle_hidden(prompt_bufnr)
        fb_actions.toggle_respect_gitignore(prompt_bufnr)
      end

      -- Важно: не навязываю тему ivy (она перемещает окно вниз). Оставим текущий вид.
      opts.extensions["file_browser"] = vim.tbl_deep_extend("force", opts.extensions["file_browser"] or {}, {
        mappings = {
          i = {
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
            ["<A-c>"] = fb_actions.create,
            ["<A-r>"] = fb_actions.rename,
            ["<A-m>"] = fb_actions.move,
            ["<A-y>"] = fb_actions.copy,
            ["<A-d>"] = fb_actions.remove,
            ["<C-i>"] = toggle_ignored_and_hidden,
          },
          n = {
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
      })

      -- ==== Финальный фикс хайлайтов (фон у префикса/счётчика/тайтлов) ====
      local function fix_telescope_hl()
        local set = vim.api.nvim_set_hl
        -- Бордеры/фон
        set(0, "TelescopePromptBorder", { fg = "NONE", bg = "NONE" })
        set(0, "TelescopeResultsBorder", { fg = "NONE", bg = "NONE" })
        set(0, "TelescopePreviewBorder", { fg = "NONE", bg = "NONE" })
        set(0, "TelescopePromptNormal", { bg = "NONE" })
        set(0, "TelescopeResultsNormal", { bg = "NONE" })
        set(0, "TelescopePreviewNormal", { bg = "NONE" })
        -- Заголовки выключены, но на всякий: без фона
        set(0, "TelescopeTitle", { bg = "NONE" })
        set(0, "TelescopePromptTitle", { bg = "NONE" })
        set(0, "TelescopeResultsTitle", { bg = "NONE" })
        set(0, "TelescopePreviewTitle", { bg = "NONE" })
        -- Префикс-стрелка и счётчик возле промпта
        set(0, "TelescopePromptPrefix", { bg = "NONE" })
        pcall(function() set(0, "TelescopePromptCounter", { bg = "NONE" }) end) -- есть не во всех версиях
      end
      fix_telescope_hl()
      vim.api.nvim_create_autocmd("ColorScheme", { callback = fix_telescope_hl })

      return opts
    end,

    keys = function()
      local builtin = require("telescope.builtin")
      local lga = require("telescope").extensions.live_grep_args

      local function esc_search_literal(s) return s:gsub("\\", "\\\\"):gsub("#", "\\#") end
      local function esc_replacement(s) return s:gsub("\\", "\\\\"):gsub("&", "\\&"):gsub("#", "\\#") end

      local function grep_and_replace()
        local default_args = "-g !**/dist/** -g !**/node_modules/** -g !**/client-widgets/** "
        lga.live_grep_args({
          default_text = default_args,
          attach_mappings = function(prompt_bufnr, map)
            local actions = require("telescope.actions")
            local action_state = require("telescope.actions.state")
            local function strip_flags(line)
              line = line:gsub("%-%-fixed%-strings", "")
              line = line:gsub("%-%-hidden", "")
              line = line:gsub("%-g%s+\".-\"", "")
              line = line:gsub("%-g%s+%S+", "")
              return (line:gsub("^%s+", ""):gsub("%s+$", ""))
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
            map("i", "<C-r>", do_replace); map("n", "<C-r>", do_replace)
            return true
          end,
        })
      end

      return {
        { "<leader>ff", function() builtin.find_files({ hidden = true }) end, desc = "Поиск файлов (в т.ч. скрытые)" },
        { "<leader>fF", function() builtin.find_files({ hidden = true, no_ignore = true }) end, desc = "Файлы (игнор отключен)" },
        { "<leader>fo", builtin.oldfiles, desc = "Недавние файлы" },
        { "<leader>fb", builtin.buffers, desc = "Открытые буферы 📖" },

        {
          "<leader>gT",
          function()
            lga.live_grep_args({ default_text = "-g !**/node_modules/** -g !**/dist/** -g !**/client-widgets/** " })
          end,
          desc = "Греп (исключая node_modules, dist, client-widgets)"
        },
        { "<leader>sw", builtin.grep_string, desc = "Слово под курсором" },
        { "<leader>sb", builtin.current_buffer_fuzzy_find, desc = "Поиск в буфере" },

        { "<leader>gs", builtin.git_status, desc = "Git статус" },
        -- { "<leader>gb", builtin.git_branches, desc = "Git ветки" },
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

        { "<leader>sr", builtin.resume, desc = "Повторить последний поиск" },
        { "<leader>:", builtin.commands, desc = "Команды" },

        { "<leader>rP", grep_and_replace, desc = "Найти и заменить (исключая dist/node_modules/client-widgets)" },
      }
    end,
  },
}
