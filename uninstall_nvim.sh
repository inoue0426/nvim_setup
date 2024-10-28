#!/bin/zsh

# Uninstall Neovim and remove all related configurations and plugins

# Check if Homebrew is installed
if command -v brew &> /dev/null; then
    echo "Uninstalling Neovim..."
    brew uninstall neovim
else
    echo "Homebrew is not installed. Skipping Neovim uninstallation."
fi

# Remove Neovim configuration directory
echo "Removing Neovim configuration directory..."
rm -rf ~/.config/nvim

# Remove Neovim data directory (where plugins are stored)
echo "Removing Neovim data directory..."
rm -rf ~/.local/share/nvim

# Remove Neovim cache directory
echo "Removing Neovim cache directory..."
rm -rf ~/.local/state/nvim

# Remove Neovim swap files (if any)
echo "Removing Neovim swap files..."
rm -rf ~/.local/share/nvim/swap

# Remove any other related directories (if applicable)
echo "Cleaning up any other related directories..."
rm -rf ~/.local/share/nvim/plugged  # For vim-plug users
rm -rf ~/.local/share/lazy  # For lazy.nvim users
rm -rf ~/.local/share/nvim/site  # General site files

echo "All Neovim-related files have been removed."
