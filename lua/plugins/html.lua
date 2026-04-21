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
      {
        "<leader>hh",
        function()
          local root = require("config.root")
          require("live-server").toggle(root.buf_project_root() or root.start_dir)
        end,
        desc = "Toggle HTML preview",
      },
      {
        "<leader>hs",
        function()
          local root = require("config.root")
          require("live-server").start(root.buf_project_root() or root.start_dir)
        end,
        desc = "Start HTML preview",
      },
      {
        "<leader>hS",
        function()
          local root = require("config.root")
          require("live-server").stop(root.buf_project_root() or root.start_dir)
        end,
        desc = "Stop HTML preview",
      },
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
    keys = {
      {
        "<leader>Pu",
        function() require("package-info").update() end,
        desc = "Update package",
        ft = "json",
      },
      {
        "<leader>Pc",
        function() require("package-info").change_version() end,
        desc = "Change version",
        ft = "json",
      },
      {
        "<leader>Pd",
        function() require("package-info").delete() end,
        desc = "Delete package",
        ft = "json",
      },
      {
        "<leader>Pi",
        function() require("package-info").install() end,
        desc = "Install package",
        ft = "json",
      },
      {
        "<leader>Pt",
        function() require("package-info").toggle() end,
        desc = "Toggle package info",
        ft = "json",
      },
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
