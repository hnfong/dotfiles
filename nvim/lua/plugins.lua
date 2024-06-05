local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

-- Check whether we want to call PackerSync (to update the packer modules) --
local compare_plugins_touchfile = function()
    local fn = vim.fn
    local this_time = fn.getftime(fn.stdpath('config') .. "/lua/plugins.lua")  -- this file, or whatever file that contains the plugins list
    local touch_time = fn.getftime(fn.stdpath('state') .. "/__my_plugin_touchfile__")
    if touch_time == -1 or this_time > touch_time then
        return true
    end
    return false
end
local refresh_touchfile = function()
    local fn = vim.fn
    fn.writefile({}, fn.stdpath('state') .. "/__my_plugin_touchfile__")
end

local packer_bootstrap = ensure_packer()
require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  -- My plugins here
  use 'nvim-tree/nvim-tree.lua'
  use { 'nvim-telescope/telescope.nvim', tag = '0.1.6', requires = { {'nvim-lua/plenary.nvim'} } }
  -- use 'neovim/nvim-lspconfig'  -- under evaluation

  use 'github/copilot.vim'
  use 'rust-lang/rust.vim'
  use 'neovim/nvim-lspconfig'


  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap or compare_plugins_touchfile() then
    require('packer').sync()
    refresh_touchfile()
  end
end)


-- require'lspconfig'.pyright.setup{}
-- require'lspconfig'.ruby_ls.setup{}
-- require'lspconfig'.solargraph.setup{}

