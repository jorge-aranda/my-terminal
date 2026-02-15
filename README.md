# My Terminal Configurations

This repository contains my personal terminal configuration files, including settings for Zsh and Neovim.

## Requirements

Before setting up these configurations, ensure you have the following installed:

*   **Neovim**: A hyper-extensible Vim-based text editor.
*   **Oh My Zsh**: An open-source, community-driven framework for managing your Zsh configuration.

## Installation

To use these configurations, you need to create symbolic links from this repository to your home directory or the appropriate configuration folders.

### 1. Clone the repository

```bash
git clone https://github.com/jorge-aranda/my-terminal.git ~/repos/jorge.aranda/my-terminal
cd ~/repos/jorge.aranda/my-terminal
```

### 2. Create Symbolic Links

Run the following commands to link the configuration files:

#### Zsh Configuration (`.zshrc`)

```bash
# Backup existing .zshrc if it exists
mv ~/.zshrc ~/.zshrc.bak

# Create symbolic link
ln -s ~/repos/jorge.aranda/my-terminal/.zshrc ~/.zshrc
```

#### Neovim Configuration (`init.lua`)

```bash
# Create nvim configuration directory if it doesn't exist
mkdir -p ~/.config/nvim

# Backup existing init.lua if it exists
mv ~/.config/nvim/init.lua ~/.config/nvim/init.lua.bak

# Create symbolic link
ln -s ~/repos/jorge.aranda/my-terminal/.config/nvim/init.lua ~/.config/nvim/init.lua
```

## Usage

After creating the symbolic links, restart your terminal or source the configuration:

```bash
source ~/.zshrc
```

For Neovim, simply run `nvim` and it will use the new `init.lua`.
