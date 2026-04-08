# Modern Neovim Config

一个基于 `lazy.nvim` 的现代化 Neovim 配置，默认提供：

- `tokyonight` 主题
- `neo-tree` 文件树
- `telescope` 模糊查找
- `treesitter` 高亮与缩进
- 自定义 dashboard 首页
- `mason` + `lspconfig` 语言服务器管理
- `conform.nvim` 自动格式化
- `nvim-lint` 代码检查
- `nvim-cmp` + `LuaSnip` 自动补全
- `bufferline.nvim` 顶部标签栏
- `diffview.nvim` Git diff / file history / merge 视图
- `git-conflict.nvim` 冲突选择助手
- `lazygit.nvim` Git 面板
- `toggleterm.nvim` 浮动终端
- Vim/Neovim cheatsheet 查询
- Markdown 渲染与浏览器预览
- `lualine` 状态栏
- `gitsigns` Git 标记

## 安装

### 1. 前置依赖

建议先安装这些基础工具：

- `neovim` 0.12+
- `git`
- `curl`
- `gcc` / `clang` / `make`
- `node` / `npm` / `npx`
- `ripgrep`
- `fd`
- `lazygit`

如果你要使用系统剪贴板，还需要安装：

- Wayland: `wl-clipboard`
- X11: `xclip` 或 `xsel`

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

或者直接复制整个目录过去。

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

`nvim-treesitter` 使用新版接口，解析器需要按需安装，例如：

```vim
:TSInstall c cpp lua python rust go javascript typescript tsx vue html css json yaml markdown markdown_inline
```

### 5. 安装 LSP 和格式化工具

执行：

```vim
:Mason
```

确认这些工具已安装：

- LSP: `clangd` `gopls` `lua_ls` `basedpyright` `rust_analyzer` `vtsls` `vue_ls` `html` `cssls` `jsonls` `yamlls`
- Formatter / Linter: `stylua` `prettierd` `eslint_d` `ruff` `clang-format` `gofumpt` `goimports`

### 6. 可选检查

可以用这些命令确认环境是否正常：

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
- `gd`：跳转定义
- `gr`：查找引用
- `K`：查看悬浮文档
- `<Space>rn`：重命名
- `<Space>ca`：代码操作
- `<Space>bp`：固定当前标签
- `<Space>bo`：关闭其他标签
- `<Space>co`：冲突块选择 ours
- `<Space>ct`：冲突块选择 theirs
- `<Space>cb`：冲突块保留双方
- `<Space>cn`：冲突块全删
- `<Space>f`：格式化当前文件
- `<Space>gd`：打开 Diffview
- `<Space>gf`：列出冲突文件到 quickfix
- `<Space>gg`：打开 lazygit
- `<Space>gh`：查看当前文件历史
- `<Space>gm`：打开 merge/diff 视图
- `<Space>hc`：打开 Vim/Neovim cheatsheet
- `<Space>ll`：手动执行 lint
- `<Space>mp`：切换 Markdown 预览
- `<Space>tt`：打开浮动终端
- `<Space>th`：打开横向终端
- `<Space>tv`：打开纵向终端
- `<Space>tg`：在终端中打开 lazygit
- `<Space>gp`：预览当前 git hunk
- `<Space>gb`：查看当前行 blame
- `[h` / `]h`：切换上一个/下一个 git hunk
- `[x` / `]x`：切换上一个/下一个冲突标记
- `<Esc><Esc>`：退出终端模式

## 首次启动

首次打开 `nvim` 时会自动安装 `lazy.nvim` 和插件。  
安装完语言服务器后，可执行 `:Mason` 管理更多开发工具。

`nvim-treesitter` 使用新版接口，首次可按需执行 `:TSInstall lua bash json yaml markdown` 安装解析器。

格式化与 lint 默认覆盖 `c/c++`、`python`、`rust`、`go`、`vue`、`js/ts`、`css`、`html`。首次安装插件后可执行 `:Mason` 确认 `prettierd`、`eslint_d`、`ruff`、`clang-format`、`gofumpt`、`goimports` 等工具已安装。
