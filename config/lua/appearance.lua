local catppuccin = require 'catppuccin'

vim.g.airline_powerline_fonts = true
vim.g.airline_theme = 'catppuccin'
vim.g['airline#extensions#tabline#enabled'] = 1
vim.g['airline#extensions#tabline#formatter'] = 'unique_tail_improved'
vim.g['airline#extensions#clock#format'] = '%H:%M:%S'
vim.g['airline#extensions#clock#updatetime'] = 500
vim.g['airline#extensions#tabline#overflow_marker'] = '…'
vim.g['airline#extensions#tabline#buffer_idx_mode'] = 2

vim.keymap.set('n', 'g-', '<Plug>AirlineSelectPrevTab', {})
vim.keymap.set('n', 'g+', '<Plug>AirlineSelectNextTab', {})
for j = 0,9 do
	vim.keymap.set('n', 'g' .. j, '<Plug>AirlineSelectTab1' .. j, {})
	for i = 1,9 do
		vim.keymap.set('n', 'z' .. i .. j, '<Plug>AirlineSelectTab' .. i .. j, {})
	end
end

vim.g.gitblame_highlight_group = 'Conceal'
vim.g.gitblame_message_template = '<sha> <date> <author> | <summary>'
vim.g.gitblame_date_format = '%r'

local initial_colors = {
	mocha = {
		base = '#1e1e22',
	},
}

catppuccin.setup {
	color_overrides = initial_colors,
	custom_highlights = function(colors)
		return {
			LineNr = { fg = colors.green },
			LineNrAbove = { fg = colors.flamingo },
			LineNrBelow = { fg = colors.sky },
			NormalFloat = { bg = colors.surface1 },
			ExtraWhitespace = { bg = colors.red },
			Visual = { bg = colors.overlay0 },
			Search = { bg = colors.overlay2 },
		}
	end,
}
vim.cmd.colorscheme "catppuccin-mocha"

vim.api.nvim_create_autocmd('FocusGained', {
	callback = function()
		catppuccin.setup {
			color_overrides = initial_colors,
		}
		vim.cmd.colorscheme "catppuccin-mocha"
	end,
})

vim.api.nvim_create_autocmd('FocusLost', {
	callback = function()
		catppuccin.setup {
			color_overrides = {
				mocha = {
					base = '#2e3e2e',
				},
			},
		}
		vim.cmd.colorscheme "catppuccin-mocha"
	end,
})
