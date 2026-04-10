--- ahmadinne's Neovim configurations ---
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.wrap = false
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
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
vim.keymap.set("n", "<ESC>", "<CMD>nohl<CR>")
vim.keymap.set("n", "<leader>so", function()
	local ft = vim.bo.filetype
	if ft == "lua" then
		vim.cmd("update")
		vim.cmd("source %")
		print("Lua file updated and sourced!")
	else
		vim.cmd("filetype detect")
		local new_ft = vim.bo.filetype
		new_ft = new_ft ~= "" and new_ft or "unknown"
		print(string.format("filetype detected: %s", new_ft))
	end
end)
vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format)
vim.keymap.set("n", "<leader>p", "<CMD>bp<CR>")
vim.keymap.set("n", "<leader>n", "<CMD>bn<CR>")
vim.keymap.set("n", "<leader>q", "<CMD>bd<CR>")
vim.keymap.set("n", "<leader>e", "<CMD>Oil --float<CR>")
vim.keymap.set("n", "<leader>u", "<CMD>Undotree<CR>")
vim.keymap.set("ca", "w!", "SudaWrite")

-- Plugins
vim.cmd("packadd nvim.undotree")
vim.pack.add({
	{ src = "https://github.com/saghen/blink.cmp", version = "v1.10.2" },
	{ src = "https://github.com/tuurep/vim-wordmotion", version = "dev" },
	"https://github.com/L3MON4D3/LuaSnip", --blink deps
	"https://github.com/mason-org/mason.nvim",
	"https://github.com/mason-org/mason-lspconfig.nvim", -- mason deps
	"https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim", -- mason deps
	"https://github.com/3rd/image.nvim",
	"https://github.com/nvim-mini/mini.surround",
	"https://github.com/nvim-mini/mini.icons",
	"https://github.com/lambdalisue/vim-suda",
	"https://github.com/stevearc/oil.nvim",
	"https://github.com/catgoose/nvim-colorizer.lua",
	"https://github.com/rachartier/tiny-glimmer.nvim",
	"https://github.com/mcauley-penney/visual-whitespace.nvim",
	"https://github.com/brianhuster/live-preview.nvim",
})
require("colorizer").setup()
require("tiny-glimmer").setup()
require("image").enable()
require("image").setup({ backend = "sixel", processor = "magick_cli" })
require("oil").setup({
	default_file_explorer = true,
	delete_to_trash = true,
	watch_for_changes = true,
	keymaps = {
		["<ESC><ESC>"] = { "actions.close", mode = "n" },
		["<leader>e"] = { "actions.close", mode = "n" },
		["<S-Enter>"] = { "actions.parent", mode = "n" },
		["<BS>"] = { "actions.parent", mode = "n" },
		["q"] = { "actions.close", mode = "n" },
		["."] = { "actions.toggle_hidden", mode = "n" },
		[","] = {
			callback = function()
				local oil = require("oil")
				local config = require("oil.config")
				if #config.columns == 1 then
					oil.set_columns({ "icon", "permissions", "size" })
				else
					oil.set_columns({ "icon" })
				end
			end,
		},
	},
	view_options = {
		show_hidden = true,
		is_always_hidden = function(name, _)
			return name == ".." or name == ".git"
		end,
	},
	float = {
		padding = 2,
		max_width = 100,
		max_height = 31,
		win_options = {
			number = false,
			relativenumber = false,
		},
	},
})
require("mason").setup()
require("mason-lspconfig").setup()
require("mason-tool-installer").setup({ ensure_installed = { "lua_ls", "stylua" } })
require("luasnip.loaders.from_vscode").lazy_load()
require("mini.surround").setup()
require("mini.icons").setup()
require("blink.cmp").setup({
	signature = { enabled = true },
	completion = {
		documentation = { auto_show = false },
		menu = { auto_show = false },
	},
})

-- Lsp
vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			workspace = { library = vim.api.nvim_get_runtime_file("", true) },
			diagnostics = { globals = { "vim", "require" } },
			telemetry = { enable = false },
		},
	},
})
vim.diagnostic.config({
	signs = false,
	underline = true,
	virtual_text = true,
	update_in_insert = true,
})

-- Colorscheme
require("paradise")
require("globals")
require("ui")
