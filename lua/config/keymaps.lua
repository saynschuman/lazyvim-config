-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- Открыть полное сравнение всех изменений
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- 🔍 Основные команды
map("n", "<leader>gd", "<cmd>DiffviewOpen<CR>", { desc = "📂 Diff всего проекта" })
map("n", "<leader>gD", "<cmd>DiffviewOpen HEAD~1<CR>", { desc = "📂 Diff с предыдущим коммитом" })
map("n", "<leader>gq", "<cmd>DiffviewClose<CR>", { desc = "❌ Закрыть Diffview" })

-- 🕓 История
map("n", "<leader>gh", "<cmd>DiffviewFileHistory %<CR>", { desc = "🕘 История текущего файла" })
map("n", "<leader>gH", "<cmd>DiffviewFileHistory<CR>", { desc = "🕘 История проекта" })

-- 🧭 Панель файлов
map(
  "n",
  "<leader>gt",
  "<cmd>DiffviewToggleFiles<CR>",
  { desc = "📁 Показать/скрыть панель файлов" }
)
map("n", "<leader>gf", "<cmd>DiffviewFocusFiles<CR>", { desc = "🔎 Фокус на панель файлов" })
map("n", "<leader>gr", "<cmd>DiffviewRefresh<CR>", { desc = "🔄 Обновить Diffview" })

-- 📑 Навигация по изменениям
map("n", "]c", "]c", { desc = "➡ Следующий hunk (diff)" })
map("n", "[c", "[c", { desc = "⬅ Предыдущий hunk (diff)" })

-- 🧩 Для конфликтов/мержа (внутри merge view)
map("n", "<leader>ga", ":DiffviewToggleFiles<CR>", { desc = "🧩 Принять изменения (toggle panel)" })
-- Маппинги типа `:DiffviewFileHistory HEAD~3 -- path` можно добавлять вручную, если хочешь

-- 🛠️ Настройка визуала diff-окон (не hotkey, но полезно)
vim.opt.fillchars:append({ diff = " " }) -- диагональные полосы вместо пустых строк

-- Compare

vim.keymap.set("n", "<leader>gc", function()
  -- Получаем список всех локальных и удалённых веток
  local branches = vim.fn.systemlist("git branch --all --format='%(refname:short)'")

  -- Убираем текущую HEAD, origin/HEAD и сортируем
  local clean = {}
  for _, b in ipairs(branches) do
    if not b:match("HEAD") then
      table.insert(clean, b)
    end
  end
  table.sort(clean)

  -- Получаем текущую ветку
  local current = vim.fn.system("git rev-parse --abbrev-ref HEAD"):gsub("%s+", "")

  -- Выбор ветки
  vim.ui.select(clean, {
    prompt = "Сравнить с веткой:",
  }, function(choice)
    if not choice or choice == current then
      print("Ветка не выбрана или совпадает с текущей")
      return
    end
    -- Команда для сравнения
    local cmd = string.format("DiffviewOpen %s...%s", choice, current)
    vim.cmd(cmd)
  end)
end, { desc = "🔀 Diff с выбранной веткой" })

-- Горячая клавиша <leader>gb: переключение на выбранную ветку
vim.keymap.set("n", "<leader>gb", function()
  local branches = vim.fn.systemlist("git branch --all --format='%(refname:short)'")

  local clean = {}
  for _, b in ipairs(branches) do
    if not b:match("HEAD") then
      table.insert(clean, b)
    end
  end

  table.sort(clean)

  vim.ui.select(clean, { prompt = "Переключиться на ветку:" }, function(choice)
    if not choice then
      vim.notify("Переключение отменено", vim.log.levels.INFO)
      return
    end

    -- Проверяем, существует ли локальная ветка
    vim.fn.system("git show-ref --verify --quiet refs/heads/" .. choice)
    local output
    if vim.v.shell_error ~= 0 then
      -- Попытка переключиться на удалённую ветку
      local remote, branch = choice:match("^([^/]+)/(.+)$")
      if remote and branch then
        output = vim.fn.system(string.format("git checkout -b %s %s/%s", branch, remote, branch))
        choice = branch
      else
        output = vim.fn.system("git checkout " .. choice)
      end
    else
      output = vim.fn.system("git checkout " .. choice)
    end

    if vim.v.shell_error == 0 then
      vim.notify("✅ Переключено на ветку: " .. choice, vim.log.levels.INFO)
    else
      vim.notify("❌ Ошибка переключения:\n" .. output, vim.log.levels.ERROR)
    end
  end)
end, { desc = "🔁 Переключиться на выбранную ветку" })
