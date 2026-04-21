return {
  {
    "Saecki/crates.nvim",
    ft = "toml",
    event = { "BufRead Cargo.toml" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      completion = {
        cmp = { enabled = true },
      },
    },
    keys = {
      {
        "<leader>Pu",
        function() require("crates").upgrade_crate() end,
        desc = "Upgrade crate",
        ft = "toml",
      },
      {
        "<leader>Pc",
        function() require("crates").show_versions_popup() end,
        desc = "Pick crate version",
        ft = "toml",
      },
      {
        "<leader>Pt",
        function() require("crates").toggle() end,
        desc = "Toggle crate info",
        ft = "toml",
      },
      {
        "<leader>Pf",
        function() require("crates").show_features_popup() end,
        desc = "Crate features",
        ft = "toml",
      },
      {
        "<leader>Po",
        function() require("crates").open_crates_io() end,
        desc = "Open crates.io page",
        ft = "toml",
      },
    },
  },
}
