return {
  {
    "vimwiki/vimwiki",
    branch = "dev",
    init = function()
      vim.g.vimwiki_list = {
        {
          path = vim.fn.expand("~/vimwiki/"),
          syntax = "markdown",
          ext = ".md",
        },
      }
      vim.g.vimwiki_global_ext = 0
    end,
    keys = {
      { "<leader>ww", "<cmd>VimwikiIndex<cr>", desc = "Wiki index" },
      { "<leader>wd", "<cmd>VimwikiDiaryIndex<cr>", desc = "Wiki diary" },
      { "<leader>wn", "<cmd>VimwikiMakeDiaryNote<cr>", desc = "Wiki new diary note" },
      { "<leader>wt", "<cmd>VimwikiTabIndex<cr>", desc = "Wiki index in tab" },
    },
  },
  {
    "tools-life/taskwiki",
    dependencies = {
      "vimwiki/vimwiki",
    },
    ft = { "vimwiki", "markdown" },
  },
  {
    "3rd/image.nvim",
    ft = { "markdown", "vimwiki" },
    build = false,
    opts = {
      backend = "kitty",
      processor = "magick_cli",
      integrations = {
        markdown = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = true,
          only_render_image_at_cursor = false,
          floating_windows = false,
          filetypes = { "markdown", "vimwiki" },
        },
      },
      max_height_window_percentage = 40,
      window_overlap_clear_enabled = true,
      editor_only_render_when_focused = false,
    },
  },
}
