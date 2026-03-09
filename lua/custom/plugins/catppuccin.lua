return {
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    config = function()
      require('catppuccin').setup {
        flavour = 'mocha',
        background = { light = 'latte', dark = 'mocha' },
        transparent_background = false,
        term_colors = true,
        styles = {
          comments = {},
          conditionals = {},
          loops = {},
          functions = {},
          keywords = {},
          strings = {},
          variables = {},
          numbers = {},
          booleans = {},
          properties = {},
          types = {},
          operators = {},
        },
        integrations = {
          cmp = true,
          gitsigns = true,
          nvimtree = true,
          treesitter = true,
          telescope = { enabled = true },
          which_key = true,
          mini = { enabled = true },
          blink_cmp = true,
        },
      }

      vim.cmd.colorscheme 'catppuccin-mocha'
    end,
  },
}
