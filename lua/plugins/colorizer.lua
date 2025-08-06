return {
  {
    "norcalli/nvim-colorizer.lua",
    event = { "BufReadPre", "BufNewFile" }, -- Lazy-load на чтение/создание файла
    config = function()
      require("colorizer").setup({
        "*",                                     -- Применить кo всем типам файлов
        css = { rgb_fn = true },                 -- включить поддержку rgb(...) в css
        sass = { rgb_fn = true, hsl_fn = true }, -- включить поддержку rgb(...) в css
        scss = { rgb_fn = true, hsl_fn = true }, -- включить поддержку rgb(...) в css
        html = { names = false },                -- отключить цветовые названия в html
        "!vim",                                  -- исключить vim-файлы
      }, {
        mode = "foreground",                     -- общий режим отображения
      })

      -- Альтернативно можно вызвать это вручную, если хотите контроль над активацией
      -- vim.cmd("ColorizerAttachToBuffer")
    end,
  },
}
