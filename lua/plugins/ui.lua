return {
  {
    "akinsho/bufferline.nvim",
    version = "*",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      options = {
        diagnostics = "nvim_lsp",
        always_show_bufferline = false,
        close_command = function(buf)
          Snacks.bufdelete.delete({ buf = buf })
        end,
        right_mouse_command = function(buf)
          Snacks.bufdelete.delete({ buf = buf })
        end,
        offsets = {
          {
            filetype = "NvimTree",
            text = "Explorer",
            highlight = "Directory",
            text_align = "left",
            separator = false,
          },
          {
            filetype = "dbui",
            text = "Database",
            highlight = "Directory",
            text_align = "left",
            separator = false,
          },
          {
            filetype = "DiffviewFiles",
            text = "Git",
            highlight = "Directory",
            text_align = "left",
            separator = false,
          },
          {
            filetype = "agent_terminal",
            text = "Agent",
            highlight = "Directory",
            text_align = "right",
            separator = false,
          },
          {
            filetype = "terminal_panel_right",
            text = "Terminal",
            highlight = "Directory",
            text_align = "right",
            separator = false,
          },
          {
            filetype = "codecompanion",
            text = "Chat",
            highlight = "Directory",
            text_align = "right",
            separator = false,
          },
          {
            filetype = "Outline",
            text = "Outline",
            highlight = "Directory",
            text_align = "right",
            separator = false,
          },
          {
            filetype = "dapui_scopes",
            text = "Debug",
            highlight = "Directory",
            text_align = "right",
            separator = false,
          },
        },
        separator_style = { "", "" },
      },
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      options = {
        theme = "tokyonight",
        globalstatus = true,
        section_separators = "",
        component_separators = "",
      },
    },
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "modern",
      spec = {
        { "<leader>a", group = "ai / agent" },
        { "<leader>b", group = "buffer" },
        { "<leader>d", group = "debug" },
        { "<leader>f", group = "find / replace" },
        { "<leader>g", group = "git" },
        { "<leader>gc", group = "conflict" },
        { "<leader>j", group = "jump" },
        { "<leader>c", group = "code" },
        { "<leader>l", group = "language" },
        { "<leader>ld", group = "database" },
        { "<leader>lh", group = "html" },
        { "<leader>lH", group = "http / rest" },
        { "<leader>lg", group = "go" },
        { "<leader>lr", group = "rust" },
        { "<leader>m", group = "writing" },
        { "<leader>p", group = "package" },
        { "<leader>r", group = "run" },
        { "<leader>s", group = "session" },
        { "<leader>t", group = "terminal" },
        { "<leader>x", group = "diagnostics / lists" },
        { "<leader>w", group = "workspace" },
        { "<leader>z", group = "zen / scratch" },
      },
    },
  },
}
