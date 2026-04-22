vim.cmd([[
  source $VIMRUNTIME/menu.vim
  anoremenu PopUp.-1- *
  anoremenu PopUp.LSP\ Code\ Action <cmd>Lspsaga code_action<CR>
]])
print("Menu defined")
