-- lua/plugins/git.lua

-- Set before add(): plugin/lazygit.vim only assigns when the var is unset.
vim.g.lazygit_floating_window_scaling_factor = 0.9
vim.g.lazygit_floating_window_border_chars = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' }

vim.pack.add({
  { src = 'https://github.com/lewis6991/gitsigns.nvim' },
  { src = 'https://github.com/kdheepak/lazygit.nvim' },
}, { load = true })

-- gitsigns must be eager: it attaches to every buffer as you open it.
require('gitsigns').setup({
  signs = {
    add          = { text = '┃' },
    change       = { text = '┃' },
    delete       = { text = '_' },
    topdelete    = { text = '‾' },
    changedelete = { text = '~' },
    untracked    = { text = '┆' },
  },
  signs_staged = {
    add          = { text = '┃' },
    change       = { text = '┃' },
    delete       = { text = '_' },
    topdelete    = { text = '‾' },
    changedelete = { text = '~' },
  },

  watch_gitdir = { follow_files = true },
  attach_to_untracked = true,
  current_line_blame = false,
  current_line_blame_opts = { virt_text_pos = 'eol', delay = 300 },
  preview_config = { border = 'rounded' },
  sign_priority = 6,
  update_debounce = 100,
  max_file_length = 40000,

  on_attach = function(bufnr)
    local gs = require('gitsigns')
    local function map(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
    end

    map('n', ']c', function()
      if vim.wo.diff then return ']c' end
      vim.schedule(function() gs.nav_hunk('next') end)
      return '<Ignore>'
    end, 'Next hunk')

    map('n', '[c', function()
      if vim.wo.diff then return '[c' end
      vim.schedule(function() gs.nav_hunk('prev') end)
      return '<Ignore>'
    end, 'Prev hunk')

    map('n', '<leader>hs', gs.stage_hunk,  'Stage hunk')
    map('n', '<leader>hr', gs.reset_hunk,  'Reset hunk')
    map('v', '<leader>hs', function() gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end, 'Stage hunk (range)')
    map('v', '<leader>hr', function() gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end, 'Reset hunk (range)')
    map('n', '<leader>hS', gs.stage_buffer, 'Stage buffer')
    map('n', '<leader>hR', gs.reset_buffer, 'Reset buffer')
    map('n', '<leader>hp', gs.preview_hunk, 'Preview hunk')
    map('n', '<leader>hb', function() gs.blame_line({ full = true }) end, 'Blame line')
    map('n', '<leader>hd', gs.diffthis,     'Diff this')
    map('n', '<leader>hD', function() gs.diffthis('~') end, 'Diff this (~)')
    map('n', '<leader>tb', gs.toggle_current_line_blame, 'Toggle line blame')
    map('n', '<leader>td', gs.toggle_deleted, 'Toggle deleted')
    map({ 'o', 'x' }, 'ih', gs.select_hunk, 'Select hunk')
  end,
})
