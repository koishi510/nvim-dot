return {
  {
    "barrett-ruth/live-server.nvim",
    ft = { "html", "css", "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
    cmd = {
      "LiveServerStart",
      "LiveServerStop",
      "LiveServerToggle",
    },
    keys = {
      { "<leader>hh", "<cmd>LiveServerToggle<cr>", desc = "Toggle HTML preview" },
      { "<leader>hs", "<cmd>LiveServerStart<cr>", desc = "Start HTML preview" },
      { "<leader>hS", "<cmd>LiveServerStop<cr>", desc = "Stop HTML preview" },
    },
  },
  {
    "windwp/nvim-ts-autotag",
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
  },
  {
    "olrtg/nvim-emmet",
    keys = {
      {
        "<leader>he",
        function()
          require("nvim-emmet").wrap_with_abbreviation()
        end,
        desc = "Emmet wrap",
        mode = { "n", "v" },
      },
    },
  },
  {
    "vuki656/package-info.nvim",
    ft = "json",
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {
      autostart = true,
      hide_up_to_date = false,
    },
  },
  {
    "brenoprata10/nvim-highlight-colors",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      render = "virtual",
      virtual_symbol = "■",
      enable_named_colors = true,
      enable_tailwind = true,
    },
  },
}
