-- nvim config main file 
-- lets fucking learn lua and fuck around with vim no ?

lsp_config = require('lspconfig') 

local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

-- this is so the preview window, when autocomplete triggers, is not shown
vim.api.nvim_set_option('completeopt', 'menu')
-- print(vim.api.nvim_get_option('completeopt'))

local on_attach = function(client, bufnr)
	-- Enable compeletion triggered by <Ctrl-x><Ctrl-o>
	vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
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

lsp_config.pyright.setup{
	on_attach = on_attach, 
	flags = {}
}
lsp_config.tsserver.setup{
	on_attach = on_attach, 
	flags = {}
}
lsp_config['rust_analyzer'].setup{
	on_attach = on_attach, 
	flags = {},
	-- server specific settings	
	settings = {
		["rust-analyzer"] = {}
	}
}
-- require("ccls").setup({lsp = {use_defaults = true}})
lsp_config['ccls'].setup({
	on_attach = on_attach,
	flags = {},
	root_dir = lsp_config.util.root_pattern('compile_commands.json', './build/compile_commands.json', '.ccls', '.git')
})

lsp_config['gopls'].setup({
	on_attach = on_attach,
	flags = {},
	cmd = {"gopls", "serve"},	
	filetypes = {"go", "gomod"},
	root_dir = lsp_config.util.root_pattern("go.work", "go.mod", ".git"),
	settings = {
		gopls = {
			analyses = {
				unusedparams = true,
			},
			staticcheck = true,
		}
	}
})


border = string.rep("*", 10)
empty_line = string.rep(" ", 10)
--print("\n\n")
print(border)
print("Loaded lua.init")
-- print("Dont' forget to add me")
print(border)
print(empty_line)
--print("\n\n")

