local function agent_terminal(cmd, count)
  Snacks.terminal(cmd, {
    count = count,
    win = {
      position = "right",
      width = 0.3,
    },
  })
end

return {
  {
    "folke/snacks.nvim",
    keys = {
      {
        "<leader>ac",
        function()
          agent_terminal("claude", 20)
        end,
        desc = "Claude",
      },
      {
        "<leader>ax",
        function()
          agent_terminal("codex", 21)
        end,
        desc = "Codex",
      },
      {
        "<leader>ag",
        function()
          agent_terminal("gemini", 22)
        end,
        desc = "Gemini",
      },
      {
        "<leader>ao",
        function()
          agent_terminal("opencode", 23)
        end,
        desc = "OpenCode",
      },
    },
  },
}
