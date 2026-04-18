return {
  {
    "akinsho/bufferline.nvim",
    version = "*",
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
            filetype = "snacks_layout_box",
            text = "Explorer",
            highlight = "Directory",
            text_align = "left",
            separator = false,
          },
          {
            filetype = "snacks_terminal",
            text = "Terminal",
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
        { "<leader>a", group = "agent" },
        { "<leader>b", group = "buffer" },
        { "<leader>c", group = "conflict" },
        { "<leader>f", group = "find" },
        { "<leader>g", group = "git" },
        { "<leader>j", group = "jump" },
        { "<leader>l", group = "lint" },
        { "<leader>m", group = "markdown" },
        { "<leader>n", group = "notify" },
        { "<leader>p", group = "preview" },
        { "<leader>r", group = "run" },
        { "<leader>s", group = "symbol" },
        { "<leader>t", group = "terminal" },
        { "<leader>v", group = "latex" },
        { "<leader>y", group = "typst" },
        { "<leader>x", group = "trouble" },
        { "g", group = "goto" },
      },
    },
  },
}
