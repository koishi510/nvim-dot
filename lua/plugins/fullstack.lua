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
      vim.g.db_ui_win_position = "left"
      vim.g.db_ui_winwidth = require("config.layout").left_width()
    end,
    keys = {
      { "<leader>Dd", "<cmd>DBUIToggle<cr>", desc = "Toggle database UI" },
      { "<leader>Da", "<cmd>DBUIAddConnection<cr>", desc = "Add database connection" },
      { "<leader>Df", "<cmd>DBUIFindBuffer<cr>", desc = "Find database buffer" },
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
      ui = {
        display_mode = "split",
        split_direction = "vertical",
        win_opts = {
          width = require("config.layout").right_width(),
          wo = {
            winfixwidth = true,
          },
        },
      },
    },
    keys = {
      {
        "<leader>lHs",
        function()
          require("kulala").run()
        end,
        desc = "Send request",
        mode = { "n", "v" },
        ft = { "http", "rest" },
      },
      {
        "<leader>lHa",
        function()
          require("kulala").run_all()
        end,
        desc = "Send all requests",
        mode = { "n", "v" },
        ft = { "http", "rest" },
      },
      {
        "<leader>lHr",
        function()
          require("kulala").replay()
        end,
        desc = "Replay request",
        ft = { "http", "rest" },
      },
      {
        "<leader>lHo",
        function()
          require("kulala").open()
        end,
        desc = "Open request UI",
        ft = { "http", "rest" },
      },
      {
        "<leader>lHf",
        function()
          require("kulala").search()
        end,
        desc = "Find request",
        ft = { "http", "rest" },
      },
      {
        "<leader>lHb",
        function()
          require("kulala").scratchpad()
        end,
        desc = "Request scratchpad",
        ft = { "http", "rest" },
      },
      {
        "<leader>lHc",
        function()
          require("kulala").copy()
        end,
        desc = "Copy request as curl",
        ft = { "http", "rest" },
      },
    },
  },
}

}
