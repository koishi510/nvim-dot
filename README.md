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
- Formatter / Linter / Language tools: `bibtex-tidy` `checkmake` `shfmt` `shellcheck` `stylua` `prettierd` `cmakelang` `cmake-lint` `gersemi` `hadolint` `eslint_d` `elm-format` `elm-review` `miss_hit` `nginx-config-formatter` `sql-formatter` `sqlfluff` `stylelint` `taplo` `tex-fmt` `verible` `ruff` `clang-format` `clang-tidy` `gofumpt` `goimports` `golangci-lint` `gomodifytags` `gotests` `iferr` `impl` `fourmolu`
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

- `<Space>ww`：保存文件
- `<Space>wq`：关闭当前窗口
- `<Space>wh/wj/wk/wl`：聚焦左 / 下 / 上 / 右窗口
- `<Space>wH/wJ/wK/wL`：缩小宽度 / 缩小高度 / 增大高度 / 增大宽度
- `<Space>w=`：均分窗口大小
- `<Space>ws` / `<Space>wv`：横向切分 / 纵向切分
- `<Space>wmh/wmj/wmk/wml`：移动当前窗口到最左 / 底部 / 顶部 / 最右
- `<A-h/j/k/l>`：聚焦左 / 下 / 上 / 右窗口
- `<A-H/J/K/L>`：缩小宽度 / 缩小高度 / 增大高度 / 增大宽度
- `<Space>/`：查看键位列表
- `<Space>ff` / `<Space>fg` / `<Space>fb`：查找文件 / 全文搜索 / buffer
- `<Space>fh` / `<Space>fr` / `<Space>fc` / `<Space>fk`：帮助 / 最近文件 / 命令 / 键位搜索
- `<Space>fG`：全文搜索到 quickfix
- `<Space>fR` / `<Space>fW` / `<Space>fF`：项目替换 / 替换光标下单词 / 当前文件替换
- `<Space>ft` / `<Space>fq`：TODO 搜索 / TODO quickfix
- `<Space>at` / `<Space>aa` / `<Space>aA`：CodeCompanion chat / actions / visual selection 加入 chat
- `<Space>ac` / `<Space>ax` / `<Space>ag` / `<Space>ao`：打开 Claude / Codex / Gemini / OpenCode agent
- `<Space>ay`：复制让 agent 读取 quickfix 的英文提示
- Agent 启动时如果 quickfix 非空，只会自动导出到 `.nvim/quickfix.md`，不会自动发送执行提示
- Agent 或其他外部工具修改文件后，Neovim 会在焦点切换、进入 buffer、终端退出 / 离开、CursorHold 时检查并自动读取磁盘更新
- 如果 buffer 有未保存修改且磁盘也被外部修改，Neovim 会提示选择处理方式，不会静默覆盖
- 离开当前文件 buffer、切换分区或 Neovim 失焦时，会自动保存已修改的普通文件 buffer
- `<Space>bd` / `<Space>bp` / `<Space>bo`：关闭当前 buffer / 固定 buffer / 关闭其他 buffer
- `<A-q>` / `<A-i>` / `<A-o>`：关闭 buffer / 下一个 buffer / 上一个 buffer
- `<Space>jj`：Flash 快速跳转
- `<Space>jt`：Flash treesitter 跳转
- `<Space>jR`：Flash 远程操作
- `<Space>js`：Flash treesitter 搜索
- `<Space>lb` / `<Space>lB`：选择顶部 breadcrumb / 跳到 breadcrumb 上下文开头
- `<Space>ls` / `<Space>lS`：当前文件符号 / 工作区符号
- `<Space>la` / `<Space>ld` / `<Space>lf` / `<Space>lr`：Code action / 当前行诊断 / 格式化 / 重命名
- `<Space>ly` / `<Space>lY` / `<Space>lq` / `<Space>lt`：复制当前行诊断 / 复制 buffer 诊断 / 诊断写入 quickfix / 切换内联诊断
- `K`：LSP hover
- `<Space>lo`：切换符号大纲
- `<Space>lRr` / `<Space>lRd` / `<Space>lRh`：Rust runnables / debuggables / hover actions
- `<Space>lRe` / `<Space>lRc` / `<Space>lRp` / `<Space>lRj`：Rust 宏展开 / 打开 Cargo.toml / parent module / join lines
- `<Space>lgt` / `<Space>lgT` / `<Space>lgc`：Go 测试 package / 测试函数 / coverage
- `<Space>lgf` / `<Space>lgs` / `<Space>lgi` / `<Space>lgI`：Go fill struct / fill switch / if err / impl
- `<Space>lga` / `<Space>lgr` / `<Space>lgm`：Go add tags / remove tags / mod tidy
- `<Space>lHh` / `<Space>lHs` / `<Space>lHS` / `<Space>lHe`：HTML 预览 toggle / start / stop / Emmet wrap
- `<Space>gg`：打开 lazygit
- `<Space>gA`：Advanced Git Search
- `<Space>gB`：在浏览器打开当前 Git 位置
- `<Space>gd`：打开 Diffview
- `<Space>gG`：打开 Fugitive status
- `<Space>gh`：查看当前文件历史
- `<Space>gL`：打开 Git log
- `<Space>gm`：打开 merge/diff 视图
- `<Space>gq`：查找冲突文件并写入 quickfix
- `<Space>gV`：Fugitive 纵向 diff
- `<Space>gw`：Fugitive stage 当前文件
- `<Space>dc` / `<Space>dt` / `<Space>db`：继续或启动调试 / 终止 / 切换断点
- `<Space>dB` / `<Space>dl`：条件断点 / 日志断点
- `<Space>di` / `<Space>do` / `<Space>dO`：Step into / over / out
- `<Space>dr` / `<Space>du` / `<Space>dL`：切换 DAP REPL / DAP UI / 运行上一次配置
- `<F6>` / `<F7>` / `<F8>`：继续 / 终止 / 切换断点
- `<F9>` / `<F10>` / `<F11>`：Step into / out / over
- `<Space>tt`：打开浮动终端
- `<Space>th`：打开横向终端
- `<Space>tv`：打开纵向终端
- `<A-e>`：切换文件树
- `<Space>ue` / `<Space>uE`：切换文件树 / 在文件树中定位当前文件
- `<Space>up`：预览当前文件，Markdown 时切换 MarkdownPreview
- `<Space>uz`：Zen 模式
- `<Space>u.` / `<Space>uS`：scratch / scratch 列表
- `<Space>un` / `<Space>uN`：通知历史 / 清空通知
- `<Space>uD` / `<Space>uA` / `<Space>uF`：数据库 UI / 添加连接 / 查找数据库查询 buffer
- `<Space>pu` / `<Space>pc` / `<Space>pt`：升级包或 crate / 选择版本 / 开关版本显示
- `<Space>pd` / `<Space>pi`：删除包 / 安装包（仅 npm）
- `<Space>pf` / `<Space>po`：crate features 面板 / 打开 crates.io 页面
- `<Space>ss` / `<Space>sl` / `<Space>sL`：保存 session / 加载 session / 加载最近 session
- `<Space>sd` / `<Space>st`：删除 session / 切换 session 自动保存
- `<Space>mc` / `<Space>mv` / `<Space>mx`：编译 LaTeX / 查看 PDF / 停止编译
- `<Space>mC` / `<Space>me` / `<Space>mt` / `<Space>mi`：清理 LaTeX / 显示错误 / TOC / 信息
- `<Space>mr`：切换当前 Markdown buffer 的内联渲染
- `<Space>mp` / `<Space>mP`：用 `md-to-pdf` / `pandoc` 导出 Markdown PDF
- `<F12>`：Markdown 预览
- `<Space>ms`：切换拼写检查
- `<Space>mI`：插入剪贴板图片
- `<Space>mB`：补全文献引用
- `<Space>rr`：选择并运行项目任务，输出写入 quickfix
- `<Space>rt`：切换任务列表
- `<Space>rl`：重新运行上一次任务
- `<Space>ra`：当前任务操作菜单
- `<Space>us`：发送当前 HTTP 请求
- `<Space>ua`：发送当前 buffer 的所有 HTTP 请求
- `<Space>ur`：重放上一次 HTTP 请求
- `<Space>uo`：打开 HTTP 响应 UI
- `<Space>uf`：查找命名 HTTP 请求
- `<Space>ub`：打开 HTTP 请求 scratchpad
- `<Space>uc`：复制当前请求为 curl
- `<Space>gcc`：冲突块选择 current
- `<Space>gci`：冲突块选择 incoming
- `<Space>gcb`：冲突块保留双方
- `<Space>gcn`：冲突块全删
- `<Space>xx`：打开诊断面板
- `<Space>xd`：当前文件诊断搜索
- `<Space>xD`：工作区诊断搜索
- `<Space>xX`：打开当前 buffer 诊断面板
- `<Space>xq`：打开 quickfix 面板
- `<Space>xQ`：切换原生 quickfix 窗口
- `<Space>xw`：写出 quickfix 到 `.nvim/quickfix.md`
- `<Space>xy`：复制 quickfix 到剪贴板
- `<Space>xl`：打开 location list 面板
- `<Space>xs`：打开 symbols 面板
- `<Space>jd` / `<Space>jr` / `<Space>ji` / `<Space>jy`：定义预览 / 引用查找 / 实现查找 / 类型定义预览
- `<C-w>h/j/k/l`：原生窗口聚焦移动
- `<C-w>+/-/>/<`：原生窗口缩放；也可用鼠标拖动分割线
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
- 常用操作放在 `<Space>m` 的 `writing` 组

## 学术写作

- 已启用 `render-markdown.nvim`，Markdown / Quarto 写作时可直接获得内联渲染
- 已启用 `cmp-pandoc-references`，在 Markdown / LaTeX / Quarto 中用 `<Space>mB` 触发文献引用补全
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
