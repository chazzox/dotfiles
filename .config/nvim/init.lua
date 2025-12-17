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
			"mrcjkb/haskell-tools.nvim",
			version = "^6", -- Recommended
			lazy = false, -- This plugin is already lazy
		},
		{
			"nyoom-engineering/oxocarbon.nvim",
			lazy = false,
			config = function()
				vim.opt.background = "dark"
				vim.cmd.colorscheme = "oxocarbon"
			end,
		},
		{
			"windwp/nvim-autopairs",
			event = "InsertEnter",
			config = true,
		},
		{
			"nvim-neo-tree/neo-tree.nvim",
			branch = "v3.x",
			dependencies = {
				"nvim-lua/plenary.nvim",
				"MunifTanjim/nui.nvim",
				"nvim-tree/nvim-web-devicons", -- optional, but recommended
			},
			lazy = false, -- neo-tree will lazily load itself
		},
		{
			"akinsho/bufferline.nvim",
			version = "*",
			dependencies = "nvim-tree/nvim-web-devicons",
			config = function()
				require("bufferline").setup({})
			end,
		},
		{
			"nvim-treesitter/nvim-treesitter",
			branch = "master",
			lazy = false,
			build = ":TSUpdate",
		},
		{
			"Wansmer/treesj",
			keys = { { "<leader>j", "<cmd>TSJToggle<cr>", desc = "Join Toggle" } },
			opts = { use_default_keymaps = false, max_join_length = 150 },
			config = function()
				require("treesj").setup({})
			end,
		},
		{
			"folke/lazydev.nvim",
			ft = "lua", -- only load on lua files
			opts = {
				library = {
					{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				},
			},
		},
		{
			"mason-org/mason-lspconfig.nvim",
			opts = {
				ensure_installed = { "lua_ls", "ts_ls", "fish_lsp" },
				automatic_installation = true,
			},
			dependencies = {
				{ "mason-org/mason.nvim", opts = {} },
				"neovim/nvim-lspconfig",
			},
			config = function()
				local capabilities = require("cmp_nvim_lsp").default_capabilities()
				vim.lsp.config.lua_ls = {
					cmd = { "lua-language-server" },
					root_markers = { ".luarc.json", ".git" },
					capabilities = capabilities,
					settings = {
						Lua = {
							runtime = { version = "LuaJIT" },
							diagnostics = { globals = { "vim" } },
							workspace = {
								library = vim.api.nvim_get_runtime_file("", true),
								checkThirdParty = false,
							},
							telemetry = { enable = false },
						},
					},
				}
				vim.lsp.enable({ "lua_ls", "fish_lsp" })
			end,
		},
		{
			"hrsh7th/nvim-cmp",
			dependencies = {
				"hrsh7th/cmp-nvim-lsp",
				"hrsh7th/cmp-buffer",
				"hrsh7th/cmp-path",
				"L3MON4D3/LuaSnip",
				"saadparwaiz1/cmp_luasnip",
			},
			config = function()
				local cmp = require("cmp")
				local luasnip = require("luasnip")

				cmp.setup({
					snippet = {
						expand = function(args)
							luasnip.lsp_expand(args.body)
						end,
					},
					mapping = cmp.mapping.preset.insert({
						["<C-Space>"] = cmp.mapping.complete(),
						["<CR>"] = cmp.mapping.confirm({ select = true }),
						["<Tab>"] = cmp.mapping(function(fallback)
							if cmp.visible() then
								cmp.select_next_item()
							elseif luasnip.expand_or_jumpable() then
								luasnip.expand_or_jump()
							else
								fallback()
							end
						end, { "i", "s" }),
						["<S-Tab>"] = cmp.mapping(function(fallback)
							if cmp.visible() then
								cmp.select_prev_item()
							elseif luasnip.jumpable(-1) then
								luasnip.jump(-1)
							else
								fallback()
							end
						end, { "i", "s" }),
					}),
					sources = cmp.config.sources({
						{ name = "lazydev" },
						{ name = "nvim_lsp" },
						{ name = "luasnip" },
						{ name = "buffer" },
						{ name = "path" },
					}),
				})
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
			opts = { default_format_opts = { lsp_format = "fallback" } },
		},
	},
	checker = { enabled = true },
})

-- lsp settings
vim.keymap.set("n", "<leader>i", function()
	vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ 0 }), { 0 })
end)

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local opts = { buffer = args.buf }
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
		vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
		vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
	end,
})
-- end lsp settings

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
	ensure_installed = { "toml", "c", "python", "haskell", "fish", "verilog", "lua" },
	highlight = { enable = true },
})

require("neo-tree").setup({ filesystem = { filtered_items = { hide_dotfiles = false } } })

-- random keybinds
vim.keymap.set("n", "<C-s>", vim.cmd.write, { desc = "save file" })

vim.keymap.set("n", "FB", function()
	vim.cmd("Neotree filesystem toggle left")
end, { desc = "save file" })

function Close()
	vim.cmd("Neotree close")
	if #(vim.api.nvim_list_bufs()) == 1 then
		vim.cmd("quit")
	end
	vim.cmd.bd()
end

vim.keymap.set("n", "<leader>w", Close, { desc = "close buffer" })
vim.keymap.set("n", "<C-w>", Close, { desc = "close buffer" })

vim.keymap.set("n", "<leader>nc", function()
	vim.cmd("e " .. vim.fn.stdpath("config") .. "/init.lua")
end, { desc = "edit config file" })

vim.keymap.set("n", "<Tab>", vim.cmd.bNext)
vim.keymap.set("n", "<leader>vd", function()
	vim.diagnostic.open_float()
end, opts)
