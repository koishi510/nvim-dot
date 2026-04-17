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
      { "<leader>ph", "<cmd>LiveServerToggle<cr>", desc = "Preview HTML" },
    },
  },
}
