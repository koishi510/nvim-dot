return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    cmd = {
      "ToggleTerm",
      "ToggleTermSetName",
      "ToggleTermToggleAll",
      "ToggleTermSendCurrentLine",
      "ToggleTermSendVisualLines",
      "ToggleTermSendVisualSelection",
    },
    opts = {
      shade_terminals = false,
      start_in_insert = true,
      persist_size = true,
      persist_mode = true,
      close_on_exit = false,
      float_opts = {
        border = "rounded",
      },
      highlights = {
        FloatBorder = {
          link = "FloatBorder",
        },
      },
    },
    keys = {
      {
        "<leader>tt",
        function()
          require("config.terminal").float()
        end,
        desc = "Floating terminal",
      },
      {
        "<leader>th",
        function()
          require("config.terminal").horizontal()
        end,
        desc = "Horizontal terminal",
      },
      {
        "<leader>tv",
        function()
          require("config.terminal").vertical()
        end,
        desc = "Vertical terminal",
      },
    },
  },
}
