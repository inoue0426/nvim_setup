# Neovim Setup Script

This script automates the installation and basic configuration of Neovim on your system. It sets up essential plugins and configures aliases for `vim` and `vi` to point to Neovim.

## Features

- Installs Neovim using Homebrew (macOS).
- Creates a configuration directory for Neovim.
- Sets up an `init.lua` file with:
  - Line numbering enabled.
  - Basic editor settings.
  - Key mappings for Telescope.
  - LSP (Language Server Protocol) configuration.
  - Treesitter for enhanced syntax highlighting.
- Configures `vim` and `vi` commands to launch Neovim.

## Prerequisites

- **Homebrew**: This script requires Homebrew to be installed on your macOS system. If Homebrew is not installed, the script will install it for you.

## Usage

1. Clone this repository or download the script:

   ```bash
   git clone <repository-url>
   cd <repository-directory>
   ```

2. Make the script executable:

   ```bash
   chmod +x setup_neovim.sh
   ```

3. Run the script:

   ```bash
   ./setup_neovim.sh
   ```

4. After running the script, open a new terminal session or run source ~/.bashrc or source ~/.zshrc to activate the aliases.

### Customization

You can customize the init.lua file according to your preferences by editing it directly in ~/.config/nvim/init.lua. Feel free to add or remove plugins as needed.

### Troubleshooting

If you encounter any issues, ensure that you have the necessary permissions and that your shell configuration files are correctly set up.
The script currently supports Bash and Zsh. If you use a different shell, you may need to manually set up the aliases.
