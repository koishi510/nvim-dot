local M = {}

local last_main_win

local left_filetypes = {
  DiffviewFiles = true,
  NvimTree = true,
  dbui = true,
}

local right_filetypes = {
  Outline = true,
  agent_terminal = true,
  dapui_breakpoints = true,
  dapui_scopes = true,
  dapui_stacks = true,
  dapui_watches = true,
  terminal_panel_right = true,
  kulala_ui = true,
}

local bottom_filetypes = {
  DiffviewFileHistory = true,
  dapui_console = true,
  dapui_repl = true,
  ["grug-far"] = true,
  qf = true,
  terminal_panel_bottom = true,
  trouble = true,
}

local panel_filetypes = {
  DiffviewFileHistory = true,
  DiffviewFiles = true,
  NvimTree = true,
  Outline = true,
  agent_terminal = true,
  dapui_breakpoints = true,
  dapui_console = true,
  dapui_repl = true,
  dapui_scopes = true,
  dapui_stacks = true,
  dapui_watches = true,
  dbout = true,
  dbui = true,
  ["grug-far"] = true,
  ["grug-far-help"] = true,
  kulala_ui = true,
  qf = true,
  terminal_panel_bottom = true,
  terminal_panel_right = true,
  trouble = true,
}

local function win_valid(win)
  return win and vim.api.nvim_win_is_valid(win)
end

local function is_float(win)
  return win_valid(win) and vim.api.nvim_win_get_config(win).relative ~= ""
end

function M.is_panel_win(win)
  if not win_valid(win) or is_float(win) then
    return true
  end

  local ok, buf = pcall(vim.api.nvim_win_get_buf, win)
  if not ok then
    return true
  end

  local name = vim.api.nvim_buf_get_name(buf)
  if name == "kulala://ui" then
    vim.b[buf].kulala_ui = true
    return true
  end

  local ft = vim.bo[buf].filetype
  if panel_filetypes[ft] or vim.b[buf].agent_terminal then
    return true
  end

  if ft == "toggleterm" then
    return true
  end

  local info = vim.fn.getwininfo(win)[1]
  return info and info.quickfix == 1
end

function M.is_main_win(win)
  if not win_valid(win) or M.is_panel_win(win) then
    return false
  end

  local buf = vim.api.nvim_win_get_buf(win)
  local bt = vim.bo[buf].buftype
  return bt == "" or bt == "acwrite"
end

function M.remember_main()
  local win = vim.api.nvim_get_current_win()
  if M.is_main_win(win) then
    last_main_win = win
  end
end

function M.main_win()
  if M.is_main_win(last_main_win) then
    return last_main_win
  end

  local best
  local best_area = -1
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if M.is_main_win(win) then
      local area = vim.api.nvim_win_get_width(win) * vim.api.nvim_win_get_height(win)
      if area > best_area then
        best = win
        best_area = area
      end
    end
  end

  last_main_win = best
  return best
end

function M.focus_main()
  local win = M.main_win()
  if win_valid(win) then
    vim.api.nvim_set_current_win(win)
    return true
  end
  return false
end

function M.bottom_height()
  return math.max(10, math.min(14, math.floor(vim.o.lines * 0.25)))
end

function M.picker_height(win)
  win = win or M.main_win() or vim.api.nvim_get_current_win()
  local height = win_valid(win) and vim.api.nvim_win_get_height(win) or vim.o.lines
  return math.max(12, math.min(22, math.floor(height * 0.52)))
end

function M.left_width()
  return math.max(30, math.min(36, math.floor(vim.o.columns * 0.22)))
end

function M.right_width()
  return math.max(48, math.min(72, math.floor(vim.o.columns * 0.36)))
end

function M.apply_panel_options(win)
  win = win or vim.api.nvim_get_current_win()
  if not win_valid(win) or is_float(win) then
    return
  end

  local buf = vim.api.nvim_win_get_buf(win)
  local ft = vim.bo[buf].filetype
  if vim.b[buf].kulala_ui or vim.api.nvim_buf_get_name(buf) == "kulala://ui" then
    ft = "kulala_ui"
    vim.b[buf].kulala_ui = true
  end

  if left_filetypes[ft] or right_filetypes[ft] or vim.b[buf].agent_terminal then
    vim.wo[win].winfixwidth = true
  elseif bottom_filetypes[ft] then
    vim.wo[win].winfixheight = true
  end
end

function M.resize_panel(win)
  win = win or vim.api.nvim_get_current_win()
  if not win_valid(win) or is_float(win) then
    return
  end

  local buf = vim.api.nvim_win_get_buf(win)
  local ft = vim.bo[buf].filetype
  if vim.b[buf].kulala_ui or vim.api.nvim_buf_get_name(buf) == "kulala://ui" then
    ft = "kulala_ui"
    vim.b[buf].kulala_ui = true
  end

  if left_filetypes[ft] then
    pcall(vim.api.nvim_win_set_width, win, M.left_width())
  elseif right_filetypes[ft] or vim.b[buf].agent_terminal or ft == "kulala_ui" then
    pcall(vim.api.nvim_win_set_width, win, M.right_width())
  elseif bottom_filetypes[ft] then
    pcall(vim.api.nvim_win_set_height, win, M.bottom_height())
  end
end

function M.apply_all_panels()
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    M.apply_panel_options(win)
    M.resize_panel(win)
  end
end

function M.picker_winopts()
  M.focus_main()
  local win = vim.api.nvim_get_current_win()
  local pos = vim.api.nvim_win_get_position(win)
  local win_height = vim.api.nvim_win_get_height(win)
  local height = math.min(M.picker_height(win), math.max(1, win_height - 1))

  return {
    relative = "editor",
    row = pos[1] + win_height - height,
    col = pos[2],
    width = vim.api.nvim_win_get_width(win),
    height = height,
    border = "rounded",
    backdrop = 35,
    preview = {
      border = "rounded",
      layout = "vertical",
      vertical = "up:55%",
      flip_columns = 140,
    },
  }
end

function M.open_trouble_bottom(mode, opts)
  opts = opts or {}
  M.focus_main()
  require("trouble").open(vim.tbl_deep_extend("force", {
    mode = mode,
    win = {
      relative = "win",
      position = "bottom",
      size = M.bottom_height(),
    },
  }, opts))
end

function M.toggle_trouble_bottom(mode, opts)
  opts = opts or {}
  M.focus_main()
  local trouble = require("trouble")
  if trouble.is_open(mode) then
    trouble.close(mode)
    return
  end

  trouble.open(vim.tbl_deep_extend("force", {
    mode = mode,
    win = {
      relative = "win",
      position = "bottom",
      size = M.bottom_height(),
    },
  }, opts))
end

function M.toggle_trouble_right(mode, opts)
  opts = opts or {}
  M.focus_main()
  local trouble = require("trouble")
  if trouble.is_open(mode) then
    trouble.close(mode)
    return
  end

  trouble.open(vim.tbl_deep_extend("force", {
    mode = mode,
    win = {
      relative = "editor",
      position = "right",
      size = M.right_width(),
    },
  }, opts))
end

function M.open_trouble_qflist()
  M.open_trouble_bottom("qflist", {
    mode = "qflist",
    focus = true,
  })
end

function M.setup()
  local group = vim.api.nvim_create_augroup("editor-layout", { clear = true })

  vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
    group = group,
    callback = function()
      M.remember_main()
      M.apply_panel_options()
    end,
  })

  vim.api.nvim_create_autocmd({ "FileType", "WinNew" }, {
    group = group,
    callback = function()
      local win = vim.api.nvim_get_current_win()
      vim.schedule(function()
        M.apply_panel_options(win)
        M.resize_panel(win)
      end)
    end,
  })

  vim.api.nvim_create_autocmd("VimResized", {
    group = group,
    callback = function()
      vim.schedule(M.apply_all_panels)
    end,
  })
end

return M
