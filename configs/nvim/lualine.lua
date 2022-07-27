require('lualine').setup({
  options = {
    section_separators = '',
    component_separators = '',
    theme = '',
  },
  tabline = {
    lualine_a = {'buffers'},
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {'filename'},
    lualine_z = {'tabs'},
  }
})

