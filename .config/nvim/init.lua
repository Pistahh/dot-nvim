vim.cmd [[colorscheme slate]]
vim.wo.number = true
vim.wo.signcolumn = "yes"


if vim.fn.executable("rg") > 0 then
  vim.o.grepprg = "rg --hidden --glob '!.git' --no-heading --smart-case --vimgrep --follow $*"
  vim.opt.grepformat = vim.opt.grepformat ^ { "%f:%l:%c:%m" }
end

require('plugins')
