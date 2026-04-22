return {
  {
    "mrcjkb/rustaceanvim",
    version = "*",
    ft = "rust",
    init = function()
      vim.g.rustaceanvim = {
        server = {
          default_settings = {
            ["rust-analyzer"] = {
              cargo = {
                allFeatures = true,
              },
              check = {
                command = "clippy",
              },
              procMacro = {
                enable = true,
              },
            },
          },
        },
      }
    end,
    keys = {
      { "<leader>lrr", "<cmd>RustLsp runnables<cr>", desc = "Rust runnables", ft = "rust" },
      { "<leader>lrd", "<cmd>RustLsp debuggables<cr>", desc = "Rust debuggables", ft = "rust" },
      { "<leader>lrh", "<cmd>RustLsp hover actions<cr>", desc = "Rust hover actions", ft = "rust" },
      { "<leader>lre", "<cmd>RustLsp expandMacro<cr>", desc = "Rust expand macro", ft = "rust" },
      { "<leader>lrc", "<cmd>RustLsp openCargo<cr>", desc = "Open Cargo.toml", ft = "rust" },
      { "<leader>lrp", "<cmd>RustLsp parentModule<cr>", desc = "Rust parent module", ft = "rust" },
      { "<leader>lrj", "<cmd>RustLsp joinLines<cr>", desc = "Rust join lines", ft = "rust" },
    },
  },
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
        "<leader>pu",
        function() require("crates").upgrade_crate() end,
        desc = "Upgrade crate",
        ft = "toml",
      },
      {
        "<leader>pc",
        function() require("crates").show_versions_popup() end,
        desc = "Pick crate version",
        ft = "toml",
      },
      {
        "<leader>pt",
        function() require("crates").toggle() end,
        desc = "Toggle crate info",
        ft = "toml",
      },
      {
        "<leader>pf",
        function() require("crates").show_features_popup() end,
        desc = "Crate features",
        ft = "toml",
      },
      {
        "<leader>po",
        function() require("crates").open_crates_io() end,
        desc = "Open crates.io page",
        ft = "toml",
      },
    },
  },
}
