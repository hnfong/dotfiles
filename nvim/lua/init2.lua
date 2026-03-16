require 'config.lazy'

--- Start of nvim-tree customization { ---

-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
-- vim.opt.termguicolors = true

-- empty setup using defaults
require("nvim-tree").setup()

-- OR setup with some options
require("nvim-tree").setup({
  sort_by = "case_sensitive",
  view = {
    adaptive_size = true,
  },
  renderer = {
    group_empty = true,
    icons = {
        show = {
            folder_arrow = false,
            git = false,
        },

        --- Say no to custom fonts Chūnibyō ---
        glyphs = {
            default = '📄',
            symlink = '🔗',
            bookmark = '🔖',
            folder = {
                arrow_open = '',
                arrow_closed = '',
                default = '📁',
                open = '📂',
                empty = ' ',
                symlink = '🔗',
                symlink_open = '🔗',
            }
        }
    },
  },
})

--- } End of nvim-tree customization ---


-- https://www.reddit.com/r/neovim/comments/xv7b9j/prevent_exited_terminal_from_closing_buffer_in/
vim.api.nvim_create_autocmd('TermClose', {
  callback = function(ctx)
    vim.cmd('stopinsert')
    vim.api.nvim_create_autocmd('TermEnter', {
      callback = function()
        vim.cmd('stopinsert')
      end,
      buffer = ctx.buf,
    })
  end,
  nested = true,
})



