require 'plugins'

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

vim.api.nvim_set_keymap('n', '<F8>', ':NvimTreeToggle<CR>', {})

--- } End of nvim-tree customization ---


--- Begin telescope customization { ---
vim.keymap.set('n', '<F9>', require('telescope.builtin').git_files, {})
vim.api.nvim_set_keymap('n', '<F21>', ':Telescope ', {})  -- Current terminal says Shift-F9 is F21...
--- } End telescope customization ---

-- Configure `ruff-lsp`.
-- See: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#ruff_lsp
-- For the default config, along with instructions on how to customize the settings
-- require('lspconfig').ruff_lsp.setup { init_options = { settings = { args = {}, } } }
