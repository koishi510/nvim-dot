local M = {}

local function qf_filename(item)
  if item.filename and item.filename ~= "" then
    return item.filename
  end

  if item.bufnr and item.bufnr > 0 then
    local name = vim.api.nvim_buf_get_name(item.bufnr)
    if name ~= "" then
      return name
    end
  end
end

local function relative_path(path)
  if not path or path == "" then
    return nil
  end

  local root = require("config.root").start_dir
  path = vim.fs.normalize(path)
  if path == root then
    return "."
  end
  if vim.startswith(path, root .. "/") then
    return path:sub(#root + 2)
  end
  return vim.fn.fnamemodify(path, ":.")
end

local function format_item(item)
  local file = relative_path(qf_filename(item))
  local text = (item.text or ""):gsub("%s+$", "")

  if file then
    local lnum = item.lnum and item.lnum > 0 and item.lnum or 1
    local col = item.col and item.col > 0 and item.col or 1
    return string.format("%s:%d:%d: %s", file, lnum, col, text)
  end

  return text
end

function M.lines()
  local items = vim.fn.getqflist()
  local lines = {}

  for _, item in ipairs(items) do
    if item.valid == 1 or item.text then
      local line = format_item(item)
      if line ~= "" then
        table.insert(lines, line)
      end
    end
  end

  return lines
end

function M.markdown()
  local lines = M.lines()
  if vim.tbl_isempty(lines) then
    return nil, 0
  end

  local out = {
    "# Quickfix",
    "",
    "Process these quickfix items in order. Each item uses `file:line:col: message`.",
    "",
    "```text",
  }

  vim.list_extend(out, lines)
  table.insert(out, "```")

  return table.concat(out, "\n") .. "\n", #lines
end

function M.write()
  local text, count = M.markdown()
  if not text then
    return nil, 0
  end

  local root = require("config.root").start_dir
  local dir = vim.fs.joinpath(root, ".nvim")
  local path = vim.fs.joinpath(dir, "quickfix.md")

  vim.fn.mkdir(dir, "p")
  vim.fn.writefile(vim.split(text, "\n", { plain = true }), path)

  return path, count
end

function M.copy()
  local text, count = M.markdown()
  if not text then
    vim.notify("Quickfix list is empty", vim.log.levels.INFO)
    return
  end

  vim.fn.setreg("+", text)
  vim.fn.setreg('"', text)
  vim.notify(string.format("Copied %d quickfix item(s)", count))
end

function M.write_with_notify()
  local path, count = M.write()
  if not path then
    vim.notify("Quickfix list is empty", vim.log.levels.INFO)
    return
  end

  vim.notify(string.format("Wrote %d quickfix item(s) to %s", count, relative_path(path)))
end

function M.agent_prompt_text(path, count)
  return string.format(
    "The current quickfix list has been exported to %s with %d item(s). Read that file first and handle the issues in quickfix order.",
    relative_path(path),
    count
  )
end

function M.agent_prompt()
  local path, count = M.write()
  if not path then
    return nil
  end

  return M.agent_prompt_text(path, count)
end

function M.copy_agent_prompt()
  local prompt = M.agent_prompt()
  if not prompt then
    vim.notify("Quickfix list is empty", vim.log.levels.INFO)
    return
  end

  vim.fn.setreg("+", prompt)
  vim.fn.setreg('"', prompt)
  vim.notify("Copied agent quickfix prompt")
end

return M
