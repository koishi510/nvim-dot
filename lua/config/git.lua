local M = {}

local conflict_pattern = [[^\(<\{7}\||\{7}\|=\{7}\|>\{7}\)]]

function M.has_conflict_markers(bufnr)
  bufnr = bufnr or 0
  if not vim.api.nvim_buf_is_loaded(bufnr) then
    return false
  end

  local line_count = vim.api.nvim_buf_line_count(bufnr)
  for lnum = 1, line_count do
    local line = vim.api.nvim_buf_get_lines(bufnr, lnum - 1, lnum, false)[1] or ""
    if line:match("^<<<<<<<") or line:match("^|||||||") or line:match("^=======") or line:match("^>>>>>>>") then
      return true
    end
  end

  return false
end

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
