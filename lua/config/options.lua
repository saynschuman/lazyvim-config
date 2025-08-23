-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.o.statusline = "%{system('git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d \"\\n\"')}"
