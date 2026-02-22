# Q pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zshrc.pre.zsh"
# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Theme
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
# plugins=(git osx kops kubectl terraform vault)
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  macos
  colored-man-pages
  extract
  web-search
  you-should-use
  zsh-bat
  aws
  terraform
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
alias zshconfig="vim ~/.zshrc"
alias ohmyzsh="vim ~/.oh-my-zsh"

# Visual Studio Code
alias vsc='code'

alias refresh='source ~/.zshrc'
alias sr='screen -r'
alias sls='screen -ls'
alias vimzsh='vim ~/.zshrc'
alias lzd='lazydocker'

# Use of neovim
alias vim='nvim'
alias vi='nvim'

# Useful Aliases
alias c="clear"
alias ll="ls -lah"

# Git aliases
alias gs="git status"
alias ga="git add"
alias gc="git commit"
alias gp="git push"
alias gl="git log --oneline --graph --decorate"

# Python 3
alias python=python3

# Bigger history
export HISTSIZE=10000
export SAVEHIST=10000

# Path 
export PATH=/opt/homebrew/bin:$PATH
export PATH="$HOME/Library/Application Support/pear/bin:$PATH"
export CPPFLAGS="-I/opt/homebrew/opt/libpq/include"

# Default editor
export EDITOR=nvim
export VISUAL=nvim

# Change terminal architecture
alias amd64='exec arch -x86_64 zsh'
alias arm64='exec arch -arm64e zsh'

# Brew compatible with both architectures
if [ "$(arch)" = "arm64" ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    eval "$(/usr/local/bin/brew shellenv)"
fi

# nvm script
export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# zfunctions
fpath=($fpath "$HOME/.zfunctions")

# Enable the-fuck
eval $(thefuck --alias)

# All colors
function all_colors() {
    for i in {0..255}; do
      print -P "%F{$i}Color $i: Hello World%f"
    done
}

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"


[[ -f "$HOME/fig-export/dotfiles/dotfile.zsh" ]] && builtin source "$HOME/fig-export/dotfiles/dotfile.zsh"

# Q post block. Keep at the bottom of this file.
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zshrc.post.zsh"

# Added by LM Studio CLI (lms)
export PATH="$PATH:$HOME/.cache/lm-studio/bin"

# PyEnv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - --no-rehash)"

# Detects whether the current session is running
# inside a graphical terminal or a text console.
# Returns:
#   0 -> graphical terminal
#   1 -> text mode
function is_graphical_terminal() {
#   # If connected via SSH, treat it as non-graphical
#   if [[ -n "$SSH_CONNECTION" ]]; then
#     return 1  # false
#   fi

  # On Linux systems:
  # If DISPLAY or WAYLAND_DISPLAY is set,
  # we are inside a graphical session
  if [[ -n "$DISPLAY" || -n "$WAYLAND_DISPLAY" ]]; then
    return 0  # true
  fi

  # Get the current TTY device
  local tty_device
  tty_device=$(tty 2>/dev/null)

  case "$tty_device" in
    # On Linux: Pseudo-terminals (pts) indicate graphical terminal emulators
    # On macOS: /dev/ttysXXX indicates a terminal app inside the GUI
    /dev/pts/*|/dev/ttys*)
      return 0  # true
      ;;
    # Real TTYs (tty1, tty2, etc.) indicate text mode
    /dev/tty[0-9]*)
      return 1  # false
      ;;
    *)
      return 1 # fallback: false
      ;;
  esac
}

# Check if Nerd Font is available
function check_nerd_font() {
  local has_nerd_font=false

  # Check various terminal emulators
  if [[ "$TERM_PROGRAM" == "iTerm.app" ]]; then
    # iTerm2
    local font_name=$(defaults read com.googlecode.iterm2 2>/dev/null | grep -i "nerd\|meslo\|fira.*code")
    [[ -n "$font_name" ]] && has_nerd_font=true
  elif [[ "$TERM_PROGRAM" == "WarpTerminal" ]] || [[ -n "$WARP_IS_LOCAL_SHELL_SESSION" ]]; then
    # Warp - usually has Nerd Font support
    has_nerd_font=true
  elif [[ -n "$INTELLIJ_ENVIRONMENT_READER" ]] || [[ "$TERMINAL_EMULATOR" == "JetBrains-JediTerm" ]]; then
    # IntelliJ/JetBrains terminal
    # Check if JetBrains Mono is Nerd Font patched
    has_nerd_font=true
  elif [[ "$TERM" == *"kitty"* ]]; then
    # Kitty terminal
    has_nerd_font=true
  elif [[ "$TERM_PROGRAM" == "vscode" ]] || [[ -n "$VSCODE_INJECTION" ]]; then
    # VS Code integrated terminal
    has_nerd_font=true
  elif [[ "$TERM_PROGRAM" == "Hyper" ]]; then
    # Hyper terminal
    has_nerd_font=true
  elif  [[ "$TERM_PROGRAM" == "Apple_Terminal" ]]; then
    # Apple terminal
    has_nerd_font=false
  fi

  # Manual override via environment variable
  [[ "$USE_NERD_FONT" == "true" ]] && has_nerd_font=true
  [[ "$USE_NERD_FONT" == "false" ]] && has_nerd_font=false

  echo "$has_nerd_font"
}

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Load compatibility mode if Nerd Font is not available
if [[ "$(check_nerd_font)" == "false" ]]; then
  [[ ! -f ~/.p10k.compatible-mode.zsh ]] || source ~/.p10k.compatible-mode.zsh

  # Load emojis if the system is compatible
  if is_graphical_terminal; then
    [[ ! -f ~/.p10k.enable-compatible-mode-emojis.zsh ]] || source ~/.p10k.enable-compatible-mode-emojis.zsh
  fi
fi