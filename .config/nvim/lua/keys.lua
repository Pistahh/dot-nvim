local tsbuiltin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', tsbuiltin.find_files, {})
vim.keymap.set('n', '<leader>fg', tsbuiltin.live_grep, {})
vim.keymap.set('n', '<leader>fb', tsbuiltin.buffers, {})
vim.keymap.set('n', '<leader>fh', tsbuiltin.help_tags, {})

-- nnoremap <buffer><silent> <c-q> <cmd>call Black()<cr>
-- inoremap <buffer><silent> <c-q> <cmd>call Black()<cr>

vim.keymap.set('n', '<leader>fo', '<Cmd>call Black()<CR>', {})
