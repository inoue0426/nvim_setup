#!/bin/zsh

echo "Starting Neovim setup..."

# Show theme options and get selection
echo "\nSelect your preferred theme:"
echo "1) Catppuccin (Modern pastel theme)"
echo "2) Tokyo Night (Dark and elegant)"
echo "3) Nord (Cold arctic theme)"
echo "4) Gruvbox (Retro warm theme)"
echo "5) One Dark (Atom-like theme)"
echo "6) Rose Pine (Soft aesthetic theme)"
echo "7) Dracula (Dark vampire theme)"
echo "8) VSCode Dark (Default VSCode dark theme)"

read "theme_choice?Enter theme number (1-8): "

# Convert choice to theme name
case $theme_choice in
    1) THEME="catppuccin";;
    2) THEME="tokyonight";;
    3) THEME="nord";;
    4) THEME="gruvbox";;
    5) THEME="onedark";;
    6) THEME="rose-pine";;
    7) THEME="dracula";;
    8) THEME="vscode";;
    *) THEME="catppuccin";;  # Default theme if invalid choice
esac

echo "Selected theme: $THEME\n"

# Check OS type
if [[ "$OSTYPE" == "darwin"* ]]; then
    # For macOS
    if ! command -v brew &> /dev/null; then
        echo "Homebrew not found. Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    echo "Installing Neovim and dependencies via Homebrew..."
    brew install neovim
    brew install --HEAD utf8proc
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # For Ubuntu/Debian
    echo "Installing Neovim via apt..."
    sudo apt update
    sudo apt install -y neovim
fi

# Create necessary directories
echo "Creating necessary directories..."
mkdir -p ~/.config/nvim
mkdir -p ~/.local/share/nvim/site/pack/packer/start

# Install Packer.nvim
echo "Installing packer.nvim..."
if [ ! -d "${HOME}/.local/share/nvim/site/pack/packer/start/packer.nvim" ]; then
    git clone --depth 1 https://github.com/wbthomason/packer.nvim \
        ~/.local/share/nvim/site/pack/packer/start/packer.nvim
fi

# Create initial minimal init.lua for plugin installation
echo "Creating temporary init.lua for plugin installation..."
cat > ~/.config/nvim/init.lua << 'EOL'
-- Basic settings
vim.opt.termguicolors = true

-- Package manager setup
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

local packer_bootstrap = ensure_packer()
local packer = require('packer')

-- Install plugins
packer.startup(function(use)
  use 'wbthomason/packer.nvim'
EOL

# Add theme-specific plugin to init.lua
case $THEME in
    "catppuccin")
        echo "  use { 'catppuccin/nvim', as = 'catppuccin' }" >> ~/.config/nvim/init.lua
        ;;
    "tokyonight")
        echo "  use { 'folke/tokyonight.nvim', branch = 'main' }" >> ~/.config/nvim/init.lua
        ;;
    "nord")
        echo "  use 'shaunsingh/nord.nvim'" >> ~/.config/nvim/init.lua
        ;;
    "gruvbox")
        echo "  use 'ellisonleao/gruvbox.nvim'" >> ~/.config/nvim/init.lua
        ;;
    "onedark")
        echo "  use 'navarasu/onedark.nvim'" >> ~/.config/nvim/init.lua
        ;;
    "rose-pine")
        echo "  use 'rose-pine/neovim'" >> ~/.config/nvim/init.lua
        ;;
    "dracula")
        echo "  use 'Mofiqul/dracula.nvim'" >> ~/.config/nvim/init.lua
        ;;
    "vscode")
        echo "  use 'tomasiser/vim-code-dark'" >> ~/.config/nvim/init.lua
        ;;
esac

# Add remaining plugins
cat >> ~/.config/nvim/init.lua << 'EOL'
  use {
    'nvim-tree/nvim-tree.lua',
    requires = {
      'nvim-tree/nvim-web-devicons',
    }
  }
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'nvim-tree/nvim-web-devicons' }
  }

  use {
    'neovim/nvim-lspconfig',
    'hrsh7th/nvim-cmp',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'L3MON4D3/LuaSnip',
  }
end)

if packer_bootstrap then
  packer.sync()
end
EOL

# Install plugins
echo "Installing plugins..."
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'

# Create final init.lua with full configuration
echo "Creating final init.lua..."
cat > ~/.config/nvim/init.lua << 'EOL'
-- Defer loading of plugins until after init
vim.defer_fn(function()
-- Basic settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = 'a'
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.wrap = true
vim.opt.breakindent = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.termguicolors = true

-- Initialize plugins
require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
EOL

# Add theme-specific plugin and configuration
case $THEME in
    "catppuccin")
        cat >> ~/.config/nvim/init.lua << 'EOL'
  use { 'catppuccin/nvim', as = 'catppuccin' }
EOL
        ;;
    "tokyonight")
        cat >> ~/.config/nvim/init.lua << 'EOL'
  use { 'folke/tokyonight.nvim', branch = 'main' }
EOL
        ;;
    "nord")
        cat >> ~/.config/nvim/init.lua << 'EOL'
  use 'shaunsingh/nord.nvim'
EOL
        ;;
    "gruvbox")
        cat >> ~/.config/nvim/init.lua << 'EOL'
  use 'ellisonleao/gruvbox.nvim'
EOL
        ;;
    "onedark")
        cat >> ~/.config/nvim/init.lua << 'EOL'
  use 'navarasu/onedark.nvim'
EOL
        ;;
    "rose-pine")
        cat >> ~/.config/nvim/init.lua << 'EOL'
  use 'rose-pine/neovim'
EOL
        ;;
    "dracula")
        cat >> ~/.config/nvim/init.lua << 'EOL'
  use 'Mofiqul/dracula.nvim'
EOL
        ;;
    "vscode")
        cat >> ~/.config/nvim/init.lua << 'EOL'
  use 'tomasiser/vim-code-dark'
EOL
        ;;
esac

# Add remaining configuration
cat >> ~/.config/nvim/init.lua << 'EOL'
  use {
    'nvim-tree/nvim-tree.lua',
    requires = {
      'nvim-tree/nvim-web-devicons',
    }
  }
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'nvim-tree/nvim-web-devicons' }
  }
  use {
    'neovim/nvim-lspconfig',
    'hrsh7th/nvim-cmp',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'L3MON4D3/LuaSnip',
  }
end)

-- Setup plugins with pcall to handle errors
local ok, _ = pcall(function()
EOL

# Add theme-specific setup
case $THEME in
    "catppuccin")
        cat >> ~/.config/nvim/init.lua << 'EOL'
  require("catppuccin").setup({
    flavour = "mocha",
    transparent_background = false,
  })
  vim.cmd.colorscheme "catppuccin"
EOL
        ;;
    "tokyonight")
        cat >> ~/.config/nvim/init.lua << 'EOL'
  require("tokyonight").setup({
    style = "storm",
  })
  vim.cmd.colorscheme "tokyonight"
EOL
        ;;
    "nord")
        cat >> ~/.config/nvim/init.lua << 'EOL'
  vim.cmd.colorscheme "nord"
EOL
        ;;
    "gruvbox")
        cat >> ~/.config/nvim/init.lua << 'EOL'
  require("gruvbox").setup({
    terminal_colors = true,
    contrast = "hard",
  })
  vim.cmd.colorscheme "gruvbox"
EOL
        ;;
    "onedark")
        cat >> ~/.config/nvim/init.lua << 'EOL'
  require("onedark").setup({
    style = "darker"
  })
  vim.cmd.colorscheme "onedark"
EOL
        ;;
    "rose-pine")
        cat >> ~/.config/nvim/init.lua << 'EOL'
  require("rose-pine").setup()
  vim.cmd.colorscheme "rose-pine"
EOL
        ;;
    "dracula")
        cat >> ~/.config/nvim/init.lua << 'EOL'
  vim.cmd.colorscheme "dracula"
EOL
        ;;
    "vscode")
        cat >> ~/.config/nvim/init.lua << 'EOL'
  vim.cmd.colorscheme "codedark"
EOL
        ;;
esac

# Add remaining configuration
cat >> ~/.config/nvim/init.lua << 'EOL'
  -- NvimTree setup
  require('nvim-tree').setup({
    sort_by = "case_sensitive",
    view = {
      width = 30,
    },
    renderer = {
      group_empty = true,
    },
    filters = {
      dotfiles = false,
    },
  })

  -- Status line setup
EOL

# Add theme-specific lualine configuration
case $THEME in
    "vscode")
        echo "  require('lualine').setup { options = { theme = 'codedark' } }" >> ~/.config/nvim/init.lua
        ;;
    *)
        echo "  require('lualine').setup { options = { theme = '$THEME' } }" >> ~/.config/nvim/init.lua
        ;;
esac

# Add final configuration
cat >> ~/.config/nvim/init.lua << 'EOL'
end)

if not ok then
  print('Error loading plugins. Run :PackerSync and restart nvim')
end

-- Key mappings
vim.g.mapleader = " "
vim.keymap.set('n', '<Leader>e', ':NvimTreeToggle<CR>')
vim.keymap.set('n', '<Leader>w', ':w<CR>')
vim.keymap.set('n', 'gd', vim.lsp.buf.definition)
vim.keymap.set('n', 'K', vim.lsp.buf.hover)
vim.keymap.set('n', '<Leader>rn', vim.lsp.buf.rename)
end, 0)
EOL

echo "\nNeovim setup completed!"
echo "Important: Plugins need to be installed before using Neovim."
echo "Follow these steps:"
echo "1. Start neovim by typing 'nvim'"
echo "2. Wait for any error messages to appear"
echo "3. Run :PackerSync"
echo "4. After installation completes, quit nvim"
echo "5. Start nvim again, and everything should work properly"
echo "\nNote: It's normal to see some errors on the first launch."
