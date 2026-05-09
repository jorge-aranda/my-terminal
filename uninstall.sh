#!/usr/bin/env bash
set -euo pipefail

# ============================================================================
# My Terminal - Uninstaller
# ============================================================================
# Usage:
#   ./uninstall.sh              Interactive uninstallation
#   ./uninstall.sh --all        Remove everything including dependencies (Mac)
# ============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$SCRIPT_DIR"
TARGET_DIR="$HOME"
ZSH_CUSTOM_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

REMOVE_DEPS=false

for arg in "$@"; do
  case "$arg" in
    --all) REMOVE_DEPS=true ;;
    *) echo "Unknown argument: $arg"; exit 1 ;;
  esac
done

# ============================================================================
# i18n
# ============================================================================
detect_language() {
  local lang="${LANG:-${LC_ALL:-${LC_MESSAGES:-en}}}"
  if [[ "$lang" == es* ]]; then
    echo "es"
  else
    echo "en"
  fi
}

LANG_CODE="$(detect_language)"

msg() {
  local key="$1"
  shift
  local en="$1"
  local es="${2:-$en}"
  if [[ "$LANG_CODE" == "es" ]]; then
    printf "$es\n" "$@" 2>/dev/null || echo "$es"
  else
    printf "$en\n" "$@" 2>/dev/null || echo "$en"
  fi
}

# ============================================================================
# Helpers
# ============================================================================
COLOR_GREEN='\033[0;32m'
COLOR_YELLOW='\033[1;33m'
COLOR_RED='\033[0;31m'
COLOR_BLUE='\033[0;34m'
COLOR_RESET='\033[0m'

info()    { echo -e "${COLOR_BLUE}[INFO]${COLOR_RESET} $1"; }
success() { echo -e "${COLOR_GREEN}[OK]${COLOR_RESET} $1"; }
warn()    { echo -e "${COLOR_YELLOW}[WARN]${COLOR_RESET} $1"; }
error()   { echo -e "${COLOR_RED}[ERROR]${COLOR_RESET} $1"; }

ask_yes_no() {
  local prompt="$1"
  local default="${2:-n}"
  local yn
  if [[ "$default" == "y" ]]; then
    read -r -p "$prompt [Y/n]: " yn
    yn="${yn:-y}"
  else
    read -r -p "$prompt [y/N]: " yn
    yn="${yn:-n}"
  fi
  [[ "$yn" =~ ^[Yy] ]]
}

is_mac() { [[ "$(uname -s)" == "Darwin" ]]; }
command_exists() { command -v "$1" &>/dev/null; }

is_symlink_to() {
  local link="$1"
  local target="$2"
  [[ -L "$link" ]] && [[ "$(readlink "$link")" == "$target" ]]
}

step_counter=0
step() {
  step_counter=$((step_counter + 1))
  echo ""
  echo -e "${COLOR_RED}━━━ Step $step_counter: $1 ━━━${COLOR_RESET}"
}

# ============================================================================
# Remove symlink and restore backup
# ============================================================================
remove_symlink() {
  local source="$1"
  local target="$2"
  local description="$3"

  if is_symlink_to "$target" "$source"; then
    rm "$target"
    success "$(msg "symlink_removed" \
      "$description: symlink removed." \
      "$description: enlace simbólico eliminado.")"
    if [[ -f "${target}.bak" ]]; then
      mv "${target}.bak" "$target"
      info "$(msg "backup_restored" \
        "$description: backup restored." \
        "$description: backup restaurado.")"
    fi
  else
    info "$(msg "symlink_not_found" \
      "$description: symlink not found (skipped)." \
      "$description: enlace simbólico no encontrado (omitido).")"
  fi
}

# ============================================================================
# Remove plugin
# ============================================================================
remove_plugin() {
  local dest="$1"
  local name="$2"

  if [[ -d "$dest" ]]; then
    rm -rf "$dest"
    success "$(msg "plugin_removed" \
      "Plugin $name removed." \
      "Plugin $name eliminado.")"
  else
    info "$(msg "plugin_not_found" \
      "Plugin $name not found (skipped)." \
      "Plugin $name no encontrado (omitido).")"
  fi
}

# ============================================================================
# Main
# ============================================================================
main() {
  echo ""
  echo "============================================================"
  msg "welcome" \
    "  My Terminal - Uninstaller" \
    "  My Terminal - Desinstalador"
  echo "============================================================"
  echo ""

  warn "$(msg "warning" \
    "This will remove My Terminal configuration from your system." \
    "Esto eliminará la configuración de My Terminal de tu sistema.")"
  echo ""

  if ! ask_yes_no "$(msg "confirm" \
    "Do you want to proceed?" \
    "¿Deseas continuar?")"; then
    msg "cancelled" "Uninstallation cancelled." "Desinstalación cancelada."
    exit 0
  fi

  # --- Step: Remove SSH config entries ---
  step "$(msg "step_ssh" "Remove SSH Nerd Font configuration" "Eliminar configuración SSH de Nerd Font")"

  local ssh_config="$HOME/.ssh/config"
  if [[ -f "$ssh_config" ]] && grep -q "SendEnv ON_SSH_SESSION_USE_NERD_FONT" "$ssh_config"; then
    if ask_yes_no "$(msg "ssh_client_remove" \
      "Remove SendEnv ON_SSH_SESSION_USE_NERD_FONT from ~/.ssh/config?" \
      "¿Eliminar SendEnv ON_SSH_SESSION_USE_NERD_FONT de ~/.ssh/config?")" "y"; then
      sed -i.bak '/SendEnv ON_SSH_SESSION_USE_NERD_FONT/d' "$ssh_config"
      rm -f "${ssh_config}.bak"
      success "$(msg "ssh_client_removed" "Removed from ~/.ssh/config." "Eliminado de ~/.ssh/config.")"
    fi
  else
    info "$(msg "ssh_client_clean" "No SSH client Nerd Font config found." "No se encontró configuración SSH de Nerd Font.")"
  fi

  # --- Step: Remove Neovim symlink ---
  step "$(msg "step_nvim" "Remove Neovim symlink" "Eliminar enlace simbólico de Neovim")"
  remove_symlink "$REPO_DIR/.config/nvim/init.lua" "$TARGET_DIR/.config/nvim/init.lua" "init.lua"

  # --- Step: Remove Powerlevel10k symlinks ---
  step "$(msg "step_p10k_links" "Remove Powerlevel10k symlinks" "Eliminar enlaces simbólicos de Powerlevel10k")"
  remove_symlink "$REPO_DIR/.p10k.zsh" "$TARGET_DIR/.p10k.zsh" ".p10k.zsh"
  remove_symlink "$REPO_DIR/.p10k.compatible-mode.zsh" "$TARGET_DIR/.p10k.compatible-mode.zsh" ".p10k.compatible-mode.zsh"
  remove_symlink "$REPO_DIR/.p10k.enable-compatible-mode-emojis.zsh" "$TARGET_DIR/.p10k.enable-compatible-mode-emojis.zsh" ".p10k.enable-compatible-mode-emojis.zsh"
  remove_symlink "$REPO_DIR/.p10k.my-terminal-extensions.zsh" "$TARGET_DIR/.p10k.my-terminal-extensions.zsh" ".p10k.my-terminal-extensions.zsh"

  # --- Step: Remove Powerlevel10k theme ---
  step "$(msg "step_p10k_theme" "Remove Powerlevel10k theme" "Eliminar tema Powerlevel10k")"
  if [[ -d "$ZSH_CUSTOM_DIR/themes/powerlevel10k" ]]; then
    if ask_yes_no "$(msg "p10k_remove" \
      "Remove Powerlevel10k theme from Oh My Zsh?" \
      "¿Eliminar tema Powerlevel10k de Oh My Zsh?")" "y"; then
      rm -rf "$ZSH_CUSTOM_DIR/themes/powerlevel10k"
      success "$(msg "p10k_removed" "Powerlevel10k removed." "Powerlevel10k eliminado.")"
    fi
  else
    info "$(msg "p10k_not_found" "Powerlevel10k not found (skipped)." "Powerlevel10k no encontrado (omitido).")"
  fi

  # --- Step: Remove Oh My Zsh plugins ---
  step "$(msg "step_plugins" "Remove Oh My Zsh plugins" "Eliminar plugins de Oh My Zsh")"
  if ask_yes_no "$(msg "plugins_remove" \
    "Remove installed Oh My Zsh plugins (zsh-autosuggestions, zsh-syntax-highlighting, you-should-use, zsh-bat)?" \
    "¿Eliminar plugins instalados de Oh My Zsh (zsh-autosuggestions, zsh-syntax-highlighting, you-should-use, zsh-bat)?")" "y"; then
    remove_plugin "$ZSH_CUSTOM_DIR/plugins/zsh-autosuggestions" "zsh-autosuggestions"
    remove_plugin "$ZSH_CUSTOM_DIR/plugins/zsh-syntax-highlighting" "zsh-syntax-highlighting"
    remove_plugin "$ZSH_CUSTOM_DIR/plugins/you-should-use" "you-should-use"
    remove_plugin "$ZSH_CUSTOM_DIR/plugins/zsh-bat" "zsh-bat"
  fi

  # --- Step: Remove .zshrc symlink ---
  step "$(msg "step_zshrc" "Remove .zshrc symlink" "Eliminar enlace simbólico .zshrc")"
  remove_symlink "$REPO_DIR/.zshrc" "$TARGET_DIR/.zshrc" ".zshrc"

  # --- Step: Uninstall dependencies (Mac only) ---
  if is_mac && command_exists brew; then
    step "$(msg "step_deps" "Uninstall dependencies (optional)" "Desinstalar dependencias (opcional)")"

    if [[ "$REMOVE_DEPS" == true ]] || ask_yes_no "$(msg "deps_remove" \
      "Would you like to uninstall dependencies installed by the installer?" \
      "¿Deseas desinstalar las dependencias instaladas por el instalador?")" "n"; then

      if brew list --cask font-fira-code-nerd-font &>/dev/null 2>&1; then
        if ask_yes_no "$(msg "fira_remove" "Uninstall Fira Code Nerd Font?" "¿Desinstalar Fira Code Nerd Font?")" "n"; then
          brew uninstall --cask font-fira-code-nerd-font
          success "Fira Code Nerd Font uninstalled."
        fi
      fi

      if brew list --cask font-jetbrains-mono-nerd-font &>/dev/null 2>&1; then
        if ask_yes_no "$(msg "jetbrains_remove" "Uninstall JetBrains Mono Nerd Font?" "¿Desinstalar JetBrains Mono Nerd Font?")" "n"; then
          brew uninstall --cask font-jetbrains-mono-nerd-font
          success "JetBrains Mono Nerd Font uninstalled."
        fi
      fi

      if command_exists nvim; then
        if ask_yes_no "$(msg "nvim_remove" "Uninstall Neovim?" "¿Desinstalar Neovim?")" "n"; then
          brew uninstall neovim
          success "Neovim uninstalled."
        fi
      fi
    fi
  fi

  # --- Done ---
  echo ""
  echo "============================================================"
  success "$(msg "done" \
    "Uninstallation complete! You may want to restart your terminal." \
    "¡Desinstalación completada! Puede que quieras reiniciar tu terminal.")"
  echo "============================================================"
}

main
