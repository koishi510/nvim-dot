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
- `todo-comments.nvim` TODO 高亮与搜索
- `trouble.nvim` 诊断与列表面板
- `vimtex` + `texlab` LaTeX 支持
- `vim-visual-multi` 多光标编辑
- `overseer.nvim` 项目任务运行器
- HTML 浏览器实时预览
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
- Typst 工具链: `typst`
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
:TSInstall bash bibtex c cmake cpp css dockerfile elm go html javascript json latex lua make matlab menhir markdown markdown_inline nginx powershell python query regex rust sql systemverilog toml tsx typescript typst vue vim vimdoc yaml
```

### 5. 安装 LSP 和格式化工具

执行：

```vim
:Mason
```

确认这些工具已安装：

- LSP: `bashls` `clangd` `docker_compose_language_service` `dockerls` `elmls` `gopls` `html` `cssls` `lua_ls` `matlab_ls` `neocmake` `basedpyright` `rust_analyzer` `sqlls` `taplo` `texlab` `tinymist` `verible` `vtsls` `vue_ls` `jsonls` `yamlls`
- Formatter / Linter: `bibtex-tidy` `checkmake` `shfmt` `shellcheck` `stylua` `prettierd` `cmakelang` `cmake-lint` `gersemi` `hadolint` `eslint_d` `elm-format` `elm-review` `miss_hit` `nginx-config-formatter` `sql-formatter` `sqlfluff` `stylelint` `taplo` `tex-fmt` `typstyle` `verible` `ruff` `clang-format` `clang-tidy` `gofumpt` `goimports` `golangci-lint`

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
- `<Space>ac`：打开 Claude agent
- `<Space>ax`：打开 Codex agent
- `<Space>ag`：打开 Gemini agent
- `<Space>ao`：打开 OpenCode agent
- `<Space>bd`：关闭当前标签；如果这是最后一个文件，则按关闭处理
- `<Space>bp`：固定当前标签
- `<Space>bo`：关闭其他标签
- `<Space>jj`：Flash 快速跳转
- `<Space>jt`：Flash treesitter 跳转
- `<Space>jR`：Flash 远程操作
- `<Space>js`：Flash treesitter 搜索
- `<Space>o`：切换符号大纲
- `<Space>sd`：当前文件符号
- `<Space>sw`：工作区符号
- `<Space>ft`：搜索 TODO 注释
- `<Space>fq`：TODO quickfix 列表
- `<Space>gg`：打开 lazygit
- `<Space>gB`：在浏览器打开当前 Git 位置
- `<Space>gd`：打开 Diffview
- `<Space>gh`：查看当前文件历史
- `<Space>gm`：打开 merge/diff 视图
- `<Space>tt`：打开浮动终端
- `<Space>th`：打开横向终端
- `<Space>tv`：打开纵向终端
- `<C-Up>` / `<C-Down>` / `<C-Left>` / `<C-Right>`：调整当前分屏大小
- `<Space>z`：Zen 模式
- `<Space>.`：切换 scratch
- `<Space>S`：scratch 列表
- `<Space>nh`：通知历史
- `<Space>nd`：清空通知
- `<Space>h`：查看键位列表
- `<Space>ph`：切换 HTML 预览
- `<Space>pi`：粘贴剪贴板图片
- `<Space>pm`：切换 Markdown 预览
- `<Space>po`：用外部程序预览当前图片、PDF、音频、视频或 Typst
- `<Space>rr`：选择并运行项目任务
- `<Space>rt`：切换任务列表
- `<Space>rl`：重新运行上一次任务
- `<Space>ra`：当前任务操作菜单
- `<Space>la`：Code action
- `<Space>lf`：格式化当前文件
- `<Space>vc`：编译 LaTeX
- `<Space>vv`：查看 PDF
- `<Space>vs`：停止 LaTeX 编译
- `<Space>vC`：清理 LaTeX 辅助文件
- `<Space>ve`：显示 LaTeX 错误
- `<Space>vt`：切换 LaTeX TOC
- `<Space>vi`：显示 LaTeX 信息
- `<Space>yc`：编译 Typst
- `<Space>yv`：编译并查看 Typst PDF
- `<Space>yw`：监听 Typst 编译
- `<Space>ys`：停止 Typst 监听
- `<Space>co`：冲突块选择 ours
- `<Space>ct`：冲突块选择 theirs
- `<Space>cb`：冲突块保留双方
- `<Space>cn`：冲突块全删
- `<Space>xx`：打开诊断面板
- `<Space>xX`：打开当前 buffer 诊断面板
- `<Space>xq`：打开 quickfix 面板
- `<Space>xQ`：切换原生 quickfix 窗口
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

## Typst

- 已启用 `tinymist` LSP、Treesitter 高亮与 `typstyle` 格式化
- `<Space>y` 是 `typst` 组
- `<Space>po` 在 `.typ` 文件里会先编译，再用 `zathura` 打开同名 PDF
- `image.nvim` 和 `img-clip.nvim` 已支持 Typst 图片

## Images

- 已启用 `image.nvim`，在 `markdown` / `typst` 文件里可直接在终端显示图片
- 已启用 `img-clip.nvim`，可把剪贴板图片嵌入 `markdown` / `tex` / `typst`

## Git Conflict

- `<Space>gf` 列出所有冲突文件
- `[x` / `]x` 跳冲突位置
- `<Space>co` / `<Space>ct` / `<Space>cb` / `<Space>cn` 处理当前冲突块
- `<Space>gm` 打开 `Diffview` merge 视图
- `<Space>gg` 打开 `lazygit`
