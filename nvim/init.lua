local vim = vim
local Plug = vim.fn["plug#"]
local start_time = vim.loop.hrtime()

-- ============================================================================
-- plugins
-- ============================================================================
vim.call("plug#begin", vim.fn.stdpath("data") .. "/plugged")

Plug("nvim-tree/nvim-web-devicons")
Plug("nvim-lua/plenary.nvim")
Plug("nvim-telescope/telescope.nvim")
Plug("lewis6991/gitsigns.nvim")
Plug("folke/trouble.nvim", { branch = "main" })
Plug("stevearc/conform.nvim")
Plug("neovim/nvim-lspconfig")
Plug("williamboman/mason.nvim")
Plug("williamboman/mason-lspconfig.nvim")
Plug("WhoIsSethDaniel/mason-tool-installer.nvim")
Plug("rcarriga/nvim-notify")
Plug("nvim-lualine/lualine.nvim")
Plug("hrsh7th/nvim-cmp")
Plug("hrsh7th/cmp-nvim-lsp")
Plug("hrsh7th/cmp-buffer")
Plug("hrsh7th/cmp-path")
Plug("nvim-treesitter/nvim-treesitter")
Plug("windwp/nvim-ts-autotag")
Plug("lukas-reineke/indent-blankline.nvim", { tag = "v3.8.2" })
Plug("scottmckendry/cyberdream.nvim")
Plug("christoomey/vim-tmux-navigator")
Plug("nvim-tree/nvim-tree.lua")
Plug("pmizio/typescript-tools.nvim")
Plug("mg979/vim-visual-multi", { branch = "master" })

vim.call("plug#end")

-- ============================================================================
-- core options
-- ============================================================================
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.termguicolors = true
vim.opt.clipboard = "unnamedplus"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 200
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("state") .. "/undo//"

-- code folding (treesitter-based, vscode-style collapse/expand)
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldtext = ""
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldnestmax = 4

vim.cmd([[colorscheme cyberdream]])

-- ============================================================================
-- keymaps
-- ============================================================================
vim.keymap.set("n", " ", "<Nop>", { silent = true })
vim.g.mapleader = " "

local opts = { noremap = true, silent = true }

local function goto_definition()
	local buf = vim.api.nvim_get_current_buf()
	for _, client in ipairs(vim.lsp.get_clients({ bufnr = buf })) do
		if client.supports_method("textDocument/definition") then
			vim.lsp.buf.definition()
			return
		end
	end
	vim.notify("No LSP with definition capability attached", vim.log.levels.WARN)
end

-- basics
vim.keymap.set("i", "kk", "<Esc>", opts)
vim.keymap.set("n", "<C-s>", "<cmd>w!<CR>", opts)
vim.keymap.set("n", "<M-s>", "<cmd>w!<CR>", opts)
vim.keymap.set("n", "<C-g>", goto_definition, { noremap = true, silent = true, desc = "go to definition" })

-- quit
vim.keymap.set("n", "<leader>q", "<cmd>x<CR>", opts)
vim.keymap.set("n", "<leader>qq", "<cmd>q!<CR>", opts)

-- selection
vim.keymap.set("n", "<C-a>", "gg<S-v>G", opts)

-- line start/end
vim.keymap.set("n", "[", "_", opts)
vim.keymap.set("n", "]", "$", opts)
vim.keymap.set("n", "gb", "G", opts)

-- window management
vim.keymap.set("n", "<leader>wv", "<cmd>vsplit<CR>", opts)
vim.keymap.set("n", "<leader>ws", "<cmd>split<CR>", opts)
vim.keymap.set("n", "<leader>wo", "<cmd>only<CR>", opts)
vim.keymap.set("n", "<leader>w=", "<C-w>=", opts)
vim.keymap.set("n", "<leader>w<", "5<C-w><", opts)
vim.keymap.set("n", "<leader>w>", "5<C-w>>", opts)
vim.keymap.set("n", "<leader>tk", "<C-w>t<C-w>K", opts)
vim.keymap.set("n", "<leader>th", "<C-w>t<C-w>H", opts)

-- folding: enter toggles a fold when on one, else acts as a normal <cr>
vim.keymap.set("n", "<CR>", function()
	return vim.fn.foldlevel(vim.fn.line(".")) > 0 and "za" or "<CR>"
end, { expr = true, desc = "toggle fold / newline" })

-- tmux navigator
vim.keymap.set("n", "<C-h>", "<cmd>TmuxNavigateLeft<CR>", opts)
vim.keymap.set("n", "<C-j>", "<cmd>TmuxNavigateDown<CR>", opts)
vim.keymap.set("n", "<C-k>", "<cmd>TmuxNavigateUp<CR>", opts)
vim.keymap.set("n", "<C-l>", "<cmd>TmuxNavigateRight<CR>", opts)

-- diagnostics
vim.keymap.set("n", "<C-e>", function()
	vim.diagnostic.open_float()
end, { desc = "open diagnostic float" })

vim.keymap.set("n", "<leader>dd", "<cmd>Trouble diagnostics toggle<cr>", { desc = "toggle trouble diagnostics" })

-- ============================================================================
-- notifications
-- ============================================================================
require("notify").setup({
	stages = "fade_in_slide_out",
	background_colour = "FloatShadow",
})
vim.notify = require("notify")

vim.keymap.set("n", "<leader>cl", function()
	require("notify").dismiss({ silent = true, pending = true })
end, { desc = "clear notifications" })

vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		local elapsed_ms = (vim.loop.hrtime() - start_time) / 1e6
		vim.notify(string.format("init %.2f ms +_+", elapsed_ms), "info", { title = "letsgo" })
	end,
})

-- ============================================================================
-- nvim-tree
-- ============================================================================
vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { noremap = true, silent = true, desc = "toggle explorer" })

require("nvim-tree").setup({
	hijack_netrw = true,
	sync_root_with_cwd = true,
	respect_buf_cwd = true,

	update_focused_file = {
		enable = true,
		update_root = true,
	},

	view = {
		side = "left",
		width = 35,
		signcolumn = "no",
		preserve_window_proportions = true,
	},

	renderer = {
		root_folder_label = ":~",
		indent_markers = { enable = true },
		highlight_opened_files = "name",
		icons = {
			webdev_colors = true,
			git_placement = "after",
			show = { folder = true, file = true, git = true, modified = true },
		},
	},

	git = {
		enable = true,
		ignore = false,
		timeout = 200,
	},

	diagnostics = {
		enable = true,
		show_on_dirs = true,
		show_on_open_dirs = true,
	},

	filters = {
		custom = { "^.git$" },
	},

	actions = {
		open_file = {
			quit_on_open = false,
			resize_window = true,
			window_picker = {
				enable = true,
				chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
				exclude = {
					filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame" },
					buftype = { "nofile", "terminal", "help" },
				},
			},
		},
	},

	on_attach = function(bufnr)
		local api = require("nvim-tree.api")
		local function bmap(lhs, rhs, desc)
			vim.keymap.set("n", lhs, rhs, {
				buffer = bufnr,
				noremap = true,
				silent = true,
				nowait = true,
				desc = "nvim-tree: " .. desc,
			})
		end

		api.config.mappings.default_on_attach(bufnr)

		pcall(vim.api.nvim_set_option_value, "cursorline", true, { win = 0 })

		bmap("<CR>", api.node.open.edit, "open")
		bmap("t", api.node.open.tab, "open in new tab")
		bmap("s", api.node.open.vertical, "open to the side (vsplit)")
		bmap("x", api.node.open.horizontal, "open below (split)")

		bmap("R", api.tree.reload, "refresh")
		bmap("f", function()
			api.tree.find_file({ open = true, focus = true })
		end, "reveal current file")

		bmap("a", api.fs.create, "new file / directory")
		bmap("<F2>", api.fs.rename, "rename")
		bmap("c", api.fs.copy.node, "copy")
		bmap("p", api.fs.paste, "paste")
		bmap("<Del>", api.fs.remove, "delete")

		bmap("h", api.node.navigate.parent_close, "collapse")
		bmap("l", api.node.open.edit, "open/expand")
		bmap("H", api.tree.toggle_hidden_filter, "toggle hidden (dotfiles)")

		bmap("q", api.tree.close, "close")
	end,
})

-- ============================================================================
-- trouble
-- ============================================================================
require("trouble").setup({
	position = "bottom",
	height = 12,
	icons = true,
	auto_close = true,
	auto_preview = true,
	use_diagnostic_signs = true,
	keys = {
		["q"] = "close",
		["<esc>"] = "close",
		["<cr>"] = "jump",
		["o"] = "jump_close",
		["r"] = "refresh",
		["p"] = "preview",
		["P"] = "toggle_preview",
		["k"] = "prev",
		["j"] = "next",
		["zM"] = "fold_close",
		["zR"] = "fold_open",
		["za"] = "fold_toggle",
	},
	modes = {
		diagnostics_float = {
			mode = "diagnostics",
			preview = {
				type = "float",
				relative = "editor",
				border = "rounded",
				title = "Preview",
				title_pos = "center",
				position = { 0, -2 },
				size = { width = 0.35, height = 0.35 },
				zindex = 200,
			},
		},
	},
	mode = "diagnostics_float",
})

-- ============================================================================
-- completion
-- ============================================================================
local cmp = require("cmp")
local auto_select = true

cmp.setup({
	preselect = auto_select and cmp.PreselectMode.Item or cmp.PreselectMode.None,
	completion = {
		completeopt = "menu,menuone,noinsert" .. (auto_select and "" or ",noselect"),
	},
	mapping = cmp.mapping.preset.insert({
		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<CR>"] = cmp.mapping.confirm({ select = auto_select }),
		["<C-y>"] = cmp.mapping.confirm({ select = true }),
		["<S-CR>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace }),
		["<C-CR>"] = function(fallback)
			cmp.abort()
			fallback()
		end,
	}),
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
	}, {
		{ name = "buffer" },
		{ name = "path" },
	}),
	formatting = {
		format = function(_, item)
			local widths = {
				abbr = vim.g.cmp_widths and vim.g.cmp_widths.abbr or 40,
				menu = vim.g.cmp_widths and vim.g.cmp_widths.menu or 30,
			}
			for key, width in pairs(widths) do
				if item[key] and vim.fn.strdisplaywidth(item[key]) > width then
					item[key] = vim.fn.strcharpart(item[key], 0, width - 1) .. "…"
				end
			end
			return item
		end,
	},
})

-- ============================================================================
-- indent guides
-- ============================================================================
vim.api.nvim_set_hl(0, "IblIndent", { fg = "#3F3F3F" })
vim.api.nvim_set_hl(0, "IblIndentDark", { fg = "#2E2E2E" })

vim.api.nvim_create_autocmd("ColorScheme", {
	group = vim.api.nvim_create_augroup("ibl-reapply-hl", { clear = true }),
	callback = function()
		vim.api.nvim_set_hl(0, "IblIndent", { fg = "#3F3F3F" })
		vim.api.nvim_set_hl(0, "IblIndentDark", { fg = "#2E2E2E" })
	end,
})

require("ibl").setup({
	indent = { highlight = { "IblIndent", "IblIndentDark" } },
	scope = { enabled = false },
})

-- ============================================================================
-- treesitter
-- ============================================================================
require("nvim-ts-autotag").setup({
	per_filetype = { ["html"] = { enable_close = false } },
})

require("nvim-treesitter.configs").setup({
	ensure_installed = {
		"typescript",
		"dockerfile",
		"go",
		"gomod",
		"html",
		"python",
		"json",
		"lua",
		"javascript",
		"tsx",
	},
	auto_install = true,
	highlight = { enable = true },
	indent = { enable = true },
})

-- ============================================================================
-- ui
-- ============================================================================
require("nvim-web-devicons").setup({
	override = {
		zsh = { icon = "", color = "#428850", cterm_color = "65", name = "Zsh" },
	},
	color_icons = true,
	default = true,
	strict = true,
	override_by_filename = {
		[".gitignore"] = { icon = "", color = "#f1502f", name = "Gitignore" },
	},
	override_by_extension = {
		["log"] = { icon = "", color = "#81e043", name = "Log" },
	},
	override_by_operating_system = {
		["apple"] = { icon = "", color = "#A2AAAD", cterm_color = "248", name = "Apple" },
	},
})

local lualine_theme = require("lualine.themes.nightfly")
require("lualine").setup({
	options = { theme = lualine_theme },
	sections = {
		lualine_c = { { "filename", path = 1, shorting_target = 20 } },
		lualine_b = { "diagnostics" },
		lualine_x = { "fileformat", "filetype" },
		lualine_z = {},
	},
})

require("gitsigns").setup()

-- ============================================================================
-- telescope
-- ============================================================================
local open_with_trouble = require("trouble.sources.telescope").open
require("telescope").setup({
	defaults = {
		mappings = {
			i = { ["<c-t>"] = open_with_trouble },
			n = { ["<c-t>"] = open_with_trouble },
		},
	},
	pickers = { find_files = { theme = "dropdown" } },
})

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "telescope find files" })
vim.keymap.set("n", "<leader><leader>", builtin.live_grep, { desc = "telescope live grep" })

vim.keymap.set("n", "<C-f>", function()
	local word = vim.fn.expand("<cword>")
	vim.fn.inputsave()
	local search = vim.fn.input("Word to replace (" .. word .. "): ", word)
	local replacement = vim.fn.input("Replace " .. search .. " with: ", search)
	vim.fn.inputrestore()
	if search and replacement and search ~= "" then
		vim.cmd(":%s/\\<" .. search .. "\\>/" .. replacement .. "/gIc")
	end
end, { desc = "replace word (prompted)" })

-- ============================================================================
-- diagnostics helpers
-- ============================================================================
local function diag_text(d)
	local sev_names = { "ERROR", "WARN", "INFO", "HINT" }
	local name = sev_names[d.severity] or ""
	local fname = vim.api.nvim_buf_get_name(d.bufnr or 0)
	local lnum = (d.lnum or 0) + 1
	local col = (d.col or 0) + 1
	return string.format("%s:%d:%d: %s: %s", fname, lnum, col, name, d.message or "")
end

local function copy_diag_at_cursor()
	local bufnr = 0
	local lnum = vim.api.nvim_win_get_cursor(0)[1] - 1
	local diags = vim.diagnostic.get(bufnr, { lnum = lnum })
	if #diags == 0 then
		vim.notify("no diagnostic at cursor", vim.log.levels.WARN)
		return
	end
	local d = diags[1]
	vim.fn.setreg("+", diag_text(d))
	vim.notify("diagnostic copied", vim.log.levels.INFO, { title = "diagnostic" })
end

vim.keymap.set("n", "<leader>yc", copy_diag_at_cursor, { desc = "copy diagnostic at cursor" })

-- ============================================================================
-- conform formatting
-- ============================================================================
local exiting = false

vim.api.nvim_create_autocmd("VimLeavePre", {
	callback = function()
		exiting = true
	end,
})

require("conform").setup({
	format_on_save = function()
		if exiting then
			return
		end
		return { timeout_ms = 500, lsp_format = "fallback" }
	end,
	formatters_by_ft = {
		c = { "clang-format" },
		cpp = { "clang-format" },
		lua = { "stylua" },
		python = { "ruff_organize_imports", "ruff_format" },
		["*"] = { "codespell" },
		["_"] = { "trim_whitespace" },
		rust = { "rustfmt" },
		javascript = { "prettierd", "prettier", stop_after_first = true },
		css = { "prettierd", "prettier", stop_after_first = true },
		html = { "prettierd", "prettier", stop_after_first = true },
		javascriptreact = { "prettierd", "prettier", stop_after_first = true },
		json = { "prettierd", "prettier", stop_after_first = true },
		typescript = { "prettierd", "prettier", stop_after_first = true },
		typescriptreact = { "prettierd", "prettier", stop_after_first = true },
		yaml = { "prettier" },
		go = { "gofumpt", "goimports" },
	},
})

vim.keymap.set("n", "<leader>f", function()
	require("conform").format({ async = true, lsp_fallback = true })
end, { desc = "format buffer" })

-- ============================================================================
-- diagnostic ui
-- ============================================================================
vim.diagnostic.config({
	virtual_text = true,
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "",
			[vim.diagnostic.severity.WARN] = "",
			[vim.diagnostic.severity.INFO] = "",
			[vim.diagnostic.severity.HINT] = "",
		},
	},
	update_in_insert = false,
	underline = true,
	severity_sort = true,
	float = { border = "rounded" },
})

-- ============================================================================
-- commands
-- ============================================================================
vim.api.nvim_create_user_command("Cheet", function()
	local path = vim.fn.stdpath("config") .. "/cheatsheet.md"
	if vim.fn.filereadable(path) == 0 then
		vim.notify("cheatsheet.md not found in " .. path, vim.log.levels.WARN)
		return
	end
	vim.cmd("tabnew " .. path)
end, { desc = "open keybind cheat sheet" })

-- ============================================================================
-- lsp
-- ============================================================================
vim.lsp.set_log_level("error")

require("mason").setup({ ui = { border = "rounded" } })

-- ensure Mason binaries are on PATH (servers + formatters)
vim.env.PATH = vim.env.PATH .. ":" .. vim.fn.stdpath("data") .. "/mason/bin"

local caps = vim.lsp.protocol.make_client_capabilities()
pcall(function()
	caps = require("cmp_nvim_lsp").default_capabilities(caps)
end)

local function lsp_on_attach(_, bufnr)
	local bopts = { noremap = true, silent = true, buffer = bufnr }

	vim.keymap.set("n", "gd", vim.lsp.buf.definition, bopts)
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bopts)
	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bopts)
	vim.keymap.set("n", "gr", vim.lsp.buf.references, bopts)
	vim.keymap.set("n", "K", vim.lsp.buf.hover, bopts)
	vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bopts)
	vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, bopts)
end

vim.lsp.config("gopls", {
	capabilities = caps,
	on_attach = lsp_on_attach,
	settings = {
		gopls = {
			gofumpt = true,
			staticcheck = true,
			analyses = {
				unusedparams = true,
				nilness = true,
				unusedwrite = true,
			},
		},
	},
})

vim.lsp.config("pyright", {
	capabilities = caps,
	on_attach = lsp_on_attach,
	root_markers = { "pyproject.toml", "setup.py", ".git" },
	settings = {
		python = {
			analysis = {
				typeCheckingMode = "basic",
				diagnosticMode = "openFilesOnly",
				useLibraryCodeForTypes = true,
				autoImportCompletions = true,
			},
		},
	},
})

vim.lsp.enable({ "gopls", "pyright" })

require("mason-lspconfig").setup({
	ensure_installed = {
		"pyright",
		"clangd",
		"gopls",
		"tailwindcss",
		"lua_ls",
	},
})

require("mason-tool-installer").setup({
	ensure_installed = {
		"ruff",
		"prettier",
		"prettierd",
		"gofumpt",
		"clang-format",
		"tailwindcss-language-server",
		"typescript-language-server",
	},
	run_on_start = true,
})
pcall(function()
	vim.lsp.enable("vuels", false)
end)

-- ============================================================================
-- typescript tools
-- ============================================================================
vim.keymap.set("n", "<leader>fq", "<cmd>TSToolsAddMissingImports<CR>", { desc = "ts add missing imports" })
vim.keymap.set("n", "<leader>fw", "<cmd>TSToolsOrganizeImports<CR>", { desc = "ts organize imports" })
