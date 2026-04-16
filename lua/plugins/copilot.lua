return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      suggestion = {
        enabled = true,
        auto_trigger = true,
        keymap = {
          accept = "<S-CR>",
          next = "]a",
          prev = "[a",
        },
      },
      panel = {
        enabled = false,
      },
    },
  },
}
