return {
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      {
        "<leader>jj",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump()
        end,
        desc = "Flash jump",
      },
      {
        "<leader>jt",
        mode = { "n", "x", "o" },
        function()
          require("flash").treesitter()
        end,
        desc = "Flash treesitter",
      },
      {
        "<leader>jr",
        mode = { "n", "o", "x" },
        function()
          require("flash").remote()
        end,
        desc = "Remote flash",
      },
      {
        "<leader>js",
        mode = { "n", "o", "x" },
        function()
          require("flash").treesitter_search()
        end,
        desc = "Treesitter search",
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "BufReadPost",
    opts = {
      max_lines = 5,
      min_window_height = 20,
      multiline_threshold = 4,
      mode = "cursor",
      trim_scope = "outer",
    },
    keys = {
      {
        "<leader>uc",
        function()
          require("treesitter-context").toggle()
        end,
        desc = "Toggle code context",
      },
      {
        "[c",
        function()
          require("treesitter-context").go_to_context(vim.v.count1)
        end,
        desc = "Go to context",
      },
    },
  },
  {
    "nvim-mini/mini.ai",
    version = false,
    event = "VeryLazy",
    config = function()
      local ai = require("mini.ai")

      ai.setup({
        n_lines = 500,
        custom_textobjects = {
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
          a = ai.gen_spec.treesitter({ a = "@parameter.outer", i = "@parameter.inner" }),
        },
      })
    end,
  },
  {
    "kevinhwang91/promise-async",
    lazy = true,
  },
  {
    "kevinhwang91/nvim-ufo",
    dependencies = {
      "kevinhwang91/promise-async",
    },
    event = "BufReadPost",
    init = function()
      vim.o.foldcolumn = "1"
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
    end,
    opts = {},
    keys = {
      { "zR", function() require("ufo").openAllFolds() end, desc = "Open all folds" },
      { "zM", function() require("ufo").closeAllFolds() end, desc = "Close all folds" },
      { "zr", function() require("ufo").openFoldsExceptKinds() end, desc = "Open folds" },
      { "zm", function() require("ufo").closeFoldsWith() end, desc = "Close folds" },
      {
        "gK",
        function()
          local winid = require("ufo").peekFoldedLinesUnderCursor()
          if not winid then
            vim.lsp.buf.hover()
          end
        end,
        desc = "Peek fold or hover",
      },
    },
  },
  {
    "hedyhli/outline.nvim",
    cmd = { "Outline", "OutlineOpen" },
    keys = {
      { "<leader>o", "<cmd>Outline<cr>", desc = "Toggle outline" },
    },
    opts = {
      position = "right",
      width = 28,
      preview_window = {
        auto_preview = false,
      },
      symbols = {
        icon_source = "lspkind",
      },
    },
  },
  {
    "folke/todo-comments.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {},
    keys = {
      {
        "]t",
        function()
          require("todo-comments").jump_next()
        end,
        desc = "Next todo comment",
      },
      {
        "[t",
        function()
          require("todo-comments").jump_prev()
        end,
        desc = "Previous todo comment",
      },
      { "<leader>ft", "<cmd>TodoQuickFix<cr><cmd>copen<cr>", desc = "Find todos" },
      { "<leader>fq", "<cmd>TodoQuickFix<cr>", desc = "Todo quickfix" },
    },
  },
  {
    "HakonHarnes/img-clip.nvim",
    event = "VeryLazy",
    opts = {
      default = {
        embed_image_as_base64 = false,
        prompt_for_file_name = true,
        drag_and_drop = {
          enabled = true,
        },
      },
      filetypes = {
        markdown = {
          url_encode_path = true,
          template = "![$CURSOR]($FILE_PATH)",
          download_images = false,
        },
        html = {
          template = '<img src="$FILE_PATH" alt="$CURSOR">',
        },
      },
    },
    keys = {
      { "<leader>ip", "<cmd>PasteImage<cr>", desc = "Paste image" },
    },
  },
}
