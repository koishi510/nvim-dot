local M = {}

local defaults = {
  size = 2 * 1024 * 1024,
  lines = 20000,
}

local function disable_diagnostics(bufnr)
  if vim.diagnostic.enable then
    pcall(vim.diagnostic.enable, false, { bufnr = bufnr })
    return
  end

  if vim.diagnostic.disable then
    pcall(vim.diagnostic.disable, bufnr)
  end
end

local function apply_window_options(bufnr)
  for _, win in ipairs(vim.fn.win_findbuf(bufnr)) do
    if vim.api.nvim_win_is_valid(win) then
      vim.wo[win].foldmethod = "manual"
      vim.wo[win].foldexpr = "0"
      vim.wo[win].foldenable = false
      vim.wo[win].list = false
      vim.wo[win].spell = false
      vim.wo[win].wrap = false
    end
  end
end

function M.mark(bufnr, reason)
  if vim.b[bufnr].bigfile then
    return
  end

  vim.b[bufnr].bigfile = true
  vim.b[bufnr].snacks_indent = false
  vim.bo[bufnr].swapfile = false
  vim.bo[bufnr].undofile = false
  vim.bo[bufnr].synmaxcol = 256
  vim.bo[bufnr].syntax = "OFF"
  vim.bo[bufnr].indentexpr = ""

  pcall(vim.treesitter.stop, bufnr)
  disable_diagnostics(bufnr)
  apply_window_options(bufnr)

  if reason then
    vim.schedule(function()
      local name = vim.api.nvim_buf_get_name(bufnr)
      local file = name ~= "" and vim.fn.fnamemodify(name, ":.") or "[No Name]"
      vim.notify("Big file mode: " .. file .. " (" .. reason .. ")", vim.log.levels.INFO)
    end)
  end
end

function M.is_big(bufnr)
  return vim.b[bufnr or 0].bigfile == true
end

function M.setup(opts)
  opts = vim.tbl_extend("force", defaults, opts or {})
  local group = vim.api.nvim_create_augroup("bigfile", { clear = true })

  vim.api.nvim_create_autocmd("BufReadPre", {
    group = group,
    desc = "Mark large files before expensive plugins attach",
    callback = function(args)
      local name = vim.api.nvim_buf_get_name(args.buf)
      if name == "" then
        return
      end

      local stat = vim.uv.fs_stat(name)
      if stat and stat.size > opts.size then
        M.mark(args.buf, string.format("%.1f MiB", stat.size / 1024 / 1024))
      end
    end,
  })

  vim.api.nvim_create_autocmd({ "BufReadPost", "FileType", "BufWinEnter" }, {
    group = group,
    desc = "Keep large files in cheap editing mode",
    callback = function(args)
      if vim.api.nvim_buf_line_count(args.buf) > opts.lines then
        M.mark(args.buf, tostring(vim.api.nvim_buf_line_count(args.buf)) .. " lines")
      elseif M.is_big(args.buf) then
        M.mark(args.buf)
      end
    end,
  })

  vim.api.nvim_create_autocmd("LspAttach", {
    group = group,
    desc = "Detach LSP clients from big files",
    callback = function(args)
      if not M.is_big(args.buf) then
        return
      end

      pcall(vim.lsp.buf_detach_client, args.buf, args.data.client_id)
    end,
  })
end

return M
