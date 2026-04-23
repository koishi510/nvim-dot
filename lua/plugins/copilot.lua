return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    keys = {
      { "<leader>at", "<cmd>Copilot toggle<cr>", desc = "Toggle Copilot" },
    },
    opts = {
      suggestion = {
        enabled = true,
        auto_trigger = true,
        keymap = {
          accept = "<A-y>",
          next = "<A-]>",
          prev = "<A-[>",
        },
      },
      panel = {
        enabled = false,
      },
    },
  },
}
