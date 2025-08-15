-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- Открыть полное сравнение всех изменений
local map = vim.keymap.set

local function create_popup(lines)
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  local width = math.floor(vim.o.columns * 0.8)
  local height = math.min(#lines + 2, math.floor(vim.o.lines * 0.8))
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded",
  })
  vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = buf, silent = true })
  vim.keymap.set("n", "<Esc>", "<cmd>close<CR>", { buffer = buf, silent = true })
  return buf, win
end

local function start_spinner(buf, line)
  local frames = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
  local idx = 1
  local timer = vim.loop.new_timer()
  timer:start(
    0,
    100,
    vim.schedule_wrap(function()
      if not vim.api.nvim_buf_is_valid(buf) then
        timer:stop()
        timer:close()
        return
      end
      vim.api.nvim_buf_set_lines(buf, line, line + 1, false, { "Loading " .. frames[idx] })
      idx = (idx % #frames) + 1
    end)
  )
  return {
    stop = function()
      timer:stop()
      timer:close()
      if vim.api.nvim_buf_is_valid(buf) then
        vim.api.nvim_buf_set_lines(buf, line, line + 1, false, { "" })
      end
    end,
  }
end

local function collect_output(tbl, data)
  for _, s in ipairs(data) do
    if s ~= "" then
      table.insert(tbl, s)
    end
  end
end

-- 🔍 Основные команды
map("n", "<leader>gd", "<cmd>DiffviewOpen<CR>", { desc = "📂 Diff всего проекта" })
map("n", "<leader>gD", "<cmd>DiffviewOpen HEAD~1<CR>", { desc = "📂 Diff с предыдущим коммитом" })
map("n", "gq", "<cmd>DiffviewClose<CR>", { desc = "❌ Закрыть Diffview" })

-- 🕓 История
map("n", "gh", "<cmd>DiffviewFileHistory %<CR>", { desc = "🕘 История текущего файла" })
map("n", "gH", "<cmd>DiffviewFileHistory<CR>", { desc = "🕘 История проекта" })

-- 🧭 Панель файлов
map(
  "n",
  "gt",
  "<cmd>DiffviewToggleFiles<CR>",
  { desc = "📁 Показать/скрыть панель файлов" }
)
map("n", "gf", "<cmd>DiffviewFocusFiles<CR>", { desc = "🔎 Фокус на панель файлов" })

-- vim.keymap.set("n", "<leader>gr", function()
--   local buf = create_popup({ "git reset --hard HEAD", "", "" })
--   local spin = start_spinner(buf, 2)
--   local reset_output = {}
--   vim.fn.jobstart({ "git", "reset", "--hard", "HEAD" }, {
--     stdout_buffered = true,
--     stderr_buffered = true,
--     on_stdout = function(_, data)
--       collect_output(reset_output, data)
--     end,
--     on_stderr = function(_, data)
--       collect_output(reset_output, data)
--     end,
--     on_exit = function()
--       spin.stop()
--       local lines = { "git reset --hard HEAD:" }
--       vim.list_extend(lines, reset_output)
--       vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
--     end,
--   })
-- end, { desc = "♻️ Сбросить все изменения" })

-- 📑 Навигация по изменениям
map("n", "]c", "]c", { desc = "➡ Следующий hunk (diff)" })
map("n", "[c", "[c", { desc = "⬅ Предыдущий hunk (diff)" })

-- 🧩 Для конфликтов/мержа (внутри merge view)
map("n", "ga", ":DiffviewToggleFiles<CR>", { desc = "🧩 Принять изменения (toggle panel)" })
-- Маппинги типа `:DiffviewFileHistory HEAD~3 -- path` можно добавлять вручную, если хочешь

-- 🛠️ Настройка визуала diff-окон (не hotkey, но полезно)
vim.opt.fillchars:append({ diff = " " }) -- диагональные полосы вместо пустых строк

vim.keymap.set("n", "gU", function()
  local buf, win = create_popup({ "git fetch & pull", "", "" })
  local spin = start_spinner(buf, 2)
  local branch = vim.fn.system("git rev-parse --abbrev-ref HEAD"):gsub("%s+", "")
  local fetch_output, pull_output = {}, {}

  vim.fn.jobstart({ "git", "fetch" }, {
    stdout_buffered = true,
    stderr_buffered = true,
    on_stdout = function(_, data)
      collect_output(fetch_output, data)
    end,
    on_stderr = function(_, data)
      collect_output(fetch_output, data)
    end,
    on_exit = function()
      vim.fn.jobstart({ "git", "pull", "origin", branch }, {
        stdout_buffered = true,
        stderr_buffered = true,
        on_stdout = function(_, data)
          collect_output(pull_output, data)
        end,
        on_stderr = function(_, data)
          collect_output(pull_output, data)
        end,
        on_exit = function()
          spin.stop()
          local changed_files = vim.fn.systemlist("git diff --name-status HEAD@{1} 2>&1")
          local lines = { "git fetch:" }
          vim.list_extend(lines, fetch_output)
          table.insert(lines, "")
          table.insert(lines, "git pull:")
          vim.list_extend(lines, pull_output)
          if #changed_files > 0 then
            table.insert(lines, "")
            table.insert(lines, "Changed files:")
            vim.list_extend(lines, changed_files)
          end
          vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
          local cfg = vim.api.nvim_win_get_config(win)
          cfg.height = math.min(#lines + 2, math.floor(vim.o.lines * 0.8))
          cfg.row = math.floor((vim.o.lines - cfg.height) / 2)
          vim.api.nvim_win_set_config(win, cfg)
        end,
      })
    end,
  })
end, { desc = "🔄 Fetch & Pull" })

vim.keymap.set("n", "gP", function()
  local buf = create_popup({ "git push", "", "" })
  local spin = start_spinner(buf, 2)
  local branch = vim.fn.system("git rev-parse --abbrev-ref HEAD"):gsub("%s+", "")
  vim.fn.system("git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>&1")
  local cmd
  if vim.v.shell_error ~= 0 then
    cmd = { "git", "push", "-u", "origin", branch }
  else
    cmd = { "git", "push" }
  end
  local push_output = {}
  vim.fn.jobstart(cmd, {
    stdout_buffered = true,
    stderr_buffered = true,
    on_stdout = function(_, data)
      collect_output(push_output, data)
    end,
    on_stderr = function(_, data)
      collect_output(push_output, data)
    end,
    on_exit = function()
      spin.stop()
      local lines = { "git push:" }
      vim.list_extend(lines, push_output)
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    end,
  })
end, { desc = "⤴️ Push current branch" })

-- Compare

vim.keymap.set("n", "gc", function()
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

-- Горячая клавиша gb: переключение на выбранную ветку
vim.keymap.set("n", "gb", function()
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

vim.keymap.set("n", "<C-b>", function()
  local branches = vim.fn.systemlist("git branch --all --format='%(refname:short)'")
  if vim.v.shell_error ~= 0 or vim.tbl_isempty(branches) then
    vim.notify("❌ Не удалось получить список веток", vim.log.levels.ERROR)
    return
  end

  local clean = {}
  for _, b in ipairs(branches) do
    b = b:gsub("^%*%s+", "")
    if not b:match("HEAD") and b ~= "" then
      table.insert(clean, b)
    end
  end

  table.sort(clean)

  vim.ui.select(clean, { prompt = "Скопировать ветку:" }, function(choice)
    if choice then
      vim.fn.setreg("+", choice)
      vim.notify("📋 Ветка скопирована: " .. choice, vim.log.levels.INFO)
    else
      vim.notify("Операция отменена", vim.log.levels.INFO)
    end
  end)
end, { desc = "🌿 Показать ветки" })

vim.keymap.set("n", "<leader>y", function()
  local branch = vim.fn.system("git rev-parse --abbrev-ref HEAD")
  if vim.v.shell_error ~= 0 then
    vim.notify("❌ Не удалось получить текущую ветку", vim.log.levels.ERROR)
    return
  end

  branch = branch:gsub("%s+", "")
  if branch == "" then
    vim.notify("❌ Не удалось получить текущую ветку", vim.log.levels.ERROR)
    return
  end

  vim.fn.setreg("+", branch)
  vim.notify("📋 Текущая ветка скопирована: " .. branch, vim.log.levels.INFO)
end, { desc = "🌿 Скопировать текущую ветку" })


vim.api.nvim_create_user_command("SmartBranch", function()
  local input = vim.fn.input("Branch name (new or existing): ")
  if input == "" then return end

  local branches = vim.fn.systemlist("git branch --list " .. input)
  if #branches == 0 then
    vim.fn.system({ "git", "checkout", "-b", input })
    print("Created and switched to new branch:", input)
  else
    vim.fn.system({ "git", "checkout", input })
    print("Switched to existing branch:", input)
  end
end, {})

vim.keymap.set("n", "gn", "<cmd>SmartBranch<cr>", { desc = "Smart Branch (Create/Switch)" })
vim.keymap.set("n", "ca", "<cmd>ColorizerAttachToBuffer<cr>", { desc = "Colorizer Attach" })

-- open file_browser with the path of the current buffer
vim.keymap.set("n", "<space>fb", ":Telescope file_browser path=%:p:h select_buffer=true<CR>")
vim.keymap.set("n", "<space>m", ":MarkdownPreviewToggle<CR>")
