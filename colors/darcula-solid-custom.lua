vim.opt.background = 'dark'
vim.g.colors_name = 'darcula-solid-custom'

local lush = require('lush')
local darcula_solid = require('lush_theme.darcula-solid')

local spec = lush.extends({ darcula_solid }).with(function()
  local grey = lush.hsl(220, 10, 60)         -- приятный серый для путей
  local bg_highlight = lush.hsl(220, 15, 20) -- для выделений
  local white = lush.hsl(0, 0, 100)          -- белый цвет

  return {
    -- Базовый фон
    Normal { darcula_solid.Normal, bg = "none" },
    NormalNC { darcula_solid.NormalNC, bg = "none" },
    NormalFloat { darcula_solid.NormalFloat, bg = "none" },

    -- Столбцы, номера строк, конец буфера
    SignColumn { darcula_solid.SignColumn, bg = "none" },
    LineNr { darcula_solid.LineNr, bg = "none" },
    EndOfBuffer { darcula_solid.EndOfBuffer, bg = "none" },

    -- Telescope
    TelescopeNormal { fg = darcula_solid.Normal.fg, bg = "none" },
    TelescopeBorder { fg = grey, bg = "none" },
    TelescopeTitle { fg = darcula_solid.Normal.fg, bg = "none", bold = true },
    TelescopePromptNormal { fg = darcula_solid.Normal.fg, bg = "none" },

    -- ВАЖНО: пути/префиксы в списке результатов
    TelescopeResultsNormal { fg = darcula_solid.Normal.fg, bg = "none" }, -- общий текст
    TelescopeResultsComment { fg = darcula_solid.Normal.fg },             -- тусклые пути
    TelescopeResultsIdentifier { fg = darcula_solid.Normal.fg },
    TelescopeResultsNumber { fg = darcula_solid.Normal.fg },

    -- Выделение строки и совпадений
    TelescopeSelection { fg = darcula_solid.Normal.fg, bg = bg_highlight },
    TelescopeMatching { fg = darcula_solid.yellow, bold = true },

    -- Меню автодополнения
    Pmenu { fg = darcula_solid.Normal.fg, bg = bg_highlight },
    PmenuSel { fg = darcula_solid.Normal.fg, bg = grey, bold = true },

    -- BufferLine (если используешь)
    BufferLineFill { bg = "none" },
    BufferLineBackground { fg = grey, bg = "none" },
    BufferLineBufferSelected { fg = darcula_solid.Normal.fg, bg = "none", bold = true },
    Directory { fg = white },
  }
end)

lush(spec)
