return {
  'rmagatti/auto-session',
  lazy = false,
  config = function()
    require('auto-session').setup {
      log_level = 'error',
      auto_restore = false,
      auto_save = true,
      suppressed_dirs = { '~/', 'C:\\Users\\', '/' },
    }
  end,
}
