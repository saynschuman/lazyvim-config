return {
  "lewis6991/gitsigns.nvim",
  enabled = true,
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    signs                        = {
      add          = { text = '┃' },
      change       = { text = '┃' },
      delete       = { text = '_' },
      topdelete    = { text = '‾' },
      changedelete = { text = '~' },
      untracked    = { text = '┆' },
    },
    signs_staged                 = {
      add          = { text = '┃' },
      change       = { text = '┃' },
      delete       = { text = '_' },
      topdelete    = { text = '‾' },
      changedelete = { text = '~' },
      untracked    = { text = '┆' },
    },
    signs_staged_enable          = true,
    signcolumn                   = true,
    numhl                        = false,
    linehl                       = false,
    word_diff                    = false,
    watch_gitdir                 = {
      follow_files = true,
    },
    auto_attach                  = true,
    attach_to_untracked          = false,
    current_line_blame           = false,
    current_line_blame_opts      = {
      virt_text = true,
      virt_text_pos = 'eol',
      delay = 1000,
      ignore_whitespace = false,
      virt_text_priority = 100,
      use_focus = true,
    },
    current_line_blame_formatter = '<author>, <author_time:%R> - <summary>',
    sign_priority                = 6,
    update_debounce              = 100,
    max_file_length              = 40000,
    preview_config               = {
      style = 'minimal',
      relative = 'cursor',
      row = 0,
      col = 1,
    },
    on_attach                    = function(bufnr)
      local gs = require("gitsigns")

      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      -- Navigation
      map('n', ']c', function()
        if vim.wo.diff then
          vim.cmd.normal({ ']c', bang = true })
        else
          gs.nav_hunk('next')
        end
      end)

      map('n', '[c', function()
        if vim.wo.diff then
          vim.cmd.normal({ '[c', bang = true })
        else
          gs.nav_hunk('prev')
        end
      end)

      -- Actions
      map('n', '<leader>hs', gs.stage_hunk, { desc = "Stage Hunk" })
      map('n', '<leader>hr', gs.reset_hunk, { desc = "Reset Hunk" })
      map('v', '<leader>hs', function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end,
        { desc = "Stage Hunk (Visual)" })
      map('v', '<leader>hr', function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end,
        { desc = "Reset Hunk (Visual)" })
      map('n', '<leader>hS', gs.stage_buffer, { desc = "Stage Buffer" })
      map('n', '<leader>hR', gs.reset_buffer, { desc = "Reset Buffer" })
      map('n', '<leader>hp', gs.preview_hunk, { desc = "Preview Hunk" })
      map('n', '<leader>hi', gs.preview_hunk_inline, { desc = "Inline Hunk Preview" })
      map('n', '<leader>hb', function() gs.blame_line({ full = true }) end, { desc = "Blame Line (Full)" })
      map('n', '<leader>hd', gs.diffthis, { desc = "Diff This" })
      map('n', '<leader>hD', function() gs.diffthis('~') end, { desc = "Diff This ~" })
      map('n', '<leader>hQ', function() gs.setqflist('all') end, { desc = "Hunks to Quickfix (All)" })
      map('n', '<leader>hq', gs.setqflist, { desc = "Hunks to Quickfix (Visible)" })

      -- Toggles
      map('n', '<leader>tb', gs.toggle_current_line_blame, { desc = "Toggle Line Blame" })
      map('n', '<leader>tw', gs.toggle_word_diff, { desc = "Toggle Word Diff" })

      -- Text object
      map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = "Select Git Hunk" })
    end,
  },
}
