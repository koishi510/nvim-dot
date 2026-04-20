return {
  {
    "tpope/vim-dadbod",
    cmd = { "DB" },
  },
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      "tpope/vim-dadbod",
    },
    cmd = {
      "DBUI",
      "DBUIToggle",
      "DBUIAddConnection",
      "DBUIFindBuffer",
    },
    init = function()
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_save_location = vim.fn.stdpath("data") .. "/dadbod-ui"
    end,
    keys = {
      { "<leader>dd", "<cmd>DBUIToggle<cr>", desc = "Toggle database UI" },
      { "<leader>da", "<cmd>DBUIAddConnection<cr>", desc = "Add database connection" },
      { "<leader>df", "<cmd>DBUIFindBuffer<cr>", desc = "Find database buffer" },
    },
  },
  {
    "kristijanhusak/vim-dadbod-completion",
    ft = { "sql", "mysql", "plsql" },
    dependencies = {
      "tpope/vim-dadbod",
      "kristijanhusak/vim-dadbod-ui",
    },
  },
  {
    "mistweaverco/kulala.nvim",
    ft = { "http", "rest" },
    opts = {
      global_keymaps = false,
      kulala_keymaps = true,
    },
    keys = {
      {
        "<leader>us",
        function()
          require("kulala").run()
        end,
        desc = "Send request",
        mode = { "n", "v" },
      },
      {
        "<leader>ua",
        function()
          require("kulala").run_all()
        end,
        desc = "Send all requests",
        mode = { "n", "v" },
        ft = { "http", "rest" },
      },
      {
        "<leader>ur",
        function()
          require("kulala").replay()
        end,
        desc = "Replay request",
      },
      {
        "<leader>uo",
        function()
          require("kulala").open()
        end,
        desc = "Open request UI",
      },
      {
        "<leader>uf",
        function()
          require("kulala").search()
        end,
        desc = "Find request",
        ft = { "http", "rest" },
      },
      {
        "<leader>ub",
        function()
          require("kulala").scratchpad()
        end,
        desc = "Request scratchpad",
      },
      {
        "<leader>uc",
        function()
          require("kulala").copy()
        end,
        desc = "Copy request as curl",
        ft = { "http", "rest" },
      },
    },
  },
}
