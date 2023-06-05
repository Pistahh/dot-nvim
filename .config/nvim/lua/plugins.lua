-- This file can be loaded by calling `lua require('plugins')` from your init.vim

local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)
	-- Packer can manage itself
	use 'wbthomason/packer.nvim'
	use 'averms/black-nvim'
	use 'nvim-tree/nvim-web-devicons'
	--  use 'folke/trouble.nvim'
	use 'neovim/nvim-lspconfig'
	use 'davidhalter/jedi-vim'
	use 'ervandew/supertab'
	use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
	-- use 'ggandor/leap.nvim'
	-- use 'unblevable/quick-scope' -- current line only
	-- use 'roy2220/easyjump.tmux' -- couldn't make it work
	-- use 'justinmk/vim-sneak'
	use 'easymotion/vim-easymotion'
	use {
		'nvim-telescope/telescope.nvim',
		requires = { { 'nvim-lua/plenary.nvim' } }
	}
	use 'nvim-telescope/telescope-ui-select.nvim'
	use {
	  "folke/which-key.nvim",
	  config = function()
	    vim.o.timeout = true
	    vim.o.timeoutlen = 300
	    require("which-key").setup {
	      -- your configuration comes here
	      -- or leave it empty to use the default settings
	      -- refer to the configuration section below
	    }
	  end
	}
	use 'tpope/vim-commentary'
end)

-- require("telescope").setup {
--   extensions = {
--     ["ui-select"] = {
--       require("telescope.themes").get_dropdown {
--         -- even more opts
--       }
-- 
--       -- pseudo code / specification for writing custom displays, like the one
--       -- for "codeactions"
--       -- specific_opts = {
--       --   [kind] = {
--       --     make_indexed = function(items) -> indexed_items, width,
--       --     make_displayer = function(widths) -> displayer
--       --     make_display = function(displayer) -> function(e)
--       --     make_ordinal = function(e) -> string
--       --   },
--       --   -- for example to disable the custom builtin "codeactions" display
--       --      do the following
--       --   codeactions = false,
--       -- }
--     }
--   }
-- }
-- -- To get ui-select loaded and working with telescope, you need to call
-- -- load_extension, somewhere after setup function:
-- require("telescope").load_extension("ui-select")
