local function agent_terminal(cmd)
  local path, qf_count = require("config.quickfix").write()
  require("config.terminal").agent(cmd)

  if path then
    vim.notify(string.format("Quickfix exported to %s (%d item(s))", vim.fn.fnamemodify(path, ":."), qf_count))
  end
end

return {
  {
    "olimorris/codecompanion.nvim",
    cmd = {
      "CodeCompanion",
      "CodeCompanionActions",
      "CodeCompanionChat",
      "CodeCompanionCmd",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "ravitemer/codecompanion-history.nvim",
    },
    opts = {
      display = {
        chat = {
          window = {
            layout = "vertical",
            position = "right",
            width = require("config.layout").right_width(),
            border = "rounded",
          },
        },
        diff = {
          enabled = true,
          provider = "inline",
        },
      },
      extensions = {
        history = {
          enabled = true,
          opts = {
            picker = "fzf-lua",
            auto_save = true,
            auto_generate_title = true,
            continue_last_chat = false,
          },
        },
      },
    },
    config = function(_, opts)
      require("codecompanion").setup(opts)
    end,
    keys = {
      { "<leader>at", "<cmd>CodeCompanionChat Toggle<cr>", desc = "Toggle chat" },
      { "<leader>aa", "<cmd>CodeCompanionActions<cr>", desc = "Code actions", mode = { "n", "v" } },
      { "<leader>aA", "<cmd>CodeCompanionChat Add<cr>", desc = "Add to chat", mode = "v" },
    },
  },
  {
    "folke/snacks.nvim",
    keys = {
      {
        "<leader>ac",
        function()
          agent_terminal("claude")
        end,
        desc = "Open Claude",
      },
      {
        "<leader>ax",
        function()
          agent_terminal("codex")
        end,
        desc = "Open Codex",
      },
      {
        "<leader>ag",
        function()
          agent_terminal("gemini")
        end,
        desc = "Open Gemini",
      },
      {
        "<leader>ao",
        function()
          agent_terminal("opencode")
        end,
        desc = "Open OpenCode",
      },
    },
  },
}
