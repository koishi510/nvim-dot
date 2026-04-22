return {
  {
    "ibhagwan/smartyank.nvim",
    event = "TextYankPost",
    opts = {
      highlight = {
        enabled = false,
      },
      clipboard = {
        enabled = true,
      },
      tmux = {
        enabled = vim.env.TMUX ~= nil,
        cmd = { "tmux", "set-buffer", "-w" },
      },
      osc52 = {
        enabled = true,
        ssh_only = true,
        silent = true,
      },
      validate_yank = false,
    },
    config = function(_, opts)
      require("smartyank").setup(opts)
    end,
  },
  {
    "keaising/im-select.nvim",
    event = "VeryLazy",
    config = function()
      require("im_select").setup({
        default_im_select = "keyboard-us",
        default_command = "fcitx5-remote",
        set_default_events = { "InsertLeave", "CmdlineLeave" },
        set_previous_events = { "InsertEnter" },
        keep_quiet_on_no_binary = true,
        async_switch_im = true,
      })
    end,
  },
}
