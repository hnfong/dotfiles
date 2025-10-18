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
    {
        "neovim/nvim-lspconfig",
        config = function()

            -- Much of this is currently referencing https://www.swift.org/documentation/articles/zero-to-swift-nvim.html#language-server-support
            local lspconfig = require('lspconfig')
            lspconfig.sourcekit.setup {
                capabilities = {
                    workspace = {
                        didChangeWatchedFiles = {
                            dynamicRegistration = true,
                        },
                    },
                },
            }


            -- Python LSP (Pyright)
            lspconfig.pyright.setup {
                capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities()),
                settings = {
                    python = {
                        analysis = {
                            autoSearchPaths = true,
                            useLibraryCodeForTypes = true,
                            diagnosticMode = "openFilesOnly",
                            typeCheckingMode = "basic",  -- "off", "basic", or "strict"
                        },
                    },
                },
            }

            vim.api.nvim_create_autocmd('LspAttach', {
                desc = 'LSP Actions',
                callback = function(args)
                    vim.keymap.set('n', '<F1>', vim.lsp.buf.hover, {noremap = true, silent = true})
                    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {noremap = true, silent = true})

                    vim.keymap.set('n', '<F2>', function()
                        vim.diagnostic.goto_next()
                        vim.diagnostic.open_float(nil, { focus = false })
                    end, { desc = "Next diagnostic and show message" })



                    -- https://www.reddit.com/r/neovim/comments/zjqquc/how_do_i_turn_off_semantic_tokens/
                    local client = vim.lsp.get_client_by_id(args.data.client_id)
                    client.server_capabilities.semanticTokensProvider = nil
                end,
            })

        end,
    },


    -- Much of this is currently referencing https://www.swift.org/documentation/articles/zero-to-swift-nvim.html#language-server-support
    {
        "hrsh7th/nvim-cmp",
        version = false,
        event = "InsertEnter",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-buffer",
        },
        config = function()
            local cmp = require('cmp')
            local opts = {
                -- Where to get completion results from
                sources = cmp.config.sources {
                    { name = "nvim_lsp" },
                    { name = "buffer"},
                    { name = "path" },
                },
                -- Make 'enter' key select the completion

                mapping = cmp.mapping.preset.insert({
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                    ["<tab>"] = cmp.mapping(function(original)
                        if cmp.visible() then
                            cmp.select_next_item() -- run completion selection if completing
                        else
                            original()      -- run the original behavior if not completing
                        end
                    end, {"i", "s"}),
                    ["<S-tab>"] = cmp.mapping(function(original)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        else
                            original()
                        end
                    end, {"i", "s"}),
                }),
            }
            cmp.setup(opts)
        end,
    },

    { 'junegunn/vim-peekaboo' }, -- Peekaboo will show you the contents of the registers on the sidebar when you hit " or @ in normal mode or <CTRL-R> in insert mode.
    { "cbochs/portal.nvim" }, -- Portal is a plugin that aims to build upon and enhance existing location lists (e.g. jumplist, changelist, quickfix list, etc.)
    { 'chrishrb/gx.nvim', submodules = false, config = true, keys = { { "gx", "<cmd>Browse<cr>", mode = { "n", "x" } } }, cmd = { "Browse" }, init = function ()
      vim.g.netrw_nogx = 1 -- disable netrw gx
    end },


    {
        -- https://github.com/iamcco/markdown-preview.nvim/issues/690#issuecomment-2371742039
        -- install markdown-preview.nvim without yarn or npm
        'iamcco/markdown-preview.nvim',
        event = "VeryLazy",
        cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
        ft = { 'markdown' },
        -- Uncomment this for build.
        -- build = function()
            -- vim.fn['mkdp#util#install']()
        -- end,
    },

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
