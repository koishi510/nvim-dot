return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      bigfile = { enabled = true },
      dashboard = {
        enabled = true,
        preset = {
          header = table.concat({
            "⠀⠀⠀⠀⠀⠀⠈⠉⠛⠻⠿⣿⣿⣿⣷⣤⣔⡺⢿⣿⣶⣤⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠻⣿⣿⣿⣿⣿⣿⣿",
            "⠀⠀⠀⠀⠀⠈⣦⡀⠀⠀⠀⠀⠈⠉⠛⠿⢿⣿⣷⣮⣝⡻⢿⣿⣷⣦⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⣿⣿⣿⣿⣿",
            "⠀⠀⠀⠀⠀⠀⠘⠻⠳⠦⠀⠀⠀⢀⡀⠀⠀⠌⡙⠻⢿⣿⣷⣬⣛⠿⣿⣿⣦⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢻⣿⣿⣿",
            "⠀⠀⠀⠀⠀⠀⠀⠀⠈⠐⠂⠤⠄⠀⡠⠆⠐⠃⠈⠑⠠⡀⠈⠙⠻⣷⣮⡙⠿⣿⣿⣦⡀⠀⠀⠀⠀⢀⣠⣤⣤⡀⠀⠀⠹⣿⣿",
            "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠔⠋⠀⢀⣀⣀⠀⠀⠀⠀⠑⠠⡀⠈⠙⠻⢷⣬⡉⠀⠈⠀⠀⣠⣶⣿⣿⣿⣿⣿⡄⠀⠀⠹⣿",
            "⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⣷⣾⣿⣿⣿⣿⣿⣿⣿⣣⣾⣶⣦⣤⡁⠀⠀⠀⠙⠻⣷⣄⡠⣾⣿⣿⣿⣿⣿⣿⣿⣇⠀⠀⠀⢿",
            "⠀⠀⠀⠀⠀⠀⠀⠀⣰⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣄⠀⠀⠀⠀⠙⠿⣮⣻⣿⣿⣿⣿⣿⣿⣿⢀⣠⣤⣶",
            "⠀⠀⠀⠀⠀⠀⠀⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⠀⡀⠀⠀⠀⠈⠻⣮⣿⣿⣿⣿⣿⡇⢸⣿⣿⣿",
            "⠀⠀⠀⠀⠀⠀⣼⣿⣿⣿⣿⣿⣿⣿⡿⠻⢿⣿⢡⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⢸⣿⣷⡀⣢⡀⠀⠈⠹⣟⢿⣿⣿⠃⣿⣿⣿⣿",
            "⠀⠀⠀⠀⠀⢰⣿⣿⣿⣿⣿⡏⣾⣿⣿⣾⣿⣏⣸⣿⣿⣿⣿⣿⣿⣿⣿⣿⢹⠸⣿⣿⣧⣿⣿⡆⠀⠀⠈⠳⡙⢡⢸⣿⣿⣿⣿",
            "⠀⠀⠀⠀⢀⡿⢻⣿⣿⣿⣿⣧⣿⠿⠛⠛⢿⣿⣿⣿⣿⣿⣿⣿⣿⡿⣿⡟⠸⣄⢿⣿⣿⣿⣿⣿⣦⠀⠀⠀⠙⣆⠻⣿⣿⣿⣿",
            "⠀⠀⠀⠀⢸⠃⢸⣿⣿⣿⣿⠿⠁⣠⣤⠤⠀⢹⣿⡏⢿⣿⣿⣿⣿⢡⠟⠑⠉⠛⠸⣿⡏⣿⣿⣿⣿⡇⠀⠀⠀⠈⢧⡙⠿⠛⠁",
            "⡀⠀⠀⠀⡏⠀⠈⣿⣿⣿⣿⢠⣾⣿⠛⠀⠀⣻⣿⣷⣘⣿⣿⣿⡏⣀⣰⡞⠉⠲⡄⠘⠃⣿⣿⣿⣿⢣⠀⠈⢀⠀⠈⢳⡀⠀⠀",
            "⣿⣷⣄⠀⠃⠀⢠⡹⣿⣷⠸⡟⣿⣿⢺⣬⣦⣿⣿⣿⣿⣾⣿⣟⣾⣿⡏⢀⣀⠀⣿⠀⠀⣿⣿⣿⣿⣾⡄⠀⠀⠠⠀⠀⢻⡄⢠",
            "⣿⣿⣿⡇⢠⢀⣿⣷⣿⣿⠀⣿⣿⣿⣷⣷⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣟⣾⣷⣿⡞⣸⣿⣿⣿⣿⣿⡇⠀⠀⠀⠐⠀⠀⠹⣌",
            "⣿⣿⣿⣿⡞⣸⣿⣿⣿⣿⡇⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣿⡿⣱⣿⣿⣿⣿⣿⣿⡟⠀⠀⠀⠀⠈⢀⠀⠹",
            "⣿⣿⣿⣿⢡⣿⣿⣿⣿⣿⣿⠈⢿⣿⣿⣿⣿⣿⣹⣿⣿⣿⣷⡽⣿⣿⣿⣿⣿⢟⠵⣻⣿⣿⣿⣿⣿⣿⠁⠀⠀⠀⠀⠀⠀⠀⠀",
            "⣿⣿⣿⠇⣿⣿⣿⣿⣿⣿⡇⣰⣄⠙⢿⣿⣿⣿⣿⣿⣿⣿⣿⣱⣿⣿⣿⣫⢅⣠⣾⣿⣿⣿⣿⣿⣿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀",
            "⣿⣿⣿⢰⣿⢿⣿⣿⡿⣿⡇⣿⣿⡟⣤⣉⠻⢿⣿⣿⣿⣿⣿⣿⣿⡿⢋⣵⣿⣿⣿⣿⣿⣿⣿⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
            "⣿⣿⣿⢸⣧⢸⣿⠏⣀⢹⡇⣿⣟⡾⠟⠋⠁⠀⠉⠛⠉⢉⣉⡤⢀⣴⣿⣿⣿⣿⣿⣿⣿⡿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
            "⣿⣿⣿⣮⣿⡜⣿⠘⠛⠋⢷⠘⠉⠀⠀⠀⠀⣀⣾⣿⡿⢟⠋⣰⣿⣿⣿⡿⠟⡫⣾⢟⠁⣠⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
            "⣿⣿⣿⣿⣿⠟⣹⠀⠀⠀⠈⠣⠀⠀⠀⠀⣿⣿⣿⡫⢖⠋⣼⡿⢛⡋⠁⠒⠋⠈⠀⠁⠚⠻⠿⠳⣦⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
          }, "\n"),
        },
        sections = {
          { section = "header", padding = 1 },
          {
            section = "keys",
            gap = 1,
            padding = 1,
            icons = {
              enabled = true,
            },
          },
          { section = "startup" },
        },
      },
      explorer = { enabled = true },
      gitbrowse = { enabled = true },
      indent = { enabled = true },
      input = { enabled = true },
      lazygit = { enabled = true },
      notifier = { enabled = true, timeout = 3000 },
      picker = { enabled = true },
      quickfile = { enabled = true },
      scope = { enabled = true },
      scratch = { enabled = true },
      scroll = { enabled = true },
      statuscolumn = { enabled = true },
      terminal = { enabled = true },
      words = { enabled = true },
      zen = { enabled = true },
    },
    keys = {
      {
        "<leader>e",
        function()
          Snacks.explorer()
        end,
        desc = "Toggle explorer",
      },
      {
        "<leader>ff",
        function()
          Snacks.picker.files()
        end,
        desc = "Find files",
      },
      {
        "<leader>fg",
        function()
          Snacks.picker.grep()
        end,
        desc = "Live grep",
      },
      {
        "<leader>fb",
        function()
          Snacks.picker.buffers()
        end,
        desc = "Find buffers",
      },
      {
        "<leader>fh",
        function()
          Snacks.picker.help()
        end,
        desc = "Help tags",
      },
      {
        "<leader>fr",
        function()
          Snacks.picker.recent()
        end,
        desc = "Recent files",
      },
      {
        "<leader>hc",
        function()
          Snacks.picker.keymaps()
        end,
        desc = "Keymaps",
      },
      {
        "<leader>gg",
        function()
          Snacks.lazygit()
        end,
        desc = "Open lazygit",
      },
      {
        "<leader>gB",
        function()
          Snacks.gitbrowse()
        end,
        desc = "Git browse",
        mode = { "n", "x" },
      },
      {
        "<leader>tt",
        function()
          Snacks.terminal()
        end,
        desc = "Float terminal",
      },
      {
        "<leader>th",
        function()
          Snacks.terminal(nil, { win = { position = "bottom", height = 0.3 } })
        end,
        desc = "Horizontal terminal",
      },
      {
        "<leader>tv",
        function()
          Snacks.terminal(nil, { win = { position = "right", width = 0.4 } })
        end,
        desc = "Vertical terminal",
      },
      {
        "<leader>tg",
        function()
          Snacks.terminal("lazygit")
        end,
        desc = "Terminal lazygit",
      },
      {
        "<leader>z",
        function()
          Snacks.zen()
        end,
        desc = "Toggle zen",
      },
      {
        "<leader>.",
        function()
          Snacks.scratch()
        end,
        desc = "Toggle scratch",
      },
      {
        "<leader>S",
        function()
          Snacks.scratch.select()
        end,
        desc = "Scratch list",
      },
      {
        "<leader>nh",
        function()
          Snacks.notifier.show_history()
        end,
        desc = "Notification history",
      },
      {
        "<leader>nd",
        function()
          Snacks.notifier.hide()
        end,
        desc = "Dismiss notifications",
      },
      {
        "]]",
        function()
          Snacks.words.jump(vim.v.count1)
        end,
        desc = "Next reference",
        mode = { "n", "t" },
      },
      {
        "[[",
        function()
          Snacks.words.jump(-vim.v.count1)
        end,
        desc = "Prev reference",
        mode = { "n", "t" },
      },
    },
  },
}
