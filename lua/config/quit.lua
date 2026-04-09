local M = {}

local function options_file()
  return vim.fn.stdpath("config") .. "/lua/config/options.lua"
end

local function is_float(win)
  return vim.api.nvim_win_get_config(win).relative ~= ""
end

function M.enabled()
  return vim.g.smart_quit_enabled ~= false
end

local function is_explorer_window(win)
  if not vim.api.nvim_win_is_valid(win) then
    return false
  end

  local buf = vim.api.nvim_win_get_buf(win)
  local ft = vim.bo[buf].filetype
  return ft == "snacks_layout_box" or ft:match("^snacks_")
end

local function is_real_buffer(buf)
  if not vim.api.nvim_buf_is_valid(buf) or not vim.bo[buf].buflisted then
    return false
  end

  if vim.bo[buf].buftype ~= "" then
    return false
  end

  local ft = vim.bo[buf].filetype
  return ft ~= "snacks_dashboard" and not ft:match("^snacks_")
end

local function close_explorer()
  if not _G.Snacks then
    return
  end

  for _, picker in ipairs(_G.Snacks.picker.get({ source = "explorer" })) do
    picker:close()
  end
end

local function real_buffers(exclude)
  local ret = {}

  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if buf ~= exclude and is_real_buffer(buf) then
      ret[#ret + 1] = buf
    end
  end

  return ret
end

local function delete_buf(buf, force)
  pcall(vim.api.nvim_buf_delete, buf, { force = force or false })
end

local function modified_quit_error()
  vim.api.nvim_echo({
    { "E37: No write since last change (add ! to override)", "ErrorMsg" },
  }, true, {})
end

local function quit_cmd(force, all)
  if all then
    vim.cmd(force and "qall!" or "qall")
    return
  end

  vim.cmd(force and "quit!" or "quit")
end

local function tab_wins()
  return vim.tbl_filter(function(win)
    return vim.api.nvim_win_is_valid(win) and not is_float(win)
  end, vim.api.nvim_tabpage_list_wins(0))
end

local function real_file_wins()
  return vim.tbl_filter(function(win)
    local buf = vim.api.nvim_win_get_buf(win)
    return is_real_buffer(buf)
  end, tab_wins())
end

function M.smart_quit(opts)
  opts = opts or {}
  local force = opts.force or false

  if not M.enabled() then
    quit_cmd(force, false)
    return
  end

  local win = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_get_current_buf()

  if is_float(win) then
    quit_cmd(force, false)
    return
  end

  if vim.bo[buf].modified and is_real_buffer(buf) and not force then
    modified_quit_error()
    return
  end

  if vim.bo[buf].modified and not force then
    quit_cmd(force, false)
    return
  end

  if is_explorer_window(win) then
    quit_cmd(force, false)
    return
  end

  if not is_real_buffer(buf) then
    quit_cmd(force, false)
    return
  end

  if #real_file_wins() > 1 then
    quit_cmd(force, false)
    return
  end

  local others = real_buffers(buf)

  if #others > 0 then
    vim.api.nvim_win_set_buf(win, others[1])
    delete_buf(buf, force)
    return
  end

  close_explorer()

  if #tab_wins() > 1 then
    quit_cmd(force, true)
    return
  end

  quit_cmd(force, false)
end

function M.should_use_native_quit()
  if not M.enabled() then
    return true
  end

  local win = vim.api.nvim_get_current_win()
  return is_float(win)
end

function M.persist_enabled(enabled)
  local path = options_file()
  local lines = vim.fn.readfile(path)
  local replaced = false

  for i, line in ipairs(lines) do
    if line:match("^vim%.g%.smart_quit_enabled%s*=") then
      lines[i] = ("vim.g.smart_quit_enabled = %s"):format(enabled and "true" or "false")
      replaced = true
      break
    end
  end

  if not replaced then
    table.insert(lines, 3, ("vim.g.smart_quit_enabled = %s"):format(enabled and "true" or "false"))
  end

  vim.fn.writefile(lines, path)
  vim.g.smart_quit_enabled = enabled
  vim.notify("SmartQuit " .. (enabled and "enabled" or "disabled"))
end

return M
