--- Personal keymaps.

-- Change %% to current dir
vim.cmd.cabbr {args = {'<expr>', '%%', "expand('%:h')"}}

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
		vim.api.nvim_win_set_cursor(0, {start_row, start_col - 1})

		if mode == 'V' or mode == 'v' then
			vim.api.nvim_input('<Esc>')
		end
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

-- Clear auto highlight
vim.keymap.set('n', 'H', vim.cmd.nohls)

-- quickfix keymap
vim.api.nvim_create_autocmd({'BufEnter', 'BufWinEnter'}, {
	callback = function()
		if vim.bo.buftype == 'quickfix' then
			vim.keymap.set('n', 'q', vim.cmd.quit, {buffer = 0})
			vim.keymap.set('n', '<Cr>', '<Cr><Cmd>:cclose<Cr>', {buffer = 0})
			vim.keymap.set('t', '<Cr>', '<Cr><Cmd>:cclose<Cr>', {buffer = 0})
		end
	end
})
