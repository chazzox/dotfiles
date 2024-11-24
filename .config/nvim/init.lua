-- CHAZZOX NVIM CONFIG

-- plugins
require('packer').startup(function(use) 
  use 'wbthomason/packer.nvim' -- package manager
  use {
	'nvim-tree/nvim-tree.lua',
  	requires = {
  	  'nvim-tree/nvim-web-devicons', -- optional
  	},
  }

  -- languages
  use 'dag/vim-fish' -- fish syntax 
  use {'mboughaba/i3config.vim', ft="i3config"} -- i3 config support 
  use 'wuelnerdotexe/vim-astro'
  use 'hashivim/vim-terraform'

  use {'nyoom-engineering/oxocarbon.nvim'}  
end)

-- editor stuff
vim.opt.clipboard:append { 'unnamed', 'unnamedplus' }
vim.o.termguicolors = true 
vim.opt.encoding = "UTF-8" 
vim.opt.cursorline = true 
vim.opt.number = true
vim.opt.mouse = "a" 
vim.opt.scrolloff = 12
vim.opt.tabstop = 4 
vim.opt.shiftwidth = 2 -- 4 character width tabs
vim.opt.textwidth = 80 
vim.opt.wrapmargin = 2 -- word wrap
vim.opt.backup = false 
vim.opt.writebackup = false -- no annoying backup files
vim.opt.relativenumber = true

-- configure title string
vim.opt.title = true 

-- PLUGINS 
vim.opt.background = "dark" -- set this to dark or light
vim.cmd.colorscheme "oxocarbon"


-- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
-- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
