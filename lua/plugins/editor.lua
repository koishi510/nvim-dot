return {
  {
    "tpope/vim-fugitive",
    cmd = {
      "G",
      "Git",
      "GBrowse",
      "GDelete",
      "GMove",
      "GRename",
      "Gdiffsplit",
      "Gedit",
      "Ggrep",
      "Gread",
      "Gvdiffsplit",
      "Gwrite",
    },
    dependencies = {
      "tpope/vim-rhubarb",
    },
    keys = {
      { "<leader>gG", "<cmd>Git<cr>", desc = "Fugitive status" },
      { "<leader>gl", "<cmd>Git log --oneline --decorate --graph --all<cr>", desc = "Git log" },
      { "<leader>gv", "<cmd>Gvdiffsplit<cr>", desc = "Git vertical diff" },
      { "<leader>gw", "<cmd>Gwrite<cr>", desc = "Git write stage" },
    },
  },
  {
    "aaronhallaert/advanced-git-search.nvim",
    cmd = "AdvancedGitSearch",
    dependencies = {
      "ibhagwan/fzf-lua",
      "tpope/vim-fugitive",
      "tpope/vim-rhubarb",
      "sindrets/diffview.nvim",
    },
    opts = {
      diff_plugin = "diffview",
      git_flags = { "-c", "delta.side-by-side=true" },
      entry_default_author_or_date = "author",
    },
    config = function(_, opts)
      require("advanced_git_search.fzf").setup(opts)
    end,
    keys = {
      { "<leader>ga", "<cmd>AdvancedGitSearch<cr>", desc = "Advanced Git search" },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      current_line_blame = true,
      on_attach = function(bufnr)
        local gs = require("gitsigns")

        local function map(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end

        map("n", "]h", function()
          gs.nav_hunk("next")
        end, "Next git hunk")
        map("n", "[h", function()
          gs.nav_hunk("prev")
        end, "Previous git hunk")
        map("n", "<leader>gp", gs.preview_hunk, "Preview git hunk")
        map("n", "<leader>gb", gs.blame_line, "Blame line")
        map("n", "<leader>gr", gs.reset_hunk, "Reset hunk")
      end,
    },
  },
  {
    "sindrets/diffview.nvim",
    cmd = {
      "DiffviewOpen",
      "DiffviewClose",
      "DiffviewToggleFiles",
      "DiffviewFileHistory",
      "DiffviewFocusFiles",
      "DiffviewRefresh",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {
      enhanced_diff_hl = true,
      view = {
        default = {
          layout = "diff2_horizontal",
        },
        merge_tool = {
          layout = "diff3_horizontal",
        },
        file_history = {
          layout = "diff2_horizontal",
        },
      },
      file_panel = {
        win_config = {
          position = "left",
          width = 35,
        },
      },
      file_history_panel = {
        win_config = {
          position = "bottom",
          height = 14,
        },
      },
    },
  },
  {
    "akinsho/git-conflict.nvim",
    version = "*",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      default_mappings = false,
      default_commands = true,
      disable_diagnostics = false,
      list_opener = "copen",
      highlights = {
        incoming = "DiffAdd",
        current = "DiffText",
      },
    },
  },
  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    opts = {},
  },
  {
    "tpope/vim-sleuth",
    event = { "BufReadPost", "BufNewFile" },
  },
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    opts = {},
  },
}
