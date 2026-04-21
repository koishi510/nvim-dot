local root = require("config.root")

local function overseer_search_params()
  local dir = root.buf_project_root(0) or root.buf_dir(0)

  return {
    dir = dir,
    filetype = vim.bo.filetype,
  }
end

local function ensure_cwd(task_defn, cwd)
  if not task_defn.cwd and cwd then
    task_defn.cwd = cwd
  end
end

local function find_makefile(dir)
  return root.find("Makefile", { path = dir, type = "file" })
end

local function wrap_task_command(task_defn)
  if task_defn.metadata and task_defn.metadata.kill_with_nvim_wrapped then
    return
  end

  if vim.fn.executable("setsid") ~= 1 or vim.fn.executable("bash") ~= 1 then
    return
  end

  local cmd = task_defn.cmd
  if not cmd then
    return
  end

  local args = task_defn.args or {}
  local wrapped = {
    "setsid",
    "bash",
    "-lc",
    table.concat({
      "trap 'trap - EXIT HUP INT TERM; kill -TERM -- -$$ 2>/dev/null; sleep 0.2; kill -KILL -- -$$ 2>/dev/null' EXIT HUP INT TERM",
      '"$@" &',
      "child=$!",
      'wait "$child"',
      "status=$?",
      "trap - EXIT HUP INT TERM",
      'exit "$status"',
    }, "; "),
    "overseer-task",
  }

  if type(cmd) == "string" then
    vim.list_extend(wrapped, { "sh", "-c", cmd })
  else
    vim.list_extend(wrapped, vim.deepcopy(cmd))
  end
  vim.list_extend(wrapped, args)

  task_defn.cmd = wrapped
  task_defn.args = nil
  task_defn.metadata = vim.tbl_extend("force", task_defn.metadata or {}, {
    kill_with_nvim_wrapped = true,
  })
end

local function quickfix_component()
  return {
    "on_output_quickfix",
    items_only = true,
    open_on_match = true,
    open_on_exit = "failure",
  }
end

local function add_quickfix_component(task_defn, util)
  task_defn.components = task_defn.components or { "default" }

  if util and util.add_component then
    util.add_component(task_defn, quickfix_component())
    return
  end

  table.insert(task_defn.components, 1, quickfix_component())
end

local function make_task(makefile, target)
  local overseer = require("overseer")
  local name = target and ("make " .. target) or "make"
  local cmd = target and { "make", target } or { "make" }
  local task_defn = {
    name = name,
    cmd = cmd,
    cwd = vim.fs.dirname(makefile),
  }

  add_quickfix_component(task_defn)
  wrap_task_command(task_defn)

  local task = overseer.new_task(task_defn)

  task:start()
  overseer.open({ enter = false })
end

local function make_targets(makefile)
  local ok, lines = pcall(vim.fn.readfile, makefile)
  if not ok then
    return {}
  end

  local targets = {}
  local seen = {}

  for _, line in ipairs(lines) do
    local name, desc = line:match("^([%w%._%-%/]+)%s*:[^#]*##%s*(.+)$")

    if not name then
      local candidate = line:match("^([%w%._%-%/]+)%s*:")
      if candidate then
        local after = line:match("^[%w%._%-%/]+%s*:%s*(.-)$") or ""
        if after:sub(1, 1) ~= "=" then
          name = candidate
          desc = ""
        end
      end
    end

    if name and not seen[name] and not name:match("^%.") and not name:find("%%") then
      seen[name] = true
      table.insert(targets, {
        name = name,
        desc = desc or "",
      })
    end
  end

  return targets
end

local function run_make(makefile)
  local targets = make_targets(makefile)

  if vim.tbl_isempty(targets) then
    make_task(makefile, nil)
    return
  end

  vim.ui.select(targets, {
    prompt = "Make target:",
    kind = "make_target",
    format_item = function(target)
      if target.desc and target.desc ~= "" then
        return string.format("%-20s %s", target.name, target.desc)
      end
      return target.name
    end,
    snacks = {
      focus = "list",
      win = {
        list = {
          keys = {
            ["<CR>"] = "confirm",
          },
        },
      },
    },
  }, function(target)
    if target then
      make_task(makefile, target.name)
    end
  end)
end

local function run_task()
  local template = require("overseer.template")
  local search_params = overseer_search_params()
  local makefile = find_makefile(search_params.dir)

  if makefile then
    run_make(makefile)
    return
  end

  template.list(search_params, function(templates)
    templates = vim.tbl_filter(function(tmpl)
      return not tmpl.hide
    end, templates)

    if #templates == 0 then
      vim.notify("No Overseer tasks found in " .. search_params.dir, vim.log.levels.WARN)
      return
    end

    require("overseer").run_task({
      search_params = search_params,
      on_build = function(task_defn, util)
        ensure_cwd(task_defn, search_params.dir)
        add_quickfix_component(task_defn, util)
      end,
    }, function(task)
      if task then
        require("overseer").open({ enter = false })
      end
    end)
  end)
end

local function restart_last_task()
  local overseer = require("overseer")
  local task_list = require("overseer.task_list")
  local tasks = overseer.list_tasks({
    status = {
      overseer.STATUS.SUCCESS,
      overseer.STATUS.FAILURE,
      overseer.STATUS.CANCELED,
    },
    sort = task_list.sort_finished_recently,
  })

  if vim.tbl_isempty(tasks) then
    vim.notify("No tasks found", vim.log.levels.WARN)
    return
  end

  overseer.run_action(tasks[1], "restart")
  overseer.open({ enter = false })
end

return {
  {
    "stevearc/overseer.nvim",
    cmd = {
      "OverseerRun",
      "OverseerToggle",
      "OverseerTaskAction",
    },
    opts = {},
    config = function(_, opts)
      local overseer = require("overseer")

      overseer.setup(opts)

      overseer.add_template_hook(nil, function(task_defn)
        wrap_task_command(task_defn)
      end)

      vim.api.nvim_create_autocmd("VimLeavePre", {
        desc = "Stop Overseer tasks before Nvim exits",
        callback = function()
          for _, task in ipairs(overseer.list_tasks({})) do
            if task.status == overseer.STATUS.RUNNING then
              task:dispose(true)
            end
          end
        end,
      })
    end,
    keys = {
      { "<leader>rr", run_task, desc = "Run task" },
      { "<leader>rt", "<cmd>OverseerToggle<cr>", desc = "Toggle tasks" },
      { "<leader>rl", restart_last_task, desc = "Restart task" },
      { "<leader>ra", "<cmd>OverseerTaskAction<cr>", desc = "Task actions" },
    },
  },
}
