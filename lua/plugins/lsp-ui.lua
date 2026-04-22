return {
  {
    "nvimdev/lspsaga.nvim",
    cmd = "Lspsaga",
    event = "LspAttach",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      symbol_in_winbar = {
        enable = false,
      },
      code_action = {
        num_shortcut = true,
        only_in_cursor = false,
        show_server_name = true,
        extend_gitsigns = false,
        keys = {
          quit = "q",
          exec = "<CR>",
        },
      },
      diagnostic = {
        show_code_action = true,
        jump_num_shortcut = true,
        max_width = 0.6,
        max_height = 0.65,
        text_hl_follow = true,
        border_follow = true,
        keys = {
          exec_action = "r",
          quit = "q",
          toggle_or_jump = "<CR>",
          quit_in_show = { "q", "<Esc>" },
        },
      },
      hover = {
        max_width = 0.55,
        max_height = 0.7,
        open_link = "gl",
      },
      lightbulb = {
        enable = false,
      },
      rename = {
        in_select = false,
        auto_save = false,
        keys = {
          quit = "<C-c>",
          exec = "<CR>",
          select = "x",
        },
      },
      ui = {
        border = "rounded",
        devicon = true,
        title = true,
      },
      scroll_preview = {
        scroll_down = "<C-d>",
        scroll_up = "<C-u>",
      },
      request_timeout = 3000,
    },
    keys = {
      { "K", "<cmd>Lspsaga hover_doc<cr>", desc = "Hover docs" },
      { "<leader>ca", "<cmd>Lspsaga code_action<cr>", desc = "Code action", mode = { "n", "v" } },
      { "<leader>cr", "<cmd>Lspsaga rename<cr>", desc = "Rename symbol" },
      { "<leader>cd", "<cmd>Lspsaga show_line_diagnostics<cr>", desc = "Line diagnostics" },
      { "<leader>jd", "<cmd>Lspsaga peek_definition<cr>", desc = "Peek definition" },
      { "<leader>jy", "<cmd>Lspsaga peek_type_definition<cr>", desc = "Peek type definition" },
      { "<leader>jr", "<cmd>Lspsaga finder ref<cr>", desc = "Find references" },
      { "<leader>ji", "<cmd>Lspsaga finder imp<cr>", desc = "Find implementations" },
    },
  },
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "LspAttach",
    priority = 1000,
    opts = {
      preset = "simple",
      options = {
        show_source = {
          enabled = true,
          if_many = true,
        },
        add_messages = true,
        use_icons_from_diagnostic = true,
        show_all_diags_on_cursorline = false,
        break_line = {
          enabled = true,
          after = 100,
        },
      },
      disabled_ft = {
        "checkhealth",
        "dap-repl",
        "diff",
        "help",
        "log",
        "NvimTree",
        "qf",
        "snacks_dashboard",
        "TelescopePrompt",
        "toggleterm",
      },
    },
    config = function(_, opts)
      require("tiny-inline-diagnostic").setup(opts)
      require("tiny-inline-diagnostic").enable()
    end,
    keys = {
      {
        "<leader>ct",
        function()
          require("tiny-inline-diagnostic").toggle()
        end,
        desc = "Toggle inline diagnostics",
      },
    },
  },
}
