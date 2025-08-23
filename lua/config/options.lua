-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.cmd([[
  hi GitBranch guifg=#89b4fa guibg=NONE
  hi SLPos guifg=#a6e3a1 guibg=NONE
]])

vim.o.statusline =
    "%#GitBranch# %{system('git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d \"\\n\"')} "
    .. "%=%#SLPos#%l:%c"
