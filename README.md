# Modern Neovim Config

一个基于 `lazy.nvim` 的现代化 Neovim 配置。

## 特性

- `tokyonight` 主题
- `treesitter` 高亮与缩进
- `snacks.nvim` dashboard / lazygit / notifier / zen / scratch / statuscolumn
- `fzf-lua` 高性能文件、全文、buffer、符号、诊断、键位搜索
- `nvim-tree.lua` 文件树
- `toggleterm.nvim` 浮动终端；内置右侧 / 底部项目根终端与右侧 agent 终端面板
- `mason` + `lspconfig` 语言服务器管理
- 每个 LSP server 独立从 buffer 路径往上查找 root marker，自动适配 monorepo / 全栈项目的子目录
- 终端、lazygit、agent 启动时自动使用当前 buffer 的项目根作为 cwd，Neovim 自身的工作目录不变
- `conform.nvim` 自动格式化
- `nvim-lint` 代码检查
- `nvim-cmp` + `LuaSnip` 补全，Copilot ghost text 内联建议
- `cmp-cmdline` / `cmp-dictionary` / `lspkind-nvim` 命令行补全、字典补全与补全图标
- Codex / Claude / Gemini / OpenCode 终端 agent 快捷入口
- `bufferline.nvim` 顶部标签栏
- 文件树 / DBUI / Diffview 文件栏走左侧固定区，agent / 右侧终端 / chat / API 结果 / outline / debug 走右侧固定区，quickfix / diagnostics / task / 底部终端走底部固定区，查找 picker 走主编辑区底部浮窗
- buffer 标签栏避开文件树、数据库、Git 文件栏、右侧 agent / terminal / chat / outline / debug 侧栏
- `diffview.nvim` Git diff / file history / merge 视图
- `flash.nvim` 快速跳转
- `lspsaga.nvim` hover / code action / rename / 定义预览 / 引用与实现查找
- `tiny-inline-diagnostic.nvim` 内联诊断显示
- `glance.nvim` 定义 / 引用 / 实现 / 类型定义面板命令保留
- `vim-fugitive` + `advanced-git-search.nvim` 深度 Git 操作与历史搜索
- `git-conflict.nvim` 冲突选择助手
- `nvim-dap` + `nvim-dap-ui` 调试 C / C++ / Rust / Go / Python
- `rustaceanvim` Rust runnables / debuggables / hover actions / 宏展开
- `go.nvim` Go 测试、覆盖率、结构体填充、tags、if err、接口实现
- `grug-far.nvim` 项目级搜索替换面板
- `nvim-bqf` quickfix 预览增强
- `persisted.nvim` 项目 session 保存与恢复
- `dropbar.nvim` 顶部 breadcrumb / 上下文导航
- `codecompanion.nvim` 编辑器内 AI chat / actions / visual selection 入会话，带历史记录
- `img-clip.nvim` 粘贴剪贴板图片
- `im-select.nvim` 自动切换输入法
- `image.nvim` 终端内图片显示
- `mini.ai` 文本对象增强
- `nvim-ufo` 代码折叠
- `outline.nvim` 符号大纲
- `nvim-treesitter-context` 顶部上下文
- `nvim-ts-autotag` HTML/JSX/Vue 标签自动闭合与联动重命名
- `nvim-surround` 包裹 / 修改 / 删除配对符号与标签
- `vim-matchup` 增强 `%` 匹配，支持语言结构与 HTML 标签
- `vim-sleuth` 自动识别项目缩进风格
- `smartyank.nvim` 支持 tmux / SSH 场景下的剪贴板同步
- `todo-comments.nvim` TODO 高亮与搜索
- `trouble.nvim` 诊断与列表面板
- `vimtex` + `texlab` LaTeX 支持
- `vim-visual-multi` 多光标编辑
- `overseer.nvim` 项目任务运行器
- `vim-dadbod` + `vim-dadbod-ui` 数据库连接、查询与表结构浏览
- `kulala.nvim` HTTP / API 请求调试
- `cmp-pandoc-references` Markdown / LaTeX 文献引用补全
- HTML 浏览器实时预览
- `nvim-emmet` Emmet 包裹与 LSP 内联展开
- `package-info.nvim` 在 package.json 内联显示 npm 版本
- `crates.nvim` 在 Cargo.toml 内联显示 crate 版本
- `nvim-highlight-colors` 内联高亮颜色码（含 Tailwind）
- Tailwind CSS / React 语言服务
- Markdown 渲染与浏览器预览
- `lualine` 状态栏
- `gitsigns` Git 标记
- 大文件模式：超过 2 MiB 或 20000 行时跳过 Treesitter / LSP / diagnostics / format / lint / expensive folds

## 安装

### 1. 前置依赖

- `neovim` 0.12+
- `git`
- `curl`
- `gcc` / `clang` / `make`
- `node` / `npm` / `npx`
- `ripgrep`
- `fd`
- `fzf`
- `lazygit`
- LaTeX 工具链: `latexmk`
- `ImageMagick`
- `imv`
- `mpv`
- `taskwarrior`

如果你要使用系统剪贴板，还需要安装：

- Wayland: `wl-clipboard`
- X11: `xclip` 或 `xsel`

如果你要使用 LaTeX 预览，还需要安装一个 PDF 查看器，例如：

- Linux: `zathura`

### 2. 放置配置目录

如果你已经有旧配置，建议先备份：

```bash
mv ~/.config/nvim ~/.config/nvim.bak
```

然后把这套配置放到：

```bash
~/.config/nvim
```

例如：

```bash
git clone <your-repo-url> ~/.config/nvim
```

### 3. 首次启动

直接执行：

```bash
nvim
```

首次启动时会自动：

- 安装 `lazy.nvim`
- 拉取插件
- 安装部分 Mason 工具

安装完成后建议执行一次：

```vim
:Lazy sync
```

### 4. 安装语言解析器

```vim
:TSInstall bash bibtex c cmake cpp css dockerfile elm go haskell html http javascript json latex lua make matlab menhir markdown markdown_inline nginx powershell python query regex rust sql systemverilog toml tsx typescript vue vim vimdoc yaml
```

### 5. 安装 LSP 和格式化工具

执行：

```vim
:Mason
```

确认这些工具已安装：

- LSP: `bashls` `clangd` `docker_compose_language_service` `dockerls` `elmls` `emmet_language_server` `gopls` `hls` `html` `cssls` `lua_ls` `matlab_ls` `neocmake` `basedpyright` `rust_analyzer` `sqlls` `tailwindcss` `taplo` `texlab` `verible` `vtsls` `vue_ls` `jsonls` `yamlls`
- Formatter / Linter / Language tools: `bibtex-tidy` `checkmake` `shfmt` `shellcheck` `stylua` `prettierd` `cmakelang` `cmake-lint` `gersemi` `hadolint` `eslint_d` `elm-format` `elm-review` `miss_hit` `nginx-config-formatter` `sql-formatter" "sqlfluff" "stylelint" "taplo" "tex-fmt" "verible" "ruff" "clang-format" "clang-tidy" "gofumpt" "goimports" "golangci-lint" "gomodifytags" "gotests" "iferr" "impl" "fourmolu"
- DAP: `codelldb` `delve` `python`

nginx LSP 使用系统提供的 `nginx-language-server`，不由 Mason 安装。
Elm lint 使用外部安装的 `elm-review`。
C/C++ lint 使用系统提供的 `clang-tidy`。
SQL lint 只会在项目根目录存在 `.sqlfluff` 时启用。

Rust 诊断通过 `rust_analyzer` 使用 `cargo clippy`。

### 6. 可选检查

```vim
:checkhealth
:Lazy
:Mason
```

## 常用快捷键

### 窗口管理
- `<Space>ww`：保存文件
- `<Space>wq`：关闭当前窗口
- `<Space>ws` / `<Space>wv`：横向切分 / 纵向切分
- `<Space>w=`：均分窗口大小
- `<A-h/j/k/l>`：聚焦左 / 下 / 上 / 右窗口
- `<A-H/J/K/L>`：调整窗口大小 (左 / 下 / 上 / 右)

### 文件与搜索
- `<Space>e` / `<Space>E`：切换文件树 / 在树中定位当前文件
- `<Space>ff` / `<Space>fg` / `<Space>fb`：查找文件 / 全文搜索 / Buffer
- `<Space>fr` / `<Space>fc` / `<Space>fk` / `<Space>fh`：最近文件 / 命令 / 键位 / 帮助
- `<Space>fR` / `<Space>fw` / `<Space>fF`：项目替换 / 替换光标单词 / 当前文件替换
- `<Space>ft` / `<Space>fq`：TODO 搜索 / TODO quickfix

### 代码与语言服务 (LSP)
- `<Space>ca` / `<Space>cr` / `<Space>cf`：Code action / 重命名 / 格式化
- `<Space>cs` / `<Space>cS`：当前文件符号 / 工作区符号
- `<Space>cd` / `<Space>cy` / `<Space>cY`：行诊断 / 复制行诊断 / 复制 Buffer 诊断
- `<Space>cl` / `<Space>cq` / `<Space>ct`：手动 Lint / 诊断 quickfix / 切换内联诊断
- `<Space>co` / `<Space>cc`：切换符号大纲 / 切换代码上下文 (TSContext)
- `<Space>cb` / `<Space>cB`：面包屑导航 (Dropbar)
- `K`：LSP hover (悬停信息)
- `[d` / `]d`：上一个 / 下一个诊断
- `[r` / `]r`：上一个 / 下一个引用
- `<Space>jd` / `<Space>jr` / `<Space>ji` / `<Space>jy`：定义预览 / 引用查找 / 实现查找 / 类型定义预览

### AI 与 Agent
- `<Space>at` / `<Space>aa` / `<Space>aA`：AI chat / actions / 加入会话
- `<Space>ac` / `<Space>ax` / `<Space>ag` / `<Space>ao`：Claude / Codex / Gemini / OpenCode agent
- `<Space>ay`：复制 agent 读取 quickfix 的提示词

### Git
- `<Space>gg`：打开 lazygit
- `<Space>ga` / `<Space>gB`：Git 高级搜索 / 浏览器打开位置
- `<Space>gd` / `<Space>gm` / `<Space>gh`：Diffview / Merge 视图 / 文件历史
- `<Space>gq`：搜索冲突并写入 quickfix
- `[h` / `]h`：上一个 / 下一个 Git hunk
- `[x` / `]x`：上一个 / 下一个冲突
- `<Space>gcc` / `<Space>gci` / `<Space>gcb`：冲突处理 (Current / Incoming / Both)

### 语言特定 (Language Specific)
- **Database (`<leader>ld`)**: `<leader>ldd` (UI) / `<leader>lda` (Add) / `<leader>ldf` (Find)
- **HTTP (`<leader>lH`)**: `<leader>lHs` (Send) / `<leader>lHa` (All) / `<leader>lHo` (UI)
- **Rust (`<leader>lr`)**: `<leader>lrr` (Run) / `<leader>lrd` (Debug) / `<leader>lrc` (Cargo.toml)
- **Go (`<leader>lg`)**: `<leader>lgt` (Test) / `<leader>lgc` (Coverage) / `<leader>lgi` (if err)
- **HTML (`<leader>lh`)**: `<leader>lhs` (Start preview) / `<leader>lhS` (Stop) / `<leader>lhe` (Emmet)

### 写作与工具
- `<Space>mi`：插入剪贴板图片
- `<Space>mI`：显示 LaTeX 信息
- `<Space>mc` / `<Space>mv` / `<Space>mt`：LaTeX 编译 / 预览 / TOC
- `<Space>mb`：补全文献引用
- `<Space>z` / `<Space>zs`：Zen 模式 / 草稿列表
- `<Space>xn` / `<Space>xN`：通知历史 / 清除通知
- `<Space>v`：系统应用预览文件
- `<Space>L`：打开 Lazy UI
- `<Space>rr` / `<Space>rl`：运行项目任务 / 重试上一个任务

### 其他
- `<S-h>` / `<S-l>`：上一个 / 下一个 Buffer
- `<A-q>`：关闭当前 Buffer
- `<Esc><Esc>`：退出终端模式
- `zR` / `zM`：打开 / 关闭所有折叠

## LaTeX

- 已启用 `vimtex` 和 `texlab`
- 默认使用 `latexmk` 编译，`zathura` 预览 PDF

## 学术写作

- 已启用 `render-markdown.nvim` 内联渲染
- 文献补全依赖 Pandoc / Quarto 里的 `bibliography:` 元数据

## Images

- 已启用 `image.nvim` 终端图片显示
- 已启用 `img-clip.nvim` 粘贴图片
