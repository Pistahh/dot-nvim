-- KEYS
-- gc(c): toggle comment
-- [space]ca - LSP code action
--

vim.cmd [[colorscheme slate]]
vim.wo.number = true
vim.wo.signcolumn = "yes"
vim.g.mapleader = ","
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.smartindent = true
vim.opt.wrap = true
vim.g.formatoptions = "qrn1"

local pypath = vim.fn.expand("~/.pyenv/versions/py3nvim/bin/python")
if vim.fn.filereadable(pypath) then
    vim.g.python3_host_prog = pypath
end

if vim.fn.executable("rg") > 0 then
    vim.o.grepprg = "rg --hidden --glob '!.git' --no-heading --smart-case --vimgrep --follow $*"
    vim.opt.grepformat = vim.opt.grepformat ^ { "%f:%l:%c:%m" }
end

local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'
    use 'averms/black-nvim'
    use 'nvim-tree/nvim-web-devicons'
    --	use 'folke/trouble.nvim'
    use 'neovim/nvim-lspconfig'
    -- use 'davidhalter/jedi-vim'
    use 'ervandew/supertab'
    use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
    -- use 'ggandor/leap.nvim'
    -- use 'unblevable/quick-scope' -- current line only
    -- use 'roy2220/easyjump.tmux' -- couldn't make it work
    -- use 'justinmk/vim-sneak'
    -- use 'easymotion/vim-easymotion'
    use 'ggandor/lightspeed.nvim'
    use {
        'nvim-telescope/telescope.nvim',
        requires = { { 'nvim-lua/plenary.nvim' } }
    }
    use 'nvim-telescope/telescope-ui-select.nvim'
    -- use {
    -- 	"folke/which-key.nvim",
    -- 	config = function()
    -- 		vim.o.timeout = true
    -- 		vim.o.timeoutlen = 300
    -- 		require("which-key").setup {
    -- 			-- your configuration comes here
    -- 			-- or leave it empty to use the default settings
    -- 			-- refer to the configuration section below
    -- 		}
    -- 	end
    -- }
    use 'tpope/vim-commentary'
    use 'lukas-reineke/lsp-format.nvim'

    if packer_bootstrap then
        require('packer').sync()
    end
end)

local tsbuiltin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', tsbuiltin.find_files, {})
vim.keymap.set('n', '<leader>fg', tsbuiltin.live_grep, {})
vim.keymap.set('n', '<leader>fb', tsbuiltin.buffers, {})
vim.keymap.set('n', '<leader>fh', tsbuiltin.help_tags, {})

-- nnoremap <buffer><silent> <c-q> <cmd>call Black()<cr>
-- inoremap <buffer><silent> <c-q> <cmd>call Black()<cr>

vim.keymap.set('n', '<leader>fo', '<Cmd>call Black()<CR>', {})

require("lsp-format").setup {}

require 'lspconfig'.pyright.setup { on_attach = require("lsp-format").on_attach }
require 'lspconfig'.lua_ls.setup { on_attach = require("lsp-format").on_attach }
require 'lspconfig'.zls.setup { on_attach = require("lsp-format").on_attach }

vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        -- Enable completion triggered by <c-x><c-o>
        vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions

        local opts = { buffer = ev.buf }

        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
        vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
        vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
        vim.keymap.set('n', '<space>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, opts)
        vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
        vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        vim.keymap.set('n', '<space>f', function()
            vim.lsp.buf.format { async = true }
        end, opts)
    end,
})

require("telescope").setup {
    extensions = {
        ["ui-select"] = {
            require("telescope.themes").get_dropdown {
                -- even more opts
            }

            -- pseudo code / specification for writing custom displays, like the one
            -- for "codeactions"
            -- specific_opts = {
            --   [kind] = {
            --		make_indexed = function(items) -> indexed_items, width,
            --		make_displayer = function(widths) -> displayer
            --		make_display = function(displayer) -> function(e)
            --		make_ordinal = function(e) -> string
            --   },
            --   -- for example to disable the custom builtin "codeactions" display
            --		 do the following
            --   codeactions = false,
            -- }
        }
    },
    pickers = {
        colorscheme = {
            enable_preview = true
        }
    }
}

-- To get ui-select loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
require("telescope").load_extension("ui-select")

require 'nvim-treesitter.configs'.setup {
    -- A list of parser names, or "all" (the five listed parsers should always be installed)
    ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "python", "rust", "zig" },

    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,

    -- Automatically install missing parsers when entering buffer
    -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
    auto_install = true,

    -- List of parsers to ignore installing (for "all")
    ignore_install = { "javascript" },

    ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
    -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

    highlight = {
        enable = true,
        --
        --	   -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
        --	   -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
        --	   -- the name of the parser)
        --	   -- list of language that will be disabled
        --	   disable = { "c", "rust" },
        --	   -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
        --	   disable = function(lang, buf)
        --		   local max_filesize = 100 * 1024 -- 100 KB
        --		   local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        --		   if ok and stats and stats.size > max_filesize then
        --			   return true
        --		   end
        --	   end,
        --
        --	   -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        --	   -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        --	   -- Using this option may slow down your editor, and you may see some duplicate highlights.
        --	   -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = false,
    },
}
