-- CHAZZOX NVIM CONFIG
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

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
-- vim.opt.cursorline = true
vim.opt.mouse = "a"
vim.opt.scrolloff = 12
vim.opt.tabstop = 4
vim.opt.shiftwidth = 2 -- 4 character width tabs
vim.opt.textwidth = 80
vim.opt.wrapmargin = 2 -- word wrap
vim.opt.backup = false
vim.opt.writebackup = false -- no annoying backup files
vim.opt.number = true

-- configure title string
vim.opt.title = true

-- lazy config
require("lazy").setup({
	spec = {
		{
			"nyoom-engineering/oxocarbon.nvim",
			lazy = false,
			config = function()
				vim.opt.background = "dark"
				vim.cmd.colorscheme = "oxocarbon"
			end,
		},
		{
			"stevearc/conform.nvim",
			event = { "BufWritePre" },
			cmd = { "ConformInfo" },
			keys = {
				{
					-- Customize or remove this keymap to your liking
					"F",
					function()
						require("conform").format({ async = true })
					end,
					mode = "",
					desc = "Format buffer",
				},
			},
			---@module "conform"
			---@type conform.setupOpts
			opts = {},
		},
		{
			"kyazdani42/nvim-tree.lua",
		},
		{
			"nvim-telescope/telescope.nvim",
			tag = "0.1.8",
			dependencies = { "nvim-lua/plenary.nvim" },
			config = function()
				local builtin = require("telescope.builtin")
				vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
				vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })
				vim.keymap.set("n", "<leader>t", builtin.treesitter, { desc = "Telescope treesitter" })
			end,
		},
		{
			"akinsho/bufferline.nvim",
			version = "*",
			dependencies = "nvim-tree/nvim-web-devicons",
			config = function()
				require("bufferline").setup({})
			end,
		},
		{ "mrcjkb/haskell-tools.nvim", version = "^6", lazy = false },
		{ "nvim-treesitter/nvim-treesitter", branch = "master", lazy = false, build = ":TSUpdate" },
		{
			"Wansmer/treesj",
			keys = { { "J", "<cmd>TSJToggle<cr>", desc = "Join Toggle" } },
			opts = { use_default_keymaps = false, max_join_length = 150 },
			config = function()
				require("treesj").setup({})
			end,
		},
	},
	checker = { enabled = true },
})

require("nvim-tree").setup({})

require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		fish = { "fish_indent" },
		haskell = { "ormolu" },
		toml = { "pyproject-fmt" },
	},
	format_on_save = { timeout_ms = 500, lsp_format = "fallback" },
})

require("nvim-treesitter.configs").setup({
	ensure_installed = {
		"toml",
		"c",
		"python",
		"haskell",
		"fish",
		"verilog",
		"lua",
	},
	highlight = {
		enable = true,
	},
})

require("telescope").setup({
	defaults = {
		theme = "center",
		sorting_strategy = "ascending",
		layout_config = {
			horizontal = {
				prompt_position = "top",
				preview_width = 0.3,
			},
		},
		vimgrep_arguments = {
			"rg",
			"--color=never",
			"--no-heading",
			"--with-filename",
			"--line-number",
			"--column",
			"--smart-case",
			"--hidden", -- include hidden files
			"--glob",
			"!.git/*", -- exclude everything inside .git
		},
	},
	pickers = {
		live_grep = { hidden = true, ii },
	},
})

-- random keybinds
vim.keymap.set("n", "<C-s>", vim.cmd.write, { desc = "save file" })

vim.keymap.set("n", "FB", function()
	vim.cmd("NvimTreeToggle")
end, { desc = "save file" })

vim.keymap.set("n", "<C-w>", function()
	vim.cmd("NvimTreeClose")
	vim.cmd.bd()
end, { desc = "close buffer" })

vim.keymap.set("n", "<leader>nc", function()
	vim.cmd("e " .. vim.fn.stdpath("config") .. "/init.lua")
end, { desc = "edit config file" })

-- eof
