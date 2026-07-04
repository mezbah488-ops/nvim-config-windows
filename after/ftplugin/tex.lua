vim.opt_local.foldmethod = 'expr'
vim.opt_local.foldexpr = 'vimtex#fold#level(v:lnum)'
vim.opt_local.foldtext = 'vimtex#fold#text()'
vim.opt_local.foldlevel = 1
vim.opt_local.foldenable = false -- since your global default turns folding OFF

vim.opt_local.wrap = true
vim.opt_local.linebreak = true -- wrap at word boundaries, not mid-word
vim.opt_local.textwidth = 0 -- don't hard-wrap with inserted newlines
vim.opt_local.breakindent = true -- wrapped lines keep the indent of the original

-- Navigate by visual line instead of logical line, since lines are long/wrapped
vim.keymap.set('n', 'j', 'gj', { buffer = true })
vim.keymap.set('n', 'k', 'gk', { buffer = true })

-- --spell check
-- vim.opt_local.spell = true
-- vim.opt_local.spelllang = 'en_us'
--
-- --conceallevel
-- vim.opt_local.conceallevel = 1
-- vim.opt_local.concealcursor = 'nc' -- conceal even when cursor is on the line, in normal/command mode
