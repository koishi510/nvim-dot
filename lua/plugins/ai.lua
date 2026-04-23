local function agent_terminal(cmd)
  local path, qf_count = require("config.quickfix").write()
  require("config.terminal").agent(cmd)

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
