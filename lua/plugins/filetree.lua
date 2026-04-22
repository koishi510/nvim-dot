local function project_root()
  return require("config.root").buf_project_root() or require("config.root").start_dir
end

return {
  {
    "nvim-tree/nvim-tree.lua",
    cmd = {
      "NvimTreeClose",
      "NvimTreeFindFile",
      "NvimTreeFindFileToggle",
      "NvimTreeFocus",
      "NvimTreeOpen",
      "NvimTreeRefresh",
      "NvimTreeToggle",
    },
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      disable_netrw = true,
      hijack_netrw = true,
      sync_root_with_cwd = false,
      respect_buf_cwd = true,
      view = {
        width = 32,
        side = "left",
        signcolumn = "yes",
        preserve_window_proportions = true,
      },
      renderer = {
        group_empty = true,
        highlight_git = true,
        indent_markers = {
          enable = true,
        },
      },
      update_focused_file = {
        enable = true,
        update_root = false,
      },
      filters = {
        dotfiles = false,
        git_ignored = false,
      },
      git = {
        enable = true,
        ignore = false,
      },
      actions = {
        change_dir = {
          enable = false,
        },
        open_file = {
          quit_on_open = false,
          window_picker = {
            enable = true,
          },
        },
      },
    },
    keys = {
      {
        "<leader>e",
        function()
          require("nvim-tree.api").tree.toggle({ path = project_root() })
        end,
        desc = "Toggle file tree",
      },
      {
        "<leader>E",
        function()
          require("nvim-tree.api").tree.find_file({ open = true, focus = true })
        end,
        desc = "Reveal current file",
      },
    },
  },
}
