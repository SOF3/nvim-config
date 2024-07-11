vim.opt.autoindent = true
vim.opt.showmatch = true
vim.opt.laststatus = 2 -- show filename of each pane
vim.opt.showcmd = true
vim.opt.showmode = false -- already covered by airline
vim.opt.clipboard = {} -- maintain separate clipboards
vim.opt.mouse = {} -- easier to copy from terminal directly; otherwise moving via keys is easier
vim.opt.wildmode = {'list:longest', 'longest:full'}

vim.opt.hidden = true
vim.opt.startofline = true -- idk why nvim turns this off by default...

vim.opt.autoread = true
vim.opt.autowrite = true
vim.opt.maxmempattern = 10000

-- {number}j/{number}k
vim.opt.number = true
vim.opt.relativenumber = true

-- Case-insensitive search, use \c to override
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Insert completion
vim.opt.completeopt = {'menuone', 'noselect'}

-- Expand fold
vim.opt.foldopen = {'all'}
