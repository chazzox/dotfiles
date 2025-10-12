-- CHAZZOX NVIM CONFIG

-- configuring lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- editor stuff
vim.opt.clipboard:append({ "unnamed", "unnamedplus" })
vim.o.termguicolors = true
vim.opt.encoding = "UTF-8"
vim.opt.cursorline = true
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

-- lazy config
require("lazy").setup({
	spec = {
		{ "dag/vim-fish" },
		{ "nyoom-engineering/oxocarbon.nvim" },
		{ "stevearc/conform.nvim", opts = {} },
		{ "nvim-telescope/telescope.nvim", tag = "0.1.8", dependencies = { "nvim-lua/plenary.nvim" } },
		{ "mrcjkb/haskell-tools.nvim", version = "^6", lazy = false },
		{ "nvim-treesitter/nvim-treesitter", branch = "master", lazy = false, build = ":TSUpdate" },
	},
	checker = { enabled = true },
})

require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		fish = { "fish_indent" },
		haskell = { "ormolu" },
	},
	format_on_save = {
		timeout_ms = 500,
		lsp_format = "fallback",
	},
})

require("nvim-treesitter.configs").setup({
	ensure_installed = { "c", "lua", "python", "haskell", "fish" },
	highlight = { enable = true },
})

vim.opt.background = "dark" -- set this to dark or light
vim.cmd.colorscheme = "oxocarbon"
