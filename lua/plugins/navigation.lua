return {
  {
    "Bekaboo/dropbar.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      bar = {
        hover = false,
        truncate = true,
        pick = {
          pivots = "etovxqpdygfblzhckisuran",
        },
      },
      icons = {
        enable = true,
      },
    },
    config = function(_, opts)
      require("dropbar").setup(opts)
    end,
    keys = {
      {
        "<leader>cb",
        function()
          require("dropbar.api").pick()
        end,
        desc = "Pick breadcrumb",
      },
      {
        "<leader>cB",
        function()
          require("dropbar.api").goto_context_start()
        end,
        desc = "Breadcrumb context start",
      },
      {
        "]b",
        function()
          require("dropbar.api").select_next_context()
        end,
        desc = "Next breadcrumb context",
      },
      {
        "[b",
        function()
          require("dropbar.api").goto_context_start()
        end,
        desc = "Breadcrumb context start",
      },
    },
  },
}
