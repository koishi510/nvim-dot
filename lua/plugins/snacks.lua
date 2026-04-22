return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    config = function(_, opts)
      _G.Snacks = require("snacks")
      _G.Snacks.setup(opts)

      if not _G.Snacks.util._icon_basename_patched then
        _G.Snacks.util._icon_basename_patched = true
        local icon = _G.Snacks.util.icon
        _G.Snacks.util.icon = function(name, cat, icon_opts)
          if cat == "file" and type(name) == "string" then
            name = vim.fs.basename(name)
          end
          return icon(name, cat, icon_opts)
        end
      end
    end,
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
      explorer = { enabled = false },
      gitbrowse = { enabled = true },
      indent = { enabled = true },
      input = { enabled = true },
      lazygit = {
        enabled = true,
        configure = true,
        win = {
          style = "lazygit",
        },
      },
      notifier = {
        enabled = true,
        timeout = 3000,
        width = { min = 28, max = 90 },
        height = { min = 1, max = 0.6 },
      },
      picker = { enabled = false },
      quickfile = { enabled = true },
      scope = { enabled = true },
      scratch = { enabled = true },
      scroll = { enabled = true },
      statuscolumn = { enabled = true },
      styles = {
        notification = {
          border = "rounded",
          wo = { wrap = true },
        },
        input = {
          relative = "editor",
          row = 0.35,
          col = 0.5,
          width = 60,
          border = "rounded",
        },
        lazygit = {
          border = "rounded",
          width = 0.92,
          height = 0.9,
        },
        terminal = {
          border = "rounded",
        },
      },
      terminal = { enabled = false },
      words = { enabled = true },
      zen = { enabled = true },
    },
    keys = {
      {
        "<leader>gg",
        function()
          local root = require("config.root")
          local cwd = root.buf_git_root() or root.start_dir
          Snacks.lazygit({ cwd = cwd })
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
        "<leader>z",
        function()
          Snacks.zen()
        end,
        desc = "Zen mode",
      },
      {
        "<leader>z.",
        function()
          Snacks.scratch()
        end,
        desc = "Scratch",
      },
      {
        "<leader>zs",
        function()
          Snacks.scratch.select()
        end,
        desc = "Scratch list",
      },
      {
        "<leader>xn",
        function()
          Snacks.notifier.show_history()
        end,
        desc = "Show notifications",
      },
      {
        "<leader>xN",
        function()
          Snacks.notifier.hide()
        end,
        desc = "Dismiss notifications",
      },
      {
        "]r",
        function()
          Snacks.words.jump(vim.v.count1)
        end,
        desc = "Next reference",
        mode = { "n", "t" },
      },
      {
        "[r",
        function()
          Snacks.words.jump(-vim.v.count1)
        end,
        desc = "Previous reference",
        mode = { "n", "t" },
      },
    },
  },
}
