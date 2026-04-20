# Modern Neovim Config

一个基于 `lazy.nvim` 的现代化 Neovim 配置。

## 特性

- `tokyonight` 主题
- `treesitter` 高亮与缩进
- `snacks.nvim` dashboard / explorer / picker / terminal / lazygit / notifier / zen / scratch / statuscolumn
- `mason` + `lspconfig` 语言服务器管理
- 自动识别项目根目录，避免从非项目根启动时 LSP / formatter 找错工作目录
- `conform.nvim` 自动格式化
- `nvim-lint` 代码检查
- `nvim-cmp` + `LuaSnip` 补全，Copilot ghost text 内联建议
- `cmp-cmdline` / `cmp-dictionary` / `lspkind-nvim` 命令行补全、字典补全与补全图标
- Codex / Claude / Gemini / OpenCode 终端 agent 快捷入口
- `bufferline.nvim` 顶部标签栏
- `diffview.nvim` Git diff / file history / merge 视图
- `flash.nvim` 快速跳转
- `glance.nvim` 定义 / 引用 / 实现 / 类型定义面板
- `git-conflict.nvim` 冲突选择助手
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
- `nvim-highlight-colors` 内联高亮颜色码（含 Tailwind）
- Tailwind CSS / React 语言服务
- Markdown 渲染与浏览器预览
- `lualine` 状态栏
- `gitsigns` Git 标记

## 安装

### 1. 前置依赖

- `neovim` 0.12+
- `git`
- `curl`
- `gcc` / `clang` / `make`
- `node` / `npm` / `npx`
- `ripgrep`
- `fd`
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
:TSInstall bash bibtex c cmake cpp css dockerfile elm go html http javascript json latex lua make matlab menhir markdown markdown_inline nginx powershell python query regex rust sql systemverilog toml tsx typescript vue vim vimdoc yaml
```

### 5. 安装 LSP 和格式化工具

执行：

```vim
:Mason
```

确认这些工具已安装：

- LSP: `bashls` `clangd` `docker_compose_language_service` `dockerls` `elmls` `emmet_language_server` `gopls` `html` `cssls` `lua_ls` `matlab_ls` `neocmake` `basedpyright` `rust_analyzer` `sqlls` `tailwindcss` `taplo` `texlab` `verible` `vtsls` `vue_ls` `jsonls` `yamlls`
- Formatter / Linter: `bibtex-tidy` `checkmake` `shfmt` `shellcheck` `stylua` `prettierd` `cmakelang` `cmake-lint` `gersemi` `hadolint` `eslint_d` `elm-format` `elm-review` `miss_hit` `nginx-config-formatter` `sql-formatter` `sqlfluff` `stylelint` `taplo` `tex-fmt` `verible` `ruff` `clang-format` `clang-tidy` `gofumpt` `goimports` `golangci-lint`

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

- `<Space>e`：切换文件树
- `<Space>ff`：查找文件
- `<Space>fg`：全文搜索
- `<Space>fb`：切换缓冲区
- `<Space>fh`：帮助文档
- `<Space>fr`：最近文件
- `<Space>fG`：全文搜索到 quickfix
- `<Space>/`：查看键位列表
- `<Space>ac`：打开 Claude agent
- `<Space>ax`：打开 Codex agent
- `<Space>ag`：打开 Gemini agent
- `<Space>ao`：打开 OpenCode agent
- `<Space>ay`：复制让 agent 读取 quickfix 的英文提示
- Agent 启动时如果 quickfix 非空，只会自动导出到 `.nvim/quickfix.md`，不会自动发送执行提示
- Agent 或其他外部工具修改文件后，Neovim 会在焦点切换、进入 buffer、终端退出 / 离开、CursorHold 时检查并自动读取磁盘更新
- 如果 buffer 有未保存修改且磁盘也被外部修改，Neovim 会提示选择处理方式，不会静默覆盖
- 离开当前文件 buffer、切换分区或 Neovim 失焦时，会自动保存已修改的普通文件 buffer
- `<Space>bd`：关闭当前标签；如果这是最后一个文件，则按关闭处理
- `<Space>bp`：固定当前标签
- `<Space>bo`：关闭其他标签
- `<Space>jj`：Flash 快速跳转
- `<Space>jt`：Flash treesitter 跳转
- `<Space>jR`：Flash 远程操作
- `<Space>js`：Flash treesitter 搜索
- `<Space>sd`：当前文件符号
- `<Space>sw`：工作区符号
- `<Space>ft`：搜索 TODO 注释
- `<Space>fq`：TODO quickfix 列表
- `<Space>gg`：打开 lazygit
- `<Space>gB`：在浏览器打开当前 Git 位置
- `<Space>gd`：打开 Diffview
- `<Space>gh`：查看当前文件历史
- `<Space>gm`：打开 merge/diff 视图
- `<Space>gq`：查找冲突文件并写入 quickfix
- `<Space>dd`：切换数据库 UI
- `<Space>da`：添加数据库连接
- `<Space>df`：查找数据库查询 buffer
- `<Space>tt`：打开浮动终端
- `<Space>th`：打开横向终端
- `<Space>tv`：打开纵向终端
- `<C-Up>` / `<C-Down>` / `<C-Left>` / `<C-Right>`：调整当前分屏大小
- `<Space>z`：Zen 模式
- `<Space>.`：切换 scratch
- `<Space>S`：scratch 列表
- `<Space>nn`：通知历史
- `<Space>nd`：清空通知
- `<Space>h`：查看键位列表
- `<Space>p`：Markdown 文件切换 MarkdownPreview，其他文件用外部程序预览图片 / PDF / 音频 / 视频 / HTML
- `<Space>ii`：插入剪贴板图片
- `<Space>hh`：切换 HTML live server
- `<Space>hs`：启动 HTML live server
- `<Space>hS`：关闭 HTML live server
- `<Space>he`：Emmet 包裹缩写（html/css/jsx/tsx/vue）
- `<Space>ic`：补全文献引用
- `<Space>ss`：切换符号大纲
- `<Space>rr`：选择并运行项目任务
- `<Space>rt`：切换任务列表
- `<Space>rl`：重新运行上一次任务
- `<Space>rq`：选择并运行项目任务，输出写入 quickfix
- `<Space>ra`：当前任务操作菜单
- `<Space>us`：发送当前 HTTP 请求
- `<Space>ua`：发送当前 buffer 的所有 HTTP 请求
- `<Space>ur`：重放上一次 HTTP 请求
- `<Space>uo`：打开 HTTP 响应 UI
- `<Space>uf`：查找命名 HTTP 请求
- `<Space>ub`：打开 HTTP 请求 scratchpad
- `<Space>uc`：复制当前请求为 curl
- `<Space>la`：Code action
- `<Space>le`：Emmet 包裹缩写（html/css/jsx/tsx/vue）
- `<Space>lf`：格式化当前文件
- `<Space>lr`：重命名符号
- `<Space>lq`：当前会话已知诊断写入 quickfix
- `<Space>vc`：编译 LaTeX
- `<Space>vv`：查看 PDF
- `<Space>vs`：停止 LaTeX 编译
- `<Space>vC`：清理 LaTeX 辅助文件
- `<Space>ve`：显示 LaTeX 错误
- `<Space>vt`：切换 LaTeX TOC
- `<Space>vi`：显示 LaTeX 信息
- `<Space>gcc`：冲突块选择 current
- `<Space>gci`：冲突块选择 incoming
- `<Space>gcb`：冲突块保留双方
- `<Space>gcn`：冲突块全删
- `<Space>xx`：打开诊断面板
- `<Space>xX`：打开当前 buffer 诊断面板
- `<Space>xq`：打开 quickfix 面板
- `<Space>xQ`：切换原生 quickfix 窗口
- `<Space>xw`：写出 quickfix 到 `.nvim/quickfix.md`
- `<Space>xy`：复制 quickfix 到剪贴板
- `<Space>xl`：打开 location list 面板
- `<Space>xs`：打开 symbols 面板
- `<Space>jd` / `<Space>jr` / `<Space>ji` / `<Space>jy`：定义 / 引用 / 实现 / 类型定义面板
- `[c`：跳到当前顶部上下文
- `[d` / `]d`：切换上一个/下一个 diagnostic
- `[h` / `]h`：切换上一个/下一个 git hunk
- `[q` / `]q`：切换上一个/下一个 quickfix
- `[t` / `]t`：切换上一个/下一个 TODO
- `[x` / `]x`：切换上一个/下一个冲突标记
- `[r` / `]r`：切换上一个/下一个引用
- `zR` / `zM`：打开 / 关闭所有折叠
- `<Esc><Esc>`：退出终端模式
- `/` / `?` / `:`：启用命令行补全
- `af` / `if`：选择函数外层 / 内层
- `ac` / `ic`：选择类外层 / 内层
- `aa` / `ia`：选择参数外层 / 内层
- `vim-visual-multi` 默认多光标键位：`<C-n>` 逐个选择、`n/N` 跳下一个/上一个

## LaTeX

- 已启用 `vimtex` 和 `texlab`
- `LuaSnip + friendly-snippets` 会直接提供 LaTeX snippets
- 默认使用 `latexmk` 编译，`zathura` 预览 PDF
- 常用操作放在 `<Space>v` 的 `latex` 组

## 学术写作

- 已启用 `render-markdown.nvim`，Markdown / Quarto 写作时可直接获得内联渲染
- 已启用 `cmp-pandoc-references`，在 Markdown / LaTeX / Quarto 中用 `<Space>ic` 触发文献引用补全
- 文献补全依赖 Pandoc / Quarto 文档里的 `bibliography:` 元数据；如果文档没有指向 `.bib` 文件，补全列表会为空

## Images

- 已启用 `image.nvim`，在 `markdown` 文件里可直接在终端显示图片
- 已启用 `img-clip.nvim`，可把剪贴板图片嵌入 `markdown` / `tex`

## Git Conflict

- `<Space>gq` 查找冲突文件并写入 quickfix
- `[x` / `]x` 跳冲突位置
- `<Space>gcc` / `<Space>gci` / `<Space>gcb` / `<Space>gcn` 直接处理当前冲突块
- `<Space>gm` 打开 `Diffview` merge 视图
- `<Space>gg` 打开 `lazygit`
