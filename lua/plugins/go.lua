return {
  {
    "ray-x/go.nvim",
    ft = { "go", "gomod", "gowork", "gotmpl" },
    dependencies = {
      "ray-x/guihua.lua",
    },
    opts = {
      icons = false,
      diagnostic = false,
      lsp_cfg = false,
      lsp_keymaps = false,
      lsp_codelens = false,
      lsp_document_formatting = false,
      lsp_inlay_hints = {
        enable = false,
      },
      dap_debug = false,
      dap_debug_keymap = false,
      trouble = true,
      luasnip = false,
      run_in_floaterm = false,
      textobjects = false,
    },
    config = function(_, opts)
      require("go").setup(opts)
    end,
    keys = {
      { "<leader>lgt", "<cmd>GoTest<cr>", desc = "Go test package", ft = "go" },
      { "<leader>lgT", "<cmd>GoTestFunc<cr>", desc = "Go test function", ft = "go" },
      { "<leader>lgc", "<cmd>GoCoverage<cr>", desc = "Go coverage", ft = "go" },
      { "<leader>lgf", "<cmd>GoFillStruct<cr>", desc = "Go fill struct", ft = "go" },
      { "<leader>lgs", "<cmd>GoFillSwitch<cr>", desc = "Go fill switch", ft = "go" },
      { "<leader>lgi", "<cmd>GoIfErr<cr>", desc = "Go if err", ft = "go" },
      { "<leader>lgI", "<cmd>GoImpl<cr>", desc = "Go impl", ft = "go" },
      { "<leader>lga", "<cmd>GoAddTag<cr>", desc = "Go add tags", ft = "go" },
      { "<leader>lgr", "<cmd>GoRmTag<cr>", desc = "Go remove tags", ft = "go" },
      { "<leader>lgm", "<cmd>GoModTidy<cr>", desc = "Go mod tidy", ft = { "go", "gomod" } },
    },
  },
}
