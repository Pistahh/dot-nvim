vim.cmd [[colorscheme slate]]
vim.wo.number = true
vim.wo.signcolumn = "yes"
vim.g.mapleader = ","
vim.g.python3_host_prog = '/home/istvan/.pyenv/versions/py3nvim/bin/python'

if vim.fn.executable("rg") > 0 then
  vim.o.grepprg = "rg --hidden --glob '!.git' --no-heading --smart-case --vimgrep --follow $*"
  vim.opt.grepformat = vim.opt.grepformat ^ { "%f:%l:%c:%m" }
end

require('plugins')
require('treesitter')
require('lsp')
require('keys')

