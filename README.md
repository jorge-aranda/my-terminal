# My Terminal Configurations

This repository contains my personal terminal configuration files, including settings for Zsh and Neovim.

## Requirements

Before setting up these configurations, ensure you have the following installed:

*   **Neovim**: A hyper-extensible Vim-based text editor.
*   **Oh My Zsh**: An open-source, community-driven framework for managing your Zsh configuration.
*   **Powerlevel10k**: A theme for Zsh that emphasizes speed, flexibility, and out-of-the-box experience.
*   **Fira Code Nerd Font**: A Nerd Font that includes icons and symbols needed for the prompt.
*   **pyenv**: A Python version management tool.

## Installation

To use these configurations, you need to create symbolic links from this repository to your home directory or the appropriate configuration folders.

### 1. Clone the repository

```bash
git clone https://github.com/jorge-aranda/my-terminal.git ~/repos/jorge-aranda/my-terminal
cd ~/repos/jorge-aranda/my-terminal
```

### 2. Create Symbolic Links

Run the following commands to link the configuration files:

#### Zsh Configuration (`.zshrc`)

First, install **pyenv**:

```bash
brew install pyenv
```

Then, link the configuration file:

```bash
# Backup existing .zshrc if it exists
mv ~/.zshrc ~/.zshrc.bak

# Create symbolic link
ln -s ~/repos/jorge-aranda/my-terminal/.zshrc ~/.zshrc
```

#### Oh My Zsh Configuration

Install required plugins:
```bash
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions \
  "$ZSH_CUSTOM/plugins/zsh-autosuggestions"

git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting \
  "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"

git clone --depth=1 https://github.com/MichaelAquilina/zsh-you-should-use \
  "$ZSH_CUSTOM/plugins/you-should-use"

git clone --depth=1 https://github.com/fdellwing/zsh-bat \
  "$ZSH_CUSTOM/plugins/zsh-bat"
```

#### Other dependencies
To avoid issues it is required tu install `thefuck` and `pyenv` but if you don't want to install 
them you can comment the lines in the `.zshrc` file.

#### Powerlevel10k Configuration (`.p10k.zsh`)

First, install the **Fira Code Nerd Font**:

```bash
brew install --cask font-fira-code-nerd-font
```

After installing the font, configure your terminal emulator to use `FiraCode Nerd Font`.

First, install the Powerlevel10k theme:

```bash
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
```

Then, link the configuration file:

```bash
# Backup existing .p10k.zsh if it exists
mv ~/.p10k.zsh ~/.p10k.zsh.bak

# Create symbolic link
ln -s ~/repos/jorge-aranda/my-terminal/.p10k.zsh ~/.p10k.zsh

# Create symbolic link for compatibility mode (optional but recommended)
ln -s ~/repos/jorge-aranda/my-terminal/.p10k.compatible-mode.zsh ~/.p10k.compatible-mode.zsh

# Create symbolic link for emoji-based compatibility mode (optional)
ln -s ~/repos/jorge-aranda/my-terminal/.p10k.enable-compatible-mode-emojis.zsh ~/.p10k.enable-compatible-mode-emojis.zsh
```

#### Neovim Configuration (`init.lua`)

```bash
# Create nvim configuration directory if it doesn't exist
mkdir -p ~/.config/nvim

# Backup existing init.lua if it exists
mv ~/.config/nvim/init.lua ~/.config/nvim/init.lua.bak

# Create symbolic link
ln -s ~/repos/jorge-aranda/my-terminal/.config/nvim/init.lua ~/.config/nvim/init.lua
```

## Usage

After creating the symbolic links, restart your terminal or source the configuration:

```bash
source ~/.zshrc
```

For Neovim, simply run `nvim` and it will use the new `init.lua`.

### Powerlevel10k Usage

To customize the prompt, you can run:

```bash
p10k configure
```

Or manually edit the linked `~/.p10k.zsh` file.

### Compatibility without Nerd Fonts

If you prefer not to install a Nerd Font or your terminal doesn't support it, the prompt will automatically detect whether to show icons or fall back to a compatibility mode using emojis or plain text.

You can manually force this behavior using the `USE_NERD_FONT` environment variable in your `.zshrc`:

```zsh
# To disable Nerd Fonts and use compatibility mode
export USE_NERD_FONT="false"

# To force Nerd Fonts even if they are not detected
export USE_NERD_FONT="true"
```
