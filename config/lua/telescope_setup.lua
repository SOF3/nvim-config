local telescope = require('telescope')
local telescope_builtin = require('telescope.builtin')
local telescope_themes = require('telescope.themes')

-- I use :qa or just autosave, no need for ZZ
vim.keymap.set('n', 'ZZ', function()
	telescope.extensions.file_browser.file_browser {
		path = "%:p:h",
		select_buffer = true,
		depth = 1,
	}
end)

vim.keymap.set('n', 'zb', telescope_builtin.buffers)
vim.keymap.set('n', 'zF', telescope_builtin.git_files)
vim.keymap.set('n', 'zf', telescope_builtin.find_files)
vim.keymap.set('n', 'zg', telescope_builtin.live_grep)
vim.keymap.set('n', 'zG', function()
	telescope_builtin.live_grep {
		grep_open_files = true,
	}
end)
vim.keymap.set('n', 'zs', telescope_builtin.lsp_dynamic_workspace_symbols)
vim.keymap.set('n', 'gr', function()
	telescope_builtin.lsp_references(telescope_themes.get_ivy {
		layout_strategy = 'vertical',
		layout_config = {
			width = 0.9,
			height = 0.9,
		},
		initial_mode = 'normal',
	})
end)
vim.keymap.set('n', 'gs', function()
	telescope_builtin.lsp_dynamic_workspace_symbols(telescope_themes.get_ivy {
		layout_strategy = 'vertical',
		layout_config = {
			width = 0.9,
			height = 0.9,
		},
	})
end)
vim.keymap.set('n', 'zd', telescope_builtin.diagnostics)

telescope.setup {
	extensions = {
		fzy_native = {
			override_file_sorter = true,
			override_generic_sorter = true,
		},
		file_browser = {
			hijack_netrw = true,
		},
	},
}
telescope.load_extension('fzy_native')
telescope.load_extension('file_browser')
