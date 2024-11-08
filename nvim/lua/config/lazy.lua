-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = "\\"
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    { 'nvim-telescope/telescope.nvim', tag = '0.1.8', dependencies = { 'nvim-lua/plenary.nvim' } },
    { 'nvim-tree/nvim-tree.lua' },
    -- { 'github/copilot.vim' },
    { 'nvim-treesitter/nvim-treesitter' },
    { 'neovim/nvim-lspconfig',
    },

    { 'junegunn/vim-peekaboo' }, -- Peekaboo will show you the contents of the registers on the sidebar when you hit " or @ in normal mode or <CTRL-R> in insert mode.
    { "cbochs/portal.nvim" }, -- Portal is a plugin that aims to build upon and enhance existing location lists (e.g. jumplist, changelist, quickfix list, etc.)
    { 'chrishrb/gx.nvim', submodules = false, config = true, keys = { { "gx", "<cmd>Browse<cr>", mode = { "n", "x" } } }, cmd = { "Browse" }, init = function ()
      vim.g.netrw_nogx = 1 -- disable netrw gx
    end },

    -- These are probably great but I don't have time to train myself to use them
    -- https://github.com/tpope/vim-surround  - shorter keystrokes for surrounding quotes, parenthesis, etc.
    --
    -- Might be slow
    -- { 'wellle/context.vim' },  -- A Vim plugin that shows the context of the currently visible buffer contents
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  -- install = { colorscheme = { "habamax" } },
  -- automatically check for plugin updates
  checker = { enabled = false },
})

-- Put here because we want to toggle this with F7 instead.
LspConfigManualTrigger = function()
    local lspconfig = require("lspconfig")
    -- lspconfig.pyright.setup({}) -- probably overly zealous and doesn't work well with django
    -- lspconfig.basedpyright.setup({})
    lspconfig.clangd.setup({})
    lspconfig.ruff.setup({})
    lspconfig.ts_ls.setup{
        on_attach = on_attach,
        flags = lsp_flags,
        settings = {
            completions = {
                completeFunctionCalls = true
            }
        }
    }


    lspconfig.rust_analyzer.setup({
        on_attach = on_attach,
        settings = {
            ["rust-analyzer"] = {
                imports = {
                    granularity = {
                        group = "module",
                    },
                    prefix = "self",
                },
                cargo = {
                    buildScripts = {
                        enable = true,
                    },
                },
                procMacro = {
                    enable = true
                },
            }
        }
    })
end
