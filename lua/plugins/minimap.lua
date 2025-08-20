-- ~/.config/nvim/lua/plugins/minimap.lua
return {
  {
    "wfxr/minimap.vim",
    build = "cargo install --locked code-minimap",
    cmd = { "Minimap", "MinimapToggle", "MinimapClose", "MinimapRefresh", "MinimapUpdateHighlight", "MinimapRescan" },
    keys = {
      { "<leader>um", "<cmd>MinimapToggle<cr>", desc = "Toggle Minimap" },
    },
    init = function()
      vim.g.minimap_width = 10
      vim.g.minimap_highlight_range = 1
      vim.g.minimap_highlight_search = 1
      vim.g.minimap_auto_start = 0
      vim.g.minimap_auto_start_win_enter = 1
    end,
  },
}
