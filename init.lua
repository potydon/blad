--- ahmadinne's Neovim configurations ---
vim.o.number = true
vim.o.relativenumber = true
vim.o.wrap = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.smartindent = true
vim.o.termguicolors = true
vim.o.undofile = true
vim.o.swapfile = false
vim.o.signcolumn = "yes:1"
vim.opt.winborder = "single"
vim.o.ignorecase = true
vim.o.incsearch = true
vim.o.smartcase = true
vim.o.inccommand = "split"
vim.o.updatetime = 250
vim.o.timeout = false
vim.o.laststatus = 3
vim.g.mapleader = ' '

-- Keymaps
vim.keymap.set('n', '<leader>so', ':update<CR> :source<CR>')
vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format)
vim.keymap.set('n', '<leader>w', ':write<CR>')

vim.keymap.set({'n', 'v', 'x'}, '<leader>y', '"+y<CR>')
vim.keymap.set({'n', 'v', 'x'}, '<leader>p', '"+p<CR>')
vim.keymap.set({'n', 'v', 'x'}, '<leader>d', '"+d<CR>')

vim.keymap.set('n', '<leader>e', ':Oil<CR>')
vim.keymap.set('n', '<leader>ff', ':Pick files<CR>')
vim.keymap.set('n', '<leader>fg', ':Pick grep_live<CR>')
vim.keymap.set('n', '<leader>fh', ':Pick help<CR>')
vim.keymap.set('n', '<ESC>', ':nohl<CR>')
vim.keymap.set('n', '<leader><space>', ':Pick buffers<CR>')
vim.keymap.set('ca', 'w!', 'SudaWrite')

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git", "clone", "--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Plugins
require "lazy".setup({
	{ "3rd/image.nvim", build = false, opts = { processor = "magick_cli" } },
	{ "saghen/blink.cmp", dependencies = {'rafamadriz/friendly-snippets', 'L3MON4D3/LuaSnip' }, version = '1.*'},
	{ "mason-org/mason.nvim", dependencies = {'mason-org/mason-lspconfig.nvim', 'WhoIsSethDaniel/mason-tool-installer.nvim'} },
	"thepogsupreme/mountain.nvim",
	"neovim/nvim-lspconfig",
	"lambdalisue/vim-suda",
	"nvim-mini/mini.pick",
	"stevearc/oil.nvim",
})
require "mini.pick".setup()
require "image".enable()
require "image".setup({
	backend = "kitty",
	processor = "magick_cli",
	integrations = {
		markdown = {
			enabled = true,
			clear_in_insert_mode = false,
			download_remote_images = true,
			only_render_image_at_cursor = true,
			only_render_image_at_cursor_mode = "popup", -- "popup" or "inline"
			floating_windows = false,
			filetypes = { "markdown", "vimwiki" },
		}
	}
})
require "oil".setup({
	default_file_explorer = true,
	keymaps = {
		["<leader>e"] = { "actions.close", mode = "n" },
		["<BS>"] = { "actions.parent", mode = "n" },
	}
})
require "mason".setup()
require "mason-lspconfig".setup()
require "mason-tool-installer".setup({
	ensure_installed = { "lua_ls", "stylua", "bashls", "bash-debug-adapter", "shellcheck", "clangd", "cpptools", "cpplint", "biome", "js-debug-adapter" }
})
require "blink.cmp".setup({
	list = { selection = { preselect = false, auto_insert = true } },
})
require "luasnip.loaders.from_vscode".lazy_load()

-- Lsp
vim.lsp.enable({ "lua_ls" })
vim.lsp.config("lua_ls", {
	settings = { Lua = { workspace = { library = vim.api.nvim_get_runtime_file("", true) } } }
})
vim.diagnostic.config({
	signs = false,
	underline = true,
	virtual_text = false,
	virtual_lines = { current_line = true },
	update_in_insert = true,
})

-- Colorscheme
vim.cmd("colorscheme mountain")
vim.cmd(":hi statusline guibg=NONE")
vim.cmd("set completeopt+=noselect")
