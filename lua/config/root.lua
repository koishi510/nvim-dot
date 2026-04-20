local M = {}

M.start_dir = vim.fs.normalize(vim.fn.getcwd())

local function is_relative(path)
  return not path:match("^/")
end

local function normalize(path)
  if is_relative(path) then
    path = vim.fs.joinpath(vim.fn.getcwd(), path)
  end
  return vim.fs.normalize(path)
end

function M.contains(path)
  path = normalize(path)

  if path == M.start_dir then
    return true
  end

  if M.start_dir == "/" then
    return vim.startswith(path, "/")
  end

  return vim.startswith(path, M.start_dir .. "/")
end

function M.find(names, opts)
  opts = opts or {}
  names = type(names) == "table" and names or { names }

  local dir = normalize(opts.path or vim.fn.getcwd())
  if not M.contains(dir) then
    return nil
  end

  while M.contains(dir) do
    for _, name in ipairs(names) do
      local candidate = vim.fs.joinpath(dir, name)
      local stat = vim.uv.fs_stat(candidate)
      if stat and (not opts.type or stat.type == opts.type) then
        return candidate
      end
    end

    if dir == M.start_dir then
      break
    end

    local parent = vim.fs.dirname(dir)
    if parent == dir then
      break
    end
    dir = parent
  end
end

function M.root(path, markers)
  local marker = M.find(markers, { path = path })
  if marker then
    return vim.fs.dirname(marker)
  end
end

function M.buf_dir(bufnr)
  local name = vim.api.nvim_buf_get_name(bufnr or 0)
  local dir = name ~= "" and vim.fs.dirname(name) or vim.fn.getcwd()

  if M.contains(dir) then
    return dir
  end

  return M.start_dir
end

return M
