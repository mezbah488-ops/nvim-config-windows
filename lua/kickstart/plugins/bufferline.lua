return {
  'akinsho/bufferline.nvim',
  version = '*',
  dependencies = 'nvim-tree/nvim-web-devicons',
  event = 'VeryLazy',
  opts = {
    options = {
      mode = 'buffers',
      separator_style = 'slant',
      always_show_bufferline = true,
      show_buffer_close_icons = true,
      show_close_icon = false,
      color_icons = true,
    },
  },
  keys = {
    { '<Tab>', '<Cmd>BufferLineCycleNext<CR>', desc = 'Next buffer' },
    { '<S-Tab>', '<Cmd>BufferLineCyclePrev<CR>', desc = 'Prev buffer' },
  },
}
