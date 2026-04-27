local cmp = require 'cmp'
local luasnip = require 'luasnip'

-- Autosave after 0.3s
vim.opt.updatetime = 300
vim.api.nvim_create_autocmd({'CursorHold', 'CursorHoldI', 'BufEnter', 'FocusGained'}, {
	pattern = {"?*"},
	callback = function(ev)
		if vim.bo.buftype == "" then
			vim.cmd.update()
		end
	end,
})

local remember_folds = vim.api.nvim_create_augroup('remember_folds', {})
vim.api.nvim_create_autocmd({'BufWrite', 'BufWinLeave'}, {
	pattern = {"?*"},
	group = remember_folds,
	callback = function()
		if vim.bo.buftype == "" then
			vim.cmd.mkview()
		end
	end,
})
vim.api.nvim_create_autocmd({'BufReadPost', 'BufWinEnter'}, {
	pattern = {"?*"},
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

-- no airline in floating windows
vim.api.nvim_create_autocmd("WinNew", {
  pattern = "*",
  callback = function()
    -- Safely get the ID of the window being created
    local win_id = vim.api.nvim_get_current_win()
    local win_config = vim.api.nvim_win_get_config(win_id)

    -- Floating windows have a 'relative' property that isn't empty
    if win_config.relative ~= "" then
      vim.w[win_id].airline_disable_statusline = 1
    end
  end,
})
