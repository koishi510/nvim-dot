# Modern Neovim Config

一个基于 `lazy.nvim` 的现代化 Neovim 配置。

## 特性

- `tokyonight` 主题
- `treesitter` 高亮与缩进
- `snacks.nvim` dashboard / explorer / picker / terminal / lazygit / notifier / zen / scratch / statuscolumn
- `mason` + `lspconfig` 语言服务器管理
- `conform.nvim` 自动格式化
- `nvim-lint` 代码检查
- `nvim-cmp` + `LuaSnip` 自动补全
- `cmp-cmdline` / `cmp-dictionary` / `lspkind-nvim` 命令行补全、字典补全与补全图标
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
- `vimwiki` + `taskwiki` 知识管理与任务流
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
- `taskwarrior`

如果你要使用系统剪贴板，还需要安装：

- Wayland: `wl-clipboard`
- X11: `xclip` 或 `xsel`

如果你要使用 LaTeX 预览，还需要安装一个 PDF 查看器，例如：

- Linux: `zathura`

如果你要使用 `taskwiki`，还需要 Python 包：

```bash
pip install tasklib pynvim
```

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
:TSInstall bash bibtex c cpp html css javascript json latex lua markdown markdown_inline python rust go typescript tsx vue yaml
```

### 5. 安装 LSP 和格式化工具

执行：

```vim
:Mason
```

确认这些工具已安装：

- LSP: `bashls` `clangd` `gopls` `lua_ls` `basedpyright` `rust_analyzer` `texlab` `vtsls` `vue_ls` `html` `cssls` `jsonls` `yamlls`
- Formatter / Linter: `shfmt` `shellcheck` `stylua` `prettierd` `eslint_d` `ruff` `clang-format` `gofumpt` `goimports`

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
- `<Space>bd`：关闭当前标签；如果这是最后一个文件，则按关闭处理
- `<Space>bp`：固定当前标签
- `<Space>bo`：关闭其他标签
- `<Space>f`：格式化当前文件
- `<Space>jj`：Flash 快速跳转
- `<Space>jt`：Flash treesitter 跳转
- `<Space>jr`：Flash 远程操作
- `<Space>js`：Flash treesitter 搜索
- `<Space>o`：切换符号大纲
- `<Space>sd`：当前文件符号
- `<Space>sw`：工作区符号
- `<Space>ip`：粘贴剪贴板图片
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
- `<Space>tg`：在终端中打开 lazygit
- `<C-Up>` / `<C-Down>` / `<C-Left>` / `<C-Right>`：调整当前分屏大小
- `<Space>z`：Zen 模式
- `<Space>.`：切换 scratch
- `<Space>S`：scratch 列表
- `<Space>nh`：通知历史
- `<Space>nd`：清空通知
- `<Space>hc`：查看键位列表
- `<Space>mp`：切换 Markdown 预览
- `<Space>uc`：切换顶部代码上下文
- `<Space>co`：冲突块选择 ours
- `<Space>ct`：冲突块选择 theirs
- `<Space>cb`：冲突块保留双方
- `<Space>cn`：冲突块全删
- `<Space>xx`：打开诊断面板
- `<Space>xX`：打开当前 buffer 诊断面板
- `<Space>xq`：打开 quickfix 面板
- `<Space>xl`：打开 location list 面板
- `<Space>xs`：打开 symbols 面板
- `<Space>ww`：打开 wiki 首页
- `<Space>wd`：打开 wiki 日记
- `<Space>wn`：创建今天的 wiki 日记
- `<Space>wt`：在新标签页打开 wiki 首页
- `gd` / `gr` / `gs` / `gy`：定义 / 引用 / 实现 / 类型定义面板
- `[c`：跳到当前顶部上下文
- `[h` / `]h`：切换上一个/下一个 git hunk
- `[t` / `]t`：切换上一个/下一个 TODO
- `[x` / `]x`：切换上一个/下一个冲突标记
- `[[` / `]]`：切换上一个/下一个引用
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
- 常用 `vimtex` 操作：
  - `\ll`：编译
  - `\lv`：查看 PDF
  - `\lk`：上一条错误
  - `\lj`：下一条错误

## Knowledge

- 已启用 `vimwiki`，默认路径是 `~/vimwiki/`
- 默认使用 Markdown 语法，扩展名 `.md`
- 已启用 `taskwiki`，可在 wiki 页面中管理 `Taskwarrior` 任务
- 已启用 `image.nvim`，在 `markdown` / `vimwiki` 文件里可直接在终端显示图片
- 已启用 `img-clip.nvim`，可把剪贴板图片嵌入 `markdown` / `vimwiki` / `tex`
- 常用 wiki 键位：
  - `<Space>ww`：首页
  - `<Space>wd`：日记索引
  - `<Space>wn`：今天的日记
  - `<Space>wt`：在新标签页打开首页

## Git Conflict

- `<Space>gf` 列出所有冲突文件
- `[x` / `]x` 跳冲突位置
- `<Space>co` / `<Space>ct` / `<Space>cb` / `<Space>cn` 处理当前冲突块
- `<Space>gm` 打开 `Diffview` merge 视图
- `<Space>gg` 打开 `lazygit`
