---@diagnostics disable: missing-fields
--- ahmadinne's Neovim configurations ---
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.wrap = false
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.ignorecase = true
vim.opt.incsearch = true
vim.opt.smartcase = true
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"
vim.opt.fillchars = { eob = " " }
vim.opt.signcolumn = "yes:1"
vim.opt.swapfile = false
vim.opt.termguicolors = true
vim.opt.undofile = true
vim.opt.path = "**"
vim.g.mapleader = " "

-- Keymaps
vim.keymap.set("n", "<ESC>", "<CMD>nohl<CR>")
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")
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
vim.keymap.set("n", "<leader>f", ":find ")
vim.keymap.set("n", "<leader>g", ":Grep ")
vim.keymap.set("n", "<leader>x", "<CMD>copen<CR>")
vim.keymap.set("n", "<leader>p", "<CMD>bp<CR>")
vim.keymap.set("n", "<leader>n", "<CMD>bn<CR>")
vim.keymap.set("n", "<leader>q", "<CMD>bd<CR>")
vim.keymap.set("n", "<leader>e", "<CMD>Oil --float<CR>")
vim.keymap.set("n", "<leader>u", "<CMD>Undotree<CR>")
vim.keymap.set("ca", "w!", "SudaWrite")

-- Plugins
vim.cmd("packadd nvim.undotree")
vim.pack.add({
	{ src = "https://github.com/saghen/blink.cmp", version = 'v1.10.2' },
	"https://github.com/nvim-treesitter/nvim-treesitter",
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/mason-org/mason.nvim",
	"https://github.com/mason-org/mason-lspconfig.nvim", -- mason deps
	"https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim", -- mason deps
	"https://github.com/3rd/image.nvim",
	"https://github.com/nvim-mini/mini.surround",
	"https://github.com/nvim-mini/mini.comment",
	"https://github.com/nvim-mini/mini.icons",
	"https://github.com/lambdalisue/vim-suda",
	"https://github.com/stevearc/oil.nvim",
	"https://github.com/brenoprata10/nvim-highlight-colors",
	"https://github.com/brianhuster/live-preview.nvim",
	"https://github.com/walkingshamrock/rnum.nvim",
	"https://github.com/pteroctopus/faster.nvim",
})
require("nvim-treesitter.install").update("all")
require("nvim-treesitter.config").setup({ auto_install = true })
require("blink.cmp").setup({
	completion = {
		documentation = { auto_show = false },
		menu = { auto_show = true },
	},

	fuzzy = {
		implementation = "lua",
	},
})

-- Lsp Plugins
local lsp_servers = {
	lua_ls = {
		Lua = {
			workspace = { library = vim.api.nvim_get_runtime_file("lua", true) },
			diagnostics = { globals = { "vim", "require" } },
			telemetry = { enable = false },
		},
		clangd = {},
		rust_analyzer = {},
		gopls = {},
	},
}
require("mason").setup()
require("mason-lspconfig").setup()
require("mason-tool-installer").setup({ ensure_installed = vim.tbl_keys(lsp_servers) })
for server, config in pairs(lsp_servers) do
	vim.lsp.config(server, {
		settings = config,
		on_attach = function(_, bufnr)
			vim.keymap.set("n", "grd", vim.lsp.buf.definition, { buffer = bufnr, desc = "vim.lsp.buf.definition()" })
			vim.keymap.set("n", "grf", vim.lsp.buf.format, { buffer = bufnr, desc = "vim.lsp.buf.format()" })
		end,
	})
end
vim.diagnostic.config({
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = " ",
			[vim.diagnostic.severity.WARN] = " ",
			[vim.diagnostic.severity.INFO] = " ",
			[vim.diagnostic.severity.HINT] = " ",
		},
	},
	virtual_text = true, -- show inline diagnostics
})

-- QoL Plugins
require("faster").setup()
require("nvim-highlight-colors").setup({})
require("mini.surround").setup()
require("mini.comment").setup()
require("mini.icons").setup()
require("image").enable()
require("image").setup({ backend = "sixel", processor = "magick_cli" })
require("rnum").setup({ number_width = 4 })
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

-- Autocmd
vim.cmd("command! -nargs=+ Grep execute 'silent grep! <args>' | copen 42")
vim.api.nvim_create_autocmd("BufEnter", {
	callback = function()
		local path = vim.fn.expand("%:p:h")
		if vim.fn.isdirectory(path) == 1 and path:match("^/") then
			vim.api.nvim_set_current_dir(path)
			local f = io.open("/tmp/nvim_last_dir", "w")
			if f then
				f:write(path)
				f:close()
			end
		end
	end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- Colorscheme and statusline
require("paradise")
require("ui")
