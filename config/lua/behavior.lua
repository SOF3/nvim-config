local cmp = require 'cmp'
local telescope = require('telescope.builtin')

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

-- Change %% to current dir
vim.cmd.cabbr {args = {'<args>', '%%', "expand('%:p:h')"}}

-- Jump-to column is more common than jump-to-line
vim.keymap.set('n', '\'', '`')

-- Select and group by typing delimiters
function map_delim_group(open, close)
	vim.keymap.set('v', open .. close, function()
		local mode = vim.fn.mode()

		local _, start_row, start_col = unpack(vim.fn.getpos("."))
		local _, end_row, end_col = unpack(vim.fn.getpos("v"))
		if (start_row == end_row and start_col > end_col) or start_row > end_row then
			start_row, start_col, end_row, end_col = end_row, end_col, start_row, start_col
		end
		if mode == 'V' then
			start_col = 1
			end_col = #vim.fn.getline(end_row)
		end

		local text = vim.api.nvim_buf_get_text(0, start_row - 1, start_col - 1, end_row - 1, end_col, {})
		if mode == 'V' then
			table.insert(text, 1, open)
			table.insert(text, close)
		else
			text[1] = open .. text[1]
			text[#text] = text[#text] .. close
		end

		vim.api.nvim_buf_set_text(0, start_row - 1, start_col - 1, end_row - 1, end_col, text)
	end)
end

map_delim_group('(', ')')
map_delim_group('[', ']')
map_delim_group('{', '}')
map_delim_group('"', '"')
map_delim_group("'", "'")
map_delim_group('`', '`')
map_delim_group('<', '>')

vim.keymap.set('i', '<C-w>', '<Esc><C-w>')

for tab = 1.,9 do
	vim.keymap.set('n', 'g' .. tab, function() vim.cmd.tabnext(tab) end)
end

vim.keymap.set('n', 'zf', telescope.git_files)
vim.keymap.set('n', 'zF', telescope.find_files)
vim.keymap.set('n', 'zg', telescope.live_grep)
vim.keymap.set('n', 'zs', telescope.lsp_workspace_symbols)
vim.keymap.set('n', 'zd', telescope.diagnostics)

-- Clear auto highlight
vim.keymap.set('n', 'H', vim.cmd.nohls)

-- I use :qa or just autosave
vim.keymap.set('n', 'ZZ', vim.cmd.NERDTreeFind)

local remember_folds = vim.api.nvim_create_augroup('remember_folds', {})
vim.api.nvim_create_autocmd({'BufWrite', 'BufWinLeave'}, {
	pattern = '*.*',
	group = remember_folds,
	command = 'mkview',
})
vim.api.nvim_create_autocmd({'BufReadPost', 'BufWinEnter'}, {
	pattern = '*.*',
	group = remember_folds,
	command = 'silent! loadview',
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