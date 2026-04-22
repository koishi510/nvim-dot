return {
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      modes = {
        qflist = {
          win = {
            relative = "win",
            position = "bottom",
            size = 12,
          },
        },
      },
    },
    keys = {
      {
        "<leader>xx",
        function()
          require("config.layout").toggle_trouble_bottom("diagnostics")
        end,
        desc = "Toggle diagnostics",
      },
      {
        "<leader>xX",
        function()
          require("config.layout").toggle_trouble_bottom("diagnostics", { filter = { buf = 0 } })
        end,
        desc = "Buffer diagnostics",
      },
      {
        "<leader>xq",
        function()
          require("config.layout").open_trouble_qflist()
        end,
        desc = "Open quickfix",
      },
      {
        "<leader>xl",
        function()
          require("config.layout").toggle_trouble_bottom("loclist")
        end,
        desc = "Toggle location list",
      },
      {
        "<leader>xs",
        function()
          require("config.layout").toggle_trouble_right("symbols", { focus = false })
        end,
        desc = "Toggle symbols",
      },
    },
  },
  {
    "mg979/vim-visual-multi",
    branch = "master",
    event = "VeryLazy",
  },
}
