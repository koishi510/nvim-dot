local M = {}

local terminals = {}
local agents = {}
local panel_terminals = {}
local agent_width
local right_terminal_width
local bottom_terminal_height

local function cwd()
  local root = require("config.root")
  return root.buf_project_root() or root.start_dir
end

local function key(opts)
  if opts.id then
    return opts.id
  end

  return table.concat({
    opts.name or "",
    opts.cmd or "",
    opts.dir or cwd(),
    opts.direction or "float",
  }, "|")
end

local function remember_panel_sizes()
  local agent
  local terminal_right
  local terminal_bottom
  for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tab)) do
      local buf = vim.api.nvim_win_get_buf(win)
      if vim.b[buf].agent_terminal then
        agent = math.max(agent or 0, vim.api.nvim_win_get_width(win))
      elseif vim.b[buf].terminal_panel == "right" then
        terminal_right = math.max(terminal_right or 0, vim.api.nvim_win_get_width(win))
      elseif vim.b[buf].terminal_panel == "bottom" then
        terminal_bottom = math.max(terminal_bottom or 0, vim.api.nvim_win_get_height(win))
      end
    end
  end

  if agent then
    agent_width = agent
  end
  if terminal_right then
    right_terminal_width = terminal_right
  end
  if terminal_bottom then
    bottom_terminal_height = terminal_bottom
  end
end

local function default_agent_width()
  return require("config.layout").right_width()
end

vim.api.nvim_create_autocmd("WinResized", {
  group = vim.api.nvim_create_augroup("terminal-panel-size", { clear = true }),
  callback = remember_panel_sizes,
})

function M.toggle(opts)
  opts = opts or {}
  opts.dir = opts.dir or cwd()

  local id = key(opts)
  if not terminals[id] then
    local Terminal = require("toggleterm.terminal").Terminal
    terminals[id] = Terminal:new({
      cmd = opts.cmd,
      dir = opts.dir,
      direction = opts.direction or "float",
      display_name = opts.name,
      hidden = true,
      close_on_exit = false,
      start_in_insert = true,
      size = opts.size,
      on_open = opts.on_open,
    })
  end

  terminals[id]:toggle()
  vim.schedule(remember_panel_sizes)
end

function M.float()
  M.toggle({
    name = "terminal",
    direction = "float",
  })
end

function M.horizontal()
  M.panel("bottom")
end

function M.vertical()
  M.panel("right")
end

local function apply_agent_window(win)
  vim.wo[win].winfixwidth = true
  vim.wo[win].number = false
  vim.wo[win].relativenumber = false
  vim.wo[win].signcolumn = "no"
end

local function apply_terminal_panel_window(win, position)
  vim.wo[win].number = false
  vim.wo[win].relativenumber = false
  vim.wo[win].signcolumn = "no"
  if position == "right" then
    vim.wo[win].winfixwidth = true
  else
    vim.wo[win].winfixheight = true
  end
end

local function close_terminal_panel(state)
  if state.win and vim.api.nvim_win_is_valid(state.win) then
    if state.position == "right" then
      right_terminal_width = vim.api.nvim_win_get_width(state.win)
    else
      bottom_terminal_height = vim.api.nvim_win_get_height(state.win)
    end
    vim.api.nvim_win_close(state.win, true)
  end
  state.win = nil
end

local function create_terminal_panel_buffer(state)
  vim.cmd.enew()
  state.buf = vim.api.nvim_get_current_buf()
  state.dir = state.dir or cwd()

  vim.bo[state.buf].bufhidden = "hide"
  vim.bo[state.buf].swapfile = false
  vim.b[state.buf].terminal_panel = state.position
  pcall(vim.api.nvim_buf_set_name, state.buf, "terminal://" .. state.position)
  vim.fn.termopen(vim.o.shell, { cwd = state.dir })
  vim.bo[state.buf].filetype = state.position == "right" and "terminal_panel_right" or "terminal_panel_bottom"
end

function M.panel(position)
  local layout = require("config.layout")
  local id = "terminal|" .. position
  panel_terminals[id] = panel_terminals[id] or { position = position, dir = cwd() }
  local state = panel_terminals[id]

  if state.win and vim.api.nvim_win_is_valid(state.win) then
    close_terminal_panel(state)
    return
  end

  layout.focus_main()
  if position == "right" then
    vim.cmd(("belowright vertical %dsplit"):format(right_terminal_width or layout.right_width()))
  else
    vim.cmd(("belowright %dsplit"):format(bottom_terminal_height or layout.bottom_height()))
  end
  state.win = vim.api.nvim_get_current_win()
  apply_terminal_panel_window(state.win, position)

  if state.buf and vim.api.nvim_buf_is_valid(state.buf) then
    vim.api.nvim_win_set_buf(state.win, state.buf)
    vim.bo[state.buf].filetype = position == "right" and "terminal_panel_right" or "terminal_panel_bottom"
  else
    create_terminal_panel_buffer(state)
  end

  vim.b[state.buf].terminal_panel = position
  vim.schedule(remember_panel_sizes)
  vim.cmd.startinsert()
end

local function close_agent(state)
  if state.win and vim.api.nvim_win_is_valid(state.win) then
    agent_width = vim.api.nvim_win_get_width(state.win)
    vim.api.nvim_win_close(state.win, true)
  end
  state.win = nil
end

local function create_agent_buffer(state, cmd)
  vim.cmd.enew()
  state.buf = vim.api.nvim_get_current_buf()
  state.dir = state.dir or cwd()

  vim.bo[state.buf].bufhidden = "hide"
  vim.bo[state.buf].swapfile = false
  vim.b[state.buf].agent_terminal = true
  vim.b[state.buf].agent_cmd = cmd
  pcall(vim.api.nvim_buf_set_name, state.buf, "agent://" .. cmd)
  vim.fn.termopen(cmd, { cwd = state.dir })
  vim.bo[state.buf].filetype = "agent_terminal"
end

function M.agent(cmd)
  local id = "agent|" .. cmd
  agents[id] = agents[id] or { dir = cwd() }
  local state = agents[id]

  if state.win and vim.api.nvim_win_is_valid(state.win) then
    close_agent(state)
    return
  end

  require("config.layout").focus_main()
  vim.cmd(("belowright vertical %dsplit"):format(agent_width or default_agent_width()))
  state.win = vim.api.nvim_get_current_win()
  apply_agent_window(state.win)

  if state.buf and vim.api.nvim_buf_is_valid(state.buf) then
    vim.api.nvim_win_set_buf(state.win, state.buf)
    vim.bo[state.buf].filetype = "agent_terminal"
  else
    create_agent_buffer(state, cmd)
  end

  vim.b[state.buf].agent_terminal = true
  vim.schedule(remember_panel_sizes)
  vim.cmd.startinsert()
end

return M
