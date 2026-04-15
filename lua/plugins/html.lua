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
      { "<leader>hp", "<cmd>LiveServerStart<cr>", desc = "Start HTML preview" },
      { "<leader>hP", "<cmd>LiveServerStop<cr>", desc = "Stop HTML preview" },
      { "<leader>ht", "<cmd>LiveServerToggle<cr>", desc = "Toggle HTML preview" },
    },
  },
}
