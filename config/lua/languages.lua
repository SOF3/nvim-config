-- Setup for languages of concern

local cmp = require 'cmp'
local lsp = require 'lspconfig'
local cmp_capabilities = require('cmp_nvim_lsp').default_capabilities()

vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'

require 'nvim-treesitter.configs'.setup {
	ensure_installed = {"vim", "go", "rust", "markdown", "lua", "make", "yaml", "vhs", "json", "typescript", "php", "python", "jq", "dockerfile", "editorconfig", "bash", "toml"},
	auto_install = true,
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = true,
	},
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = "gsk",
			node_incremental = "gsn",
			scope_incremental = "gss",
			node_decremental = "gsp",
		},
	},
	indent = {
		enable = true,
	},
}

local function common_lsp_setup(client, bufnr)
	local function on_list(options)
		vim.fn.setqflist({}, 'r', options)
		if #options.items == 1 then
			vim.cmd.cclose()
			vim.cmd.cfirst()
		else
			vim.cmd.copen()
		end
	end
	local single_list_opts = {on_list = on_list}

	vim.keymap.set('n', 'gd', function() vim.lsp.buf.definition(single_list_ops) end, {buffer = bufnr})
	vim.keymap.set('n', 'gi', function() vim.lsp.buf.implementation(single_list_ops) end, {buffer = bufnr})
	vim.keymap.set('n', 'gy', function() vim.lsp.buf.type_definition(single_list_ops) end, {buffer = bufnr})
	vim.keymap.set('n', 'gr', function() vim.lsp.buf.references(single_list_ops) end, {buffer = bufnr})

	local severity = vim.diagnostic.severity
	vim.keymap.set('n', 'g[', function() vim.diagnostic.goto_prev { severity = { min = severity.WARN } } end, {buffer = bufnr})
	vim.keymap.set('n', 'g]', function() vim.diagnostic.goto_next { severity = { min = severity.WARN } } end, {buffer = bufnr})
	vim.keymap.set('n', 'g{', function() vim.diagnostic.goto_prev { severity = { min = severity.ERROR } } end, {buffer = bufnr})
	vim.keymap.set('n', 'g}', function() vim.diagnostic.goto_next { severity = { min = severity.ERROR } } end, {buffer = bufnr})

	vim.keymap.set('n', 'L', function() vim.lsp.buf.code_action() end, {buffer = bufnr})
	vim.keymap.set('n', 'Kn', function() vim.lsp.buf.rename() end, {buffer = bufnr})
	vim.keymap.set('n', 'M', function() vim.lsp.buf.hover() end, {buffer = bufnr})

	if client.supports_method('textDocument/documentHighlight') then
		vim.api.nvim_create_autocmd('CursorHold', {
			buffer = bufnr,
			callback = function() vim.lsp.buf.document_highlight() end,
		})
		vim.api.nvim_create_autocmd({'CursorMoved', 'ModeChanged'}, {
			buffer = bufnr,
			callback = function() vim.lsp.buf.clear_references() end,
		})
	end
end

lsp.gopls.setup {
	on_attach = function(client, bufnr)
		common_lsp_setup(client, bufnr)
		vim.opt_local.foldlevel = 0
	end,
	capabilities = cmp_capabilities,
}

lsp.rust_analyzer.setup {
	on_attach = function(client, bufnr)
		common_lsp_setup(client, bufnr)
		vim.opt_local.foldlevel = 0
	end,
	capabilities = cmp_capabilities,
}
