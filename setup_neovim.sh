#!/bin/bash

# Neovimのインストールと設定を自動化するスクリプト

# Homebrewがインストールされているか確認
if ! command -v brew &> /dev/null; then
    echo "Homebrewがインストールされていません。インストールしています..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Neovimのインストール
echo "Neovimをインストールしています..."
brew install neovim

# 設定ディレクトリの作成
echo "Neovimの設定ディレクトリを作成しています..."
mkdir -p ~/.config/nvim

# init.luaの作成
echo "init.luaを作成しています..."
cat << EOF > ~/.config/nvim/init.lua
-- Packerのブートストラップ
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
  vim.cmd [[packadd packer.nvim]]
end

-- プラグインの設定
require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  use 'neovim/nvim-lspconfig'
  use {
    'nvim-telescope/telescope.nvim',
    requires = { {'nvim-lua/plenary.nvim'} }
  }
  use 'nvim-treesitter/nvim-treesitter'
end)

-- 基本設定
vim.opt.number = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2

-- キーマッピング
vim.keymap.set('n', '<leader>ff', '<cmd>Telescope find_files<CR>')

-- LSP設定
local lspconfig = require('lspconfig')
lspconfig.tsserver.setup{}

-- TreeSitter設定
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "lua", "vim", "javascript", "typescript" },
  highlight = {
    enable = true,
  },
}

-- 自動コマンド
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost init.lua source <afile> | PackerCompile
  augroup end
]])
EOF

# Neovimを起動してプラグインをインストール
echo "プラグインをインストールしています..."
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'

echo "Neovimのセットアップが完了しました！"
