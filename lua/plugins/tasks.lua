return {
  {
    "stevearc/overseer.nvim",
    cmd = {
      "OverseerRun",
      "OverseerToggle",
      "OverseerRestartLast",
      "OverseerQuickAction",
    },
    opts = {},
    keys = {
      { "<leader>rr", "<cmd>OverseerRun<cr>", desc = "Run task" },
      { "<leader>rt", "<cmd>OverseerToggle<cr>", desc = "Toggle tasks" },
      { "<leader>rl", "<cmd>OverseerRestartLast<cr>", desc = "Restart task" },
      { "<leader>ra", "<cmd>OverseerQuickAction<cr>", desc = "Task actions" },
    },
  },
}
