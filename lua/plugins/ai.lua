local function agent_terminal(cmd)
  local root = require("config.root")
  local cwd = root.buf_project_root() or root.start_dir
  local path, qf_count = require("config.quickfix").write()
  Snacks.terminal(cmd, {
    count = root.session_count("agent_" .. cmd .. "|" .. cwd),
    cwd = cwd,
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
