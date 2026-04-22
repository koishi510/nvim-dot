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
        "<leader>lhh",
        function()
          local root = require("config.root")
          require("live-server").toggle(root.buf_project_root() or root.start_dir)
        end,
        desc = "Toggle HTML preview",
        ft = { "html", "css", "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
      },
      {
        "<leader>lhs",
        function()
          local root = require("config.root")
          require("live-server").start(root.buf_project_root() or root.start_dir)
        end,
        desc = "Start HTML preview",
        ft = { "html", "css", "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
      },
      {
        "<leader>lhS",
        function()
          local root = require("config.root")
          require("live-server").stop(root.buf_project_root() or root.start_dir)
        end,
        desc = "Stop HTML preview",
        ft = { "html", "css", "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
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
        "<leader>lhe",
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
        "<leader>pu",
        function() require("package-info").update() end,
        desc = "Update package",
        ft = "json",
      },
      {
        "<leader>pc",
        function() require("package-info").change_version() end,
        desc = "Change version",
        ft = "json",
      },
      {
        "<leader>pd",
        function() require("package-info").delete() end,
        desc = "Delete package",
        ft = "json",
      },
      {
        "<leader>pi",
        function() require("package-info").install() end,
        desc = "Install package",
        ft = "json",
      },
      {
        "<leader>pt",
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
