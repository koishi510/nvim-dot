return {
  {
    "3rd/image.nvim",
    ft = { "markdown", "typst" },
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
          filetypes = { "markdown" },
        },
        typst = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = true,
          only_render_image_at_cursor = false,
          floating_windows = false,
          filetypes = { "typst" },
        },
      },
      max_height_window_percentage = 40,
      window_overlap_clear_enabled = true,
      editor_only_render_when_focused = false,
    },
  },
}
