local catppuccin = require 'catppuccin'

vim.g.airline_powerline_fonts = true
vim.g.airline_theme = 'catppuccin'
vim.g['airline#extensions#clock#format'] = '%H:%M:%S'
vim.g['airline#extensions#clock#updatetime'] = 100

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
			LineNrBelow = { fg = colors.sky, }
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
