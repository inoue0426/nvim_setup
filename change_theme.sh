#!/bin/zsh

echo "Starting theme change process..."

# Ensure required directories exist
mkdir -p ~/.config/nvim
mkdir -p ~/.local/share/nvim/site/pack/packer/start

# Install packer if not exists
PACKER_PATH=~/.local/share/nvim/site/pack/packer/start/packer.nvim
if [[ ! -d $PACKER_PATH ]]; then
    echo "Installing packer.nvim..."
    git clone --depth 1 https://github.com/wbthomason/packer.nvim $PACKER_PATH
fi

# Show theme options
echo "Select your preferred theme:"
echo "1) Catppuccin (Modern pastel theme)"
echo "2) Tokyo Night (Dark and elegant)"
echo "3) Nord (Cold arctic theme)"
echo "4) Gruvbox (Retro warm theme)"
echo "5) One Dark (Atom-like theme)"
echo "6) Rose Pine (Soft aesthetic theme)"
echo "7) Dracula (Dark vampire theme)"
echo "8) VSCode Dark (Default VSCode dark theme)"

read "theme_choice?Enter theme number (1-8): "

# Create initial plugin configuration
case $theme_choice in
    1)
        PLUGIN_CONFIG="require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  use { 'catppuccin/nvim', as = 'catppuccin' }
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }
end)"
        ;;
    2)
        PLUGIN_CONFIG="require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  use 'folke/tokyonight.nvim'
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }
end)"
        ;;
    3)
        PLUGIN_CONFIG="require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  use 'shaunsingh/nord.nvim'
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }
end)"
        ;;
    4)
        PLUGIN_CONFIG="require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  use 'ellisonleao/gruvbox.nvim'
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }
end)"
        ;;
    5)
        PLUGIN_CONFIG="require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  use 'navarasu/onedark.nvim'
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }
end)"
        ;;
    6)
        PLUGIN_CONFIG="require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  use { 'rose-pine/neovim', as = 'rose-pine' }
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }
end)"
        ;;
    7)
        PLUGIN_CONFIG="require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  use 'Mofiqul/dracula.nvim'
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }
end)"
        ;;
    8)
        PLUGIN_CONFIG="require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  use 'tomasiser/vim-code-dark'
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }
end)"
        ;;
    *)
        echo "Invalid choice. Exiting."
        exit 1
        ;;
esac

# First, create a temporary init.lua just for plugin installation
NVIM_CONFIG="$HOME/.config/nvim/init.lua"
echo "vim.opt.termguicolors = true" > $NVIM_CONFIG
echo "$PLUGIN_CONFIG" >> $NVIM_CONFIG

# Install plugins
echo "Installing plugins..."
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'

# After plugins are installed, create the full configuration
case $theme_choice in
    1)
        THEME_CONFIG="
vim.opt.termguicolors = true
$PLUGIN_CONFIG

require('catppuccin').setup({
    flavour = 'mocha',
    transparent_background = false,
})
vim.cmd.colorscheme 'catppuccin'

require('lualine').setup {
    options = {
        theme = 'catppuccin'
    }
}"
        ;;
    2)
        THEME_CONFIG="
vim.opt.termguicolors = true
$PLUGIN_CONFIG

require('tokyonight').setup({
    style = 'storm'
})
vim.cmd.colorscheme 'tokyonight'

require('lualine').setup {
    options = {
        theme = 'tokyonight'
    }
}"
        ;;
    3)
        THEME_CONFIG="
vim.opt.termguicolors = true
$PLUGIN_CONFIG

vim.cmd.colorscheme 'nord'

require('lualine').setup {
    options = {
        theme = 'nord'
    }
}"
        ;;
    4)
        THEME_CONFIG="
vim.opt.termguicolors = true
$PLUGIN_CONFIG

require('gruvbox').setup({
    contrast = 'hard',
    transparent_mode = false,
})
vim.cmd.colorscheme 'gruvbox'

require('lualine').setup {
    options = {
        theme = 'gruvbox'
    }
}"
        ;;
    5)
        THEME_CONFIG="
vim.opt.termguicolors = true
$PLUGIN_CONFIG

require('onedark').setup({
    style = 'darker'
})
vim.cmd.colorscheme 'onedark'

require('lualine').setup {
    options = {
        theme = 'onedark'
    }
}"
        ;;
    6)
        THEME_CONFIG="
vim.opt.termguicolors = true
$PLUGIN_CONFIG

require('rose-pine').setup()
vim.cmd.colorscheme 'rose-pine'

require('lualine').setup {
    options = {
        theme = 'rose-pine'
    }
}"
        ;;
    7)
        THEME_CONFIG="
vim.opt.termguicolors = true
$PLUGIN_CONFIG

vim.cmd.colorscheme 'dracula'

require('lualine').setup {
    options = {
        theme = 'dracula'
    }
}"
        ;;
    8)
        THEME_CONFIG="
vim.opt.termguicolors = true
$PLUGIN_CONFIG

vim.cmd.colorscheme 'codedark'

require('lualine').setup {
    options = {
        theme = 'codedark'
    }
}"
        ;;
esac

# Backup existing configuration if it exists
if [[ -f $NVIM_CONFIG ]]; then
    cp $NVIM_CONFIG ${NVIM_CONFIG}.backup
    echo "Backed up existing configuration to ${NVIM_CONFIG}.backup"
fi

# Write the final configuration
echo "$THEME_CONFIG" > $NVIM_CONFIG

# Add some basic Neovim settings
echo '
-- Basic settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2' >> $NVIM_CONFIG

echo "Theme setup completed!"
echo "Please follow these steps to complete the installation:"
echo "1. Start nvim"
echo "2. Run :PackerSync"
echo "3. Restart nvim"
