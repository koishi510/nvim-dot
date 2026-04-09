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
        always_show_bufferline = true,
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
        },
        separator_style = "slant",
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
        { "<leader>b", group = "buffer" },
        { "<leader>c", group = "conflict" },
        { "<leader>f", group = "find" },
        { "<leader>g", group = "git" },
        { "<leader>h", group = "help" },
        { "<leader>i", group = "image" },
        { "<leader>l", group = "lint" },
        { "<leader>m", group = "markdown" },
        { "<leader>n", group = "notify" },
        { "<leader>s", group = "split" },
        { "<leader>t", group = "terminal" },
      },
    },
  },
}
