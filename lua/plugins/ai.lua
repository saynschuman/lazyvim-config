return {
  "jackMort/ChatGPT.nvim",
  enabled = false,
  event = "VeryLazy",
  config = function()
    require("chatgpt").setup({
      api_key_cmd = "cat " .. vim.fn.expand("~/.config/openai/key"),
      actions_paths = { vim.fn.stdpath("config") .. "/lua/chatgpt_actions.json" },
      openai_params = {
        model = "gpt-4o",
        temperature = 0.2,
        top_p = 0.1,
        max_tokens = 4095,
        n = 1,
        frequency_penalty = 0,
        presence_penalty = 0,
      },
      -- фикс заголовков
      popup_window = {
        title = "ChatGPT",
        border = { style = "rounded" },
      },
      popup_input = {
        title = "Prompt",
        border = { style = "rounded" },
      },
      -- sessions_window = {
      --   border = { style = "rounded", title = "Sessions" },
      -- },
      -- sessions_dir = vim.fn.stdpath("data") .. "/chatgpt_sessions", -- папка для истории
    })
  end,
  dependencies = {
    "MunifTanjim/nui.nvim",
    "nvim-lua/plenary.nvim",
    "folke/trouble.nvim", -- optional
    "nvim-telescope/telescope.nvim",
  },
  keys = {
    { "<leader>ac", "<cmd>ChatGPT<CR>",                              desc = "ChatGPT" },
    { "<leader>ae", "<cmd>ChatGPTEditWithInstruction<CR>",           mode = { "n", "v" }, desc = "Edit with instruction" },
    { "<leader>ag", "<cmd>ChatGPTRun grammar_correction<CR>",        mode = { "n", "v" }, desc = "Grammar Correction" },
    { "<leader>at", "<cmd>ChatGPTRun translate<CR>",                 mode = { "n", "v" }, desc = "Translate" },
    { "<leader>ak", "<cmd>ChatGPTRun keywords<CR>",                  mode = { "n", "v" }, desc = "Keywords" },
    { "<leader>ad", "<cmd>ChatGPTRun docstring<CR>",                 mode = { "n", "v" }, desc = "Docstring" },
    { "<leader>aa", "<cmd>ChatGPTRun add_tests<CR>",                 mode = { "n", "v" }, desc = "Add Tests" },
    { "<leader>ao", "<cmd>ChatGPTRun optimize_code<CR>",             mode = { "n", "v" }, desc = "Optimize Code" },
    { "<leader>as", "<cmd>ChatGPTRun summarize<CR>",                 mode = { "n", "v" }, desc = "Summarize" },
    { "<leader>af", "<cmd>ChatGPTRun fix_bugs<CR>",                  mode = { "n", "v" }, desc = "Fix Bugs" },
    { "<leader>ax", "<cmd>ChatGPTRun explain_code<CR>",              mode = { "n", "v" }, desc = "Explain Code" },
    { "<leader>ar", "<cmd>ChatGPTRun roxygen_edit<CR>",              mode = { "n", "v" }, desc = "Roxygen Edit" },
    { "<leader>al", "<cmd>ChatGPTRun code_readability_analysis<CR>", mode = { "n", "v" }, desc = "Code Readability Analysis" },
    {
      "<leader>aq",
      function()
        local arg = vim.fn.input("Запрос для ИИ: ")
        if arg and arg ~= "" then
          vim.cmd('ChatGPTRun ask_display ' .. vim.fn.shellescape(arg))
        end
      end,
      mode = { "n", "v" },
      desc = "AI: спросить по выделению (popup)"
    },

    {
      "<leader>ar",
      function()
        local arg = vim.fn.input("Как преобразовать выделение? ")
        if arg and arg ~= "" then
          vim.cmd('ChatGPTRun ask_replace ' .. vim.fn.shellescape(arg))
        end
      end,
      mode = { "v" },
      desc = "AI: преобразовать выделение (replace)"
    }, }
}
