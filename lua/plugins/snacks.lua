local function main_window()
  local function is_main_window(win)
    if vim.api.nvim_win_get_config(win).relative ~= "" then
      return false
    end

    local buf = vim.api.nvim_win_get_buf(win)
    local buftype = vim.bo[buf].buftype
    local filetype = vim.bo[buf].filetype

    return buftype ~= "terminal" and filetype ~= "snacks_layout_box" and filetype ~= "snacks_terminal"
  end

  local current = vim.api.nvim_get_current_win()
  if is_main_window(current) then
    return current
  end

  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if is_main_window(win) then
      return win
    end
  end

  return current
end

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
      explorer = {
        enabled = true,
        replace_netrw = true,
        layout = {
          layout = {
            position = "left",
            width = 30,
          },
        },
        win = {
          border = "none",
        },
      },
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
      picker = {
        enabled = true,
        layout = {
          preset = "telescope",
          cycle = false,
        },
        win = {
          input = {
            border = "rounded",
            keys = {
              ["<Esc>"] = { "close", mode = { "n", "i" } },
            },
          },
          list = {
            border = "rounded",
          },
          preview = {
            border = "rounded",
          },
        },
      },
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
      terminal = {
        enabled = true,
        win = {
          style = "terminal",
        },
      },
      words = { enabled = true },
      zen = { enabled = true },
    },
    keys = {
      {
        "<leader>e",
        function()
          Snacks.explorer()
        end,
        desc = "Open explorer",
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
        "<leader>/",
        function()
          Snacks.picker.keymaps()
        end,
        desc = "Find keymaps",
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
          Snacks.terminal(nil, { count = 1, win = { position = "float" } })
        end,
        desc = "Floating terminal",
      },
      {
        "<leader>th",
        function()
          Snacks.terminal(nil, {
            count = 2,
            win = {
              position = "bottom",
              relative = "win",
              win = main_window(),
              height = 0.3,
            },
          })
        end,
        desc = "Horizontal terminal",
      },
      {
        "<leader>tv",
        function()
          Snacks.terminal(nil, { count = 3, win = { position = "right", width = 0.3 } })
        end,
        desc = "Vertical terminal",
      },
      {
        "<leader>z",
        function()
          Snacks.zen()
        end,
        desc = "Zen mode",
      },
      {
        "<leader>.",
        function()
          Snacks.scratch()
        end,
        desc = "Scratch",
      },
      {
        "<leader>S",
        function()
          Snacks.scratch.select()
        end,
        desc = "Scratch list",
      },
      {
        "<leader>nn",
        function()
          Snacks.notifier.show_history()
        end,
        desc = "Show notifications",
      },
      {
        "<leader>nd",
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
