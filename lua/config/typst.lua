local M = {}

local watcher = nil
local stopping = false

local function current_file()
  local file = vim.api.nvim_buf_get_name(0)

  if file == "" then
    vim.notify("No Typst file", vim.log.levels.WARN)
    return nil
  end

  if vim.fn.fnamemodify(file, ":e"):lower() ~= "typ" then
    vim.notify("Current file is not Typst", vim.log.levels.WARN)
    return nil
  end

  return file
end

local function output_pdf(file)
  return vim.fn.fnamemodify(file, ":r") .. ".pdf"
end

local function executable(name)
  if vim.fn.executable(name) == 0 then
    vim.notify(name .. " is not installed", vim.log.levels.ERROR)
    return false
  end

  return true
end

local function write_if_modified()
  if not vim.bo.modified then
    return true
  end

  local ok, err = pcall(vim.cmd.write)
  if not ok then
    vim.notify("Could not write file: " .. err, vim.log.levels.ERROR)
    return false
  end

  return true
end

function M.compile(callback)
  local file = current_file()

  if not file or not executable("typst") or not write_if_modified() then
    return
  end

  local pdf = output_pdf(file)

  vim.system({ "typst", "compile", file, pdf }, { text = true }, function(result)
    vim.schedule(function()
      if result.code ~= 0 then
        local msg = vim.trim(result.stderr or result.stdout or "Typst compile failed")
        vim.notify(msg, vim.log.levels.ERROR)
        return
      end

      vim.notify("Compiled " .. vim.fn.fnamemodify(pdf, ":t"), vim.log.levels.INFO)

      if callback then
        callback(pdf)
      end
    end)
  end)
end

function M.view()
  if not executable("zathura") then
    return
  end

  M.compile(function(pdf)
    vim.system({ "zathura", pdf }, { detach = true })
  end)
end

function M.watch()
  local file = current_file()

  if not file or not executable("typst") or not write_if_modified() then
    return
  end

  if watcher then
    vim.notify("Typst watch is already running", vim.log.levels.INFO)
    return
  end

  local pdf = output_pdf(file)
  local job = vim.fn.jobstart({ "typst", "watch", file, pdf }, {
    stderr_buffered = true,
    on_stderr = function(_, data)
      local msg = vim.trim(table.concat(data or {}, "\n"))
      if msg ~= "" then
        vim.schedule(function()
          vim.notify(msg, vim.log.levels.ERROR)
        end)
      end
    end,
    on_exit = function(_, code)
      vim.schedule(function()
        watcher = nil
        if stopping then
          stopping = false
          return
        end
        if code ~= 0 then
          vim.notify("Typst watch stopped with code " .. code, vim.log.levels.WARN)
        end
      end)
    end,
  })

  if job <= 0 then
    vim.notify("Could not start Typst watch", vim.log.levels.ERROR)
    return
  end

  watcher = job
  vim.notify("Typst watch started", vim.log.levels.INFO)
end

function M.stop()
  if not watcher then
    vim.notify("Typst watch is not running", vim.log.levels.INFO)
    return
  end

  stopping = true
  vim.fn.jobstop(watcher)
  watcher = nil
  vim.notify("Typst watch stopped", vim.log.levels.INFO)
end

return M
