-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
vim.keymap.set("n", "gI", vim.lsp.buf.implementation, { noremap = true, silent = true })
