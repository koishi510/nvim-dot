local M = {}

local conflict_pattern = [[^\(<\{7}\|=\{7}\|>\{7}\)]]

local function system_list(cmd)
  local result = vim.system(cmd, { text = true }):wait()
  if result.code ~= 0 then
    return {}
  end

  local lines = vim.split(result.stdout or "", "\n", { trimempty = true })
  return lines
end

function M.conflicted_files()
  return system_list({ "git", "diff", "--name-only", "--diff-filter=U" })
end

function M.set_conflict_qflist()
  local files = M.conflicted_files()

  if vim.tbl_isempty(files) then
    vim.notify("No conflicted files found", vim.log.levels.INFO)
    return
  end

  local items = {}
  for _, file in ipairs(files) do
    items[#items + 1] = {
      filename = file,
      lnum = 1,
      col = 1,
      text = "Git conflict",
    }
  end

  vim.fn.setqflist({}, " ", {
    title = "Git conflicts",
    items = items,
  })
  vim.cmd.copen()
end

function M.next_conflict()
  vim.fn.search(conflict_pattern, "W")
end

function M.prev_conflict()
  vim.fn.search(conflict_pattern, "bW")
end

return M
