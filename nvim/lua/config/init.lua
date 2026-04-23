-- nvim config main file 
-- lets fucking learn lua and fuck around with vim no ?

-- lsp_config = require('lspconfig') --> deprecated  
-- migrate to vim.pack
vim.pack.add({
	{ src = 'https://github.com/EdenEast/nightfox.nvim', name = 'nightfox' },
})

-- print("loading lua configs")
local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

-- contextual visual highlight 
vim.keymap.set({'x'}, ']n', function() 
	require 'vim.treesitter._select'.select_next(vim.v.count1)
end, { noremap = true, desc = 'select next(or more if passed a count) treesitter node'})

vim.keymap.set({'x'}, '[n', function() 
	require 'vim.treesitter._select'.select_prev(vim.v.count1)
end, { noremap = true, desc = 'select previous(or more if passed a count) treesitter node'})

vim.keymap.set({'x', 'o'}, 'an', function() 
	if vim.treesitter.get_parser(nil, nil, {error =false}) then
		require 'vim.treesitter._select'.select_parent(vim.v.count1)
	else
		vim.lsp.buf.selection_range(vim.v.count1)
	end
end, { noremap = true, desc = 'select one parent(or more if passed a count) treesitter node; falls back to basic selection if treesitter not installed'})

vim.keymap.set({'x', 'o'}, 'in', function() 
	if vim.treesitter.get_parser(nil, nil, {error =false}) then
		require 'vim.treesitter._select'.select_child(vim.v.count1)
	else
		vim.lsp.buf.selection_range(vim.v.count1)
	end
end, { noremap = true, desc = 'select one child(or more if passed a count) treesitter node; falls back to basic selection if treesitter not installed'})

-- this is so the preview window, when autocomplete triggers, is not shown
vim.api.nvim_set_option('completeopt', 'menu')
-- print(vim.api.nvim_get_option('completeopt'))

local on_attach = function(client, bufnr)
	-- Enable compeletion triggered by <Ctrl-x><Ctrl-o>
	vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
	-- type hints
	vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })

	local bufopts = { noremap = true, silent = true, buffer = bufnr }	
	vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
	vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
	vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
	vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
	vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
	vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
	vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
	vim.keymap.set('n', '<space>wl', function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, bufopts)
	vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
	vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
	vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
	vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
	vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)
end

vim.lsp.config("pyright", {
	on_attach = on_attach, 
	flags = {}
})

vim.lsp.config("tsserver", {
	on_attach = on_attach, 
	flags = {}
})

vim.lsp.config("rust_analyzer", {
	on_attach = on_attach, 
	flags = {},
	-- server specific settings	
	settings = {
		["rust-analyzer"] = {}
	}
})

-- require("ccls").setup({lsp = {use_defaults = true}})
vim.lsp.config("ccls", {
	on_attach = on_attach,
	flags = {},
	root_markers = {"compile_commands.json", ".clangd", "./build/compile_commands.json", ".ccls", ".git"},
	--- root_dir = vim.lsp.util.root_pattern('compile_commands.json', './build/compile_commands.json', '.ccls', '.git') -> deprecated
})

vim.lsp.config("gopls", {
	on_attach = on_attach,
	flags = {},
	cmd = {"gopls", "serve"},	
	filetypes = {"go", "gomod"},
	root_markers = {"go.work", "go.mod", ".git"},
	settings = {
		gopls = {
			analyses = {
				unusedparams = true,
			},
			staticcheck = true,
		}
	}
})

vim.lsp.config("clangd", {
	on_attach = on_attach,
	cmd = {
		'clangd', 
		'--background-index',
		'--clang-tidy', 
		'--log=verbose',
		'--query-driver=/usr/bin/g++,/usr/bin/clang++,/usr/bin/clang',
		'--header-insertion=never',	-- what does it do ?? idk
	},	
	init_options = {
		fallbackFlags = {'-std=c++17'},
	},
	root_markers = {"compile_commands.json", ".git"},
	filetypes = {'c', 'cpp'},
})

-- enable lsp clients 
vim.lsp.enable({"pyright"})
vim.lsp.enable("tsserver")
vim.lsp.enable("rust_analyzer")
-- vim.lsp.enable({"ccls"})
vim.lsp.enable({"gopls"})
vim.lsp.enable({"clangd"})

-- config treesitter(probably should start separating these blocks in separate files

vim.api.nvim_create_autocmd('FileType', {
	pattern = {'cpp', 'c', 'rust'},
	callback = function()
		vim.treesitter.start()
		vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
		vim.opt.foldmethod = 'expr'
		vim.opt.foldenable = false 
		-- zo, zc, zO(open all), zC(close all), za, zv(view cursor line), zx(update fold), zm(fold more)
		-- vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
		-- vim.wo[0][0].foldmethod = 'expr'
	end,
})

-- carbonfox theme customization(yeah this is my life, i customize my text editor in my precious time
require('nightfox').setup({
	options= {
		dim_inactive = false,
		transparent= true,
		styles = {
			comments = "italic",
			types = "bold"
		},
	},

	-- groups = {
		-- all = {
		-- 	Visual = { bg = "palette.cyan.dim" },
		-- },
	-- },
})

-- following line doesnt seem to work, need to figure this out, 
-- otherwise the theme just converts unused imports into comments visually
-- vim.api.nvim_set_hl(0, "@keyword.import.cpp", {})

-- treesitter config -> set in as autocmd
-- vim.opt.foldmethod = 'expr'
-- vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'

-- colorscheme settings
vim.cmd.colorscheme('carbonfox')

border = string.rep("*", 10)
empty_line = string.rep(" ", 10)
--print("\n\n")
print(border)
print("Loaded lua.init")
-- print("Dont' forget to add me")
print(border)
print(empty_line)
--print("\n\n")

