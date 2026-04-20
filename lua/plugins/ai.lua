local function agent_terminal(cmd, count)
  local path, qf_count = require("config.quickfix").write()
  Snacks.terminal(cmd, {
    count = count,
    win = {
      position = "right",
      width = 0.3,
    },
  })

  if path then
    vim.notify(string.format("Quickfix exported to %s (%d item(s))", vim.fn.fnamemodify(path, ":."), qf_count))
  end
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
        desc = "Open Claude",
      },
      {
        "<leader>ax",
        function()
          agent_terminal("codex", 21)
        end,
        desc = "Open Codex",
      },
      {
        "<leader>ag",
        function()
          agent_terminal("gemini", 22)
        end,
        desc = "Open Gemini",
      },
      {
        "<leader>ao",
        function()
          agent_terminal("opencode", 23)
        end,
        desc = "Open OpenCode",
      },
    },
  },
}
