local cmp = require 'cmp'
local luasnip = require 'luasnip'

-- Autosave after 0.3s
vim.opt.updatetime = 300
vim.api.nvim_create_autocmd({'CursorHold', 'CursorHoldI'}, {
	pattern = {"*.*"},
	callback = function(ev) vim.cmd.update() end,
})
vim.api.nvim_create_autocmd({'CursorHold', 'CursorHoldI', 'BufEnter', 'FocusGained'}, {
	pattern = {"*.*"},
	callback = function(ev) vim.cmd.update() end,
})

local remember_folds = vim.api.nvim_create_augroup('remember_folds', {})
vim.api.nvim_create_autocmd({'BufWrite', 'BufWinLeave'}, {
	group = remember_folds,
	callback = function()
		if vim.bo.buftype == "" then
			vim.cmd.mkview()
		end
	end,
})
vim.api.nvim_create_autocmd({'BufReadPost', 'BufWinEnter'}, {
	pattern = '*.*',
	group = remember_folds,
	callback = function()
		if vim.bo.buftype == "" then
			vim.cmd('silent! loadview')
		end
	end,
})

-- Replacement of :e without reloading folds
vim.api.nvim_create_user_command('E', function()
	vim.cmd.mkview()
	vim.cmd.edit()
end, {})

require 'nvim-autopairs'.setup {}

cmp.setup {
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
	mapping = cmp.mapping.preset.insert{
	      ['<C-c>'] = cmp.mapping.complete(),
	      ['<C-y>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
	},
	sources = {
		{name = 'nvim_lsp'},
		{name = 'luasnip'},
	},
}

cmp.event:on('confirm_done', require 'nvim-autopairs.completion.cmp'.on_confirm_done())
