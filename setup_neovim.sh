#!/bin/zsh

# Script to automate the installation and configuration of Neovim

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
    echo "Homebrew is not installed. Installing..."
    /bin/zsh -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install Neovim
echo "Installing Neovim..."
brew install neovim

# Create configuration directory
echo "Creating Neovim configuration directory..."
mkdir -p ~/.config/nvim

# Create init.lua
echo "Creating init.lua..."
cat << EOF > ~/.config/nvim/init.lua
-- Packer bootstrap
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
  vim.cmd [[packadd packer.nvim]]
end

-- Plugin configuration
require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  use 'neovim/nvim-lspconfig'
  use {
    'nvim-telescope/telescope.nvim',
    requires = { {'nvim-lua/plenary.nvim'} }
  }
  use 'nvim-treesitter/nvim-treesitter'
end)

-- Basic settings
vim.opt.number = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2

-- Key mapping
vim.keymap.set('n', '<leader>ff', '<cmd>Telescope find_files<CR>')

-- LSP configuration
local lspconfig = require('lspconfig')
-- Updated to use ts_ls instead of tsserver
lspconfig.ts_ls.setup{}

-- TreeSitter configuration
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "lua", "vim", "javascript", "typescript" },
  highlight = {
    enable = true,
  },
}

-- Auto command
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost init.lua source <afile> | PackerCompile
  augroup end
]])
EOF

# Start Neovim to install plugins
echo "Installing plugins..."
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'

# Set Neovim as an alias for vim
echo "Setting Neovim as an alias for vim..."

# Check the user's shell
if [ -n "$BASH_VERSION" ]; then
    SHELL_RC="$HOME/.bashrc"
elif [ -n "$ZSH_VERSION" ]; then
    SHELL_RC="$HOME/.zshrc"
else
    echo "Unsupported shell. Please set the alias manually."
    SHELL_RC=""
fi

if [ -n "$SHELL_RC" ]; then
    # Check if the alias already exists
    if ! grep -q "alias vim='nvim'" "$SHELL_RC"; then
        echo "alias vim='nvim'" >> "$SHELL_RC"
        echo "alias vi='nvim'" >> "$SHELL_RC"
        echo "Added aliases to $SHELL_RC."
    else
        echo "Aliases are already set."
    fi

    # Reflect changes immediately
    source "$SHELL_RC"
fi

echo "Neovim setup completed!"
echo "Please start a new terminal session or run 'source $SHELL_RC' to enable the aliases."
