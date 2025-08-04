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
