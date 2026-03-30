--- ahmadinne's Neovim configurations ---
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.wrap = false
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.termguicolors = true
vim.opt.undofile = true
vim.opt.swapfile = false
vim.opt.signcolumn = "yes:1"
vim.opt.fillchars = { eob = " " }
vim.opt.ignorecase = true
vim.opt.incsearch = true
vim.opt.smartcase = true
vim.opt.completeopt = "menuone,noselect"
vim.opt.clipboard = "unnamedplus"
vim.g.mapleader = " "

-- Keymaps
vim.keymap.set("n", "<ESC>", ":nohl<CR>")
vim.keymap.set("n", "<leader>so", ":update<CR> :source<CR>")
vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format)
vim.keymap.set("n", "<leader>p", ":bp<CR>")
vim.keymap.set("n", "<leader>n", ":bn<CR>")

vim.keymap.set("n", "<leader>e", ":Oil<CR>")
vim.keymap.set("n", "<leader>f", ":Telescope find_files<CR>")
vim.keymap.set("n", "<leader>o", ":Telescope oldfiles<CR>")
vim.keymap.set("n", "<leader>g", ":Telescope live_grep<CR>")
vim.keymap.set("n", "<leader>h", ":Telescope help_tags<CR>")
vim.keymap.set("n", "<leader><space>", ":Telescope buffers<CR>")
vim.keymap.set("ca", "w!", "SudaWrite")

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Plugins
require("lazy").setup({
	{
		"saghen/blink.cmp",
		dependencies = { "rafamadriz/friendly-snippets", "L3MON4D3/LuaSnip" },
		version = "1.*",
	},
	{
		"mason-org/mason.nvim",
		dependencies = { "mason-org/mason-lspconfig.nvim", "WhoIsSethDaniel/mason-tool-installer.nvim" },
	},
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim" }
	},
	{ "3rd/image.nvim", build = false },
	"nvim-mini/mini.surround",
	"neovim/nvim-lspconfig",
	"lambdalisue/vim-suda",
	"stevearc/oil.nvim",
})
require("telescope").setup({
	defaults = { mappings = {
		i = {
			["<ESC>"] = "close",
		}
	} }
})
require("image").enable()
require("image").setup({
	backend = "sixel",
	processor = "magick_cli",
})
require("oil").setup({
	default_file_explorer = true,
	keymaps = {
		["<leader>e"] = { "actions.close", mode = "n" },
		["<BS>"] = { "actions.parent", mode = "n" },
	},
})
require("mason").setup()
require("mason-lspconfig").setup()
require("mason-tool-installer").setup({
	ensure_installed = { "lua_ls", "stylua", "bashls", "clangd", "biome" },
})
require("blink.cmp").setup({ list = { selection = { preselect = false, auto_insert = true } } })
require("luasnip.loaders.from_vscode").lazy_load()
require("mini.surround").setup()

-- Lsp
vim.lsp.config("lua_ls", { settings = { Lua = { workspace = { library = vim.api.nvim_get_runtime_file("", true) } } } })
vim.diagnostic.config({
	signs = false,
	underline = true,
	virtual_text = false,
	virtual_lines = { current_line = true },
	update_in_insert = true,
})

-- Colorscheme
require("paradise")
