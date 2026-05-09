#!/usr/bin/env bash
set -euo pipefail

# ============================================================================
# My Terminal - Installer
# ============================================================================
# Usage:
#   ./install.sh                        Interactive installation
#   ./install.sh --unattended           Unattended installation (no optional deps)
#   ./install.sh --unattended --deps    Unattended installation + mandatory deps
# ============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$SCRIPT_DIR"
TARGET_DIR="$HOME"
ZSH_CUSTOM_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

UNATTENDED=false
INSTALL_DEPS=false

for arg in "$@"; do
  case "$arg" in
    --unattended) UNATTENDED=true ;;
    --deps) INSTALL_DEPS=true ;;
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
  local default="${2:-y}"
  if [[ "$UNATTENDED" == true ]]; then
    [[ "$default" == "y" ]] && return 0 || return 1
  fi
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
  echo -e "${COLOR_GREEN}━━━ Step $step_counter: $1 ━━━${COLOR_RESET}"
}

# ============================================================================
# Prerequisite checks
# ============================================================================
check_mandatory_prerequisites() {
  local missing=()

  if ! command_exists zsh; then
    missing+=("zsh")
  fi

  if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    missing+=("oh-my-zsh")
  fi

  if ! command_exists git; then
    missing+=("git")
  fi

  echo "${missing[@]}"
}

install_prerequisite_mac() {
  local pkg="$1"
  case "$pkg" in
    zsh)
      info "Installing zsh via Homebrew..."
      brew install zsh
      ;;
    oh-my-zsh)
      info "Installing Oh My Zsh..."
      sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
      ;;
    git)
      info "Installing git via Homebrew..."
      brew install git
      ;;
  esac
}

install_prerequisites() {
  local missing
  missing=($(check_mandatory_prerequisites))

  if [[ ${#missing[@]} -eq 0 ]]; then
    msg "prereqs_ok" \
      "All mandatory prerequisites are already installed." \
      "Todos los pre-requisitos obligatorios ya están instalados."
    return 0
  fi

  msg "prereqs_missing" \
    "The following mandatory prerequisites are missing: ${missing[*]}" \
    "Los siguientes pre-requisitos obligatorios faltan: ${missing[*]}"

  if [[ "$UNATTENDED" == true ]]; then
    if [[ "$INSTALL_DEPS" == true ]] && is_mac; then
      for pkg in "${missing[@]}"; do
        install_prerequisite_mac "$pkg"
      done
    else
      error "$(msg "prereqs_fail" \
        "Mandatory prerequisites are missing and cannot be installed in unattended mode without --deps." \
        "Faltan pre-requisitos obligatorios y no se pueden instalar en modo desatendido sin --deps.")"
      exit 1
    fi
  else
    if is_mac; then
      if command_exists brew; then
        for pkg in "${missing[@]}"; do
          if ask_yes_no "$(msg "install_pkg" \
            "Install $pkg using the installer?" \
            "¿Instalar $pkg usando el instalador?")"; then
            install_prerequisite_mac "$pkg"
          else
            error "$(msg "pkg_required" \
              "$pkg is required. Please install it manually and re-run the installer." \
              "$pkg es obligatorio. Por favor instálalo manualmente y vuelve a ejecutar el instalador.")"
            exit 1
          fi
        done
      else
        error "$(msg "no_brew" \
          "Homebrew is not installed. Please install the missing prerequisites manually: ${missing[*]}" \
          "Homebrew no está instalado. Por favor instala los pre-requisitos manualmente: ${missing[*]}")"
        exit 1
      fi
    else
      error "$(msg "manual_install" \
        "Please install the following prerequisites manually and re-run the installer: ${missing[*]}" \
        "Por favor instala los siguientes pre-requisitos manualmente y vuelve a ejecutar el instalador: ${missing[*]}")"
      exit 1
    fi
  fi

  # Re-check
  missing=($(check_mandatory_prerequisites))
  if [[ ${#missing[@]} -gt 0 ]]; then
    error "$(msg "still_missing" \
      "Prerequisites still missing after installation: ${missing[*]}" \
      "Pre-requisitos aún faltan después de la instalación: ${missing[*]}")"
    exit 1
  fi
}

# ============================================================================
# Neovim (optional)
# ============================================================================
ask_neovim() {
  if command_exists nvim; then
    return 0
  fi
  if [[ "$UNATTENDED" == true ]]; then
    return 0  # unattended: skip neovim install but still configure symlinks
  fi
  echo ""
  msg "nvim_optional" \
    "Neovim is not installed. It is optional but recommended for this project." \
    "Neovim no está instalado. Es opcional pero recomendado para este proyecto."
  if is_mac && command_exists brew; then
    if ask_yes_no "$(msg "install_nvim" \
      "Would you like to install Neovim?" \
      "¿Deseas instalar Neovim?")" "n"; then
      brew install neovim
    fi
  else
    msg "nvim_manual" \
      "You can install Neovim manually if desired." \
      "Puedes instalar Neovim manualmente si lo deseas."
  fi
}

configure_neovim_symlink() {
  if [[ "$UNATTENDED" == true ]]; then
    # Unattended: always configure neovim symlinks
    return 0
  fi
  if ! command_exists nvim; then
    if ask_yes_no "$(msg "nvim_symlink" \
      "Neovim is not installed. Do you still want to configure its symlink (for future use)?" \
      "Neovim no está instalado. ¿Deseas configurar su enlace simbólico (para uso futuro)?")" "y"; then
      return 0
    else
      return 1
    fi
  fi
  return 0
}

# ============================================================================
# Fonts (Mac only)
# ============================================================================
install_fonts() {
  if [[ "$UNATTENDED" == true ]]; then
    msg "fonts_skip_unattended" \
      "Skipping font installation in unattended mode. Configure USE_NERD_FONT=\"false\" if needed." \
      "Omitiendo instalación de fuentes en modo desatendido. Configura USE_NERD_FONT=\"false\" si es necesario."
    return 0
  fi

  if ! is_mac || ! command_exists brew; then
    return 0
  fi

  echo ""
  msg "fonts_header" \
    "=== Nerd Font Installation ===" \
    "=== Instalación de Nerd Fonts ==="

  local fira_installed=false
  local jetbrains_installed=false

  if brew list --cask font-fira-code-nerd-font &>/dev/null 2>&1; then
    fira_installed=true
  fi
  if brew list --cask font-jetbrains-mono-nerd-font &>/dev/null 2>&1; then
    jetbrains_installed=true
  fi

  if [[ "$fira_installed" == true ]] && [[ "$jetbrains_installed" == true ]]; then
    success "$(msg "fonts_both_installed" \
      "Both Fira Code Nerd Font and JetBrains Mono Nerd Font are already installed." \
      "Tanto Fira Code Nerd Font como JetBrains Mono Nerd Font ya están instaladas.")"
  else
    if [[ "$fira_installed" == false ]]; then
      if ask_yes_no "$(msg "install_fira" \
        "Install Fira Code Nerd Font?" \
        "¿Instalar Fira Code Nerd Font?")" "y"; then
        brew install --cask font-fira-code-nerd-font
        fira_installed=true
      fi
    else
      success "$(msg "fira_ok" "Fira Code Nerd Font is already installed." "Fira Code Nerd Font ya está instalada.")"
    fi

    if ask_yes_no "$(msg "install_jetbrains" \
      "Install JetBrains Mono Nerd Font (recommended for IntelliJ IDEs)?" \
      "¿Instalar JetBrains Mono Nerd Font (recomendada para IDEs de IntelliJ)?")" "y"; then
      if [[ "$jetbrains_installed" == false ]]; then
        brew install --cask font-jetbrains-mono-nerd-font
      else
        success "$(msg "jetbrains_ok" "JetBrains Mono Nerd Font is already installed." "JetBrains Mono Nerd Font ya está instalada.")"
      fi
    fi
  fi

  echo ""
  warn "$(msg "font_disclaimer" \
    "IMPORTANT: After installing fonts, you must configure your terminal emulator to use 'FiraCode Nerd Font' or 'JetBrains Mono Nerd Font'. If you don't use a Nerd Font, set USE_NERD_FONT=\"false\" in your environment." \
    "IMPORTANTE: Después de instalar las fuentes, debes configurar tu emulador de terminal para usar 'FiraCode Nerd Font' o 'JetBrains Mono Nerd Font'. Si no usas una Nerd Font, configura USE_NERD_FONT=\"false\" en tu entorno.")"
}

# ============================================================================
# Symlink helper
# ============================================================================
create_symlink() {
  local source="$1"
  local target="$2"
  local description="$3"

  if is_symlink_to "$target" "$source"; then
    success "$(msg "symlink_exists" \
      "$description: symlink already exists." \
      "$description: enlace simbólico ya existe.")"
    return 0
  fi

  if [[ -f "$target" ]] && [[ ! -L "$target" ]]; then
    info "$(msg "backup" \
      "Backing up $target to ${target}.bak" \
      "Haciendo backup de $target a ${target}.bak")"
    mv "$target" "${target}.bak"
  fi

  local target_dir
  target_dir="$(dirname "$target")"
  mkdir -p "$target_dir"

  ln -sf "$source" "$target"
  success "$(msg "symlink_created" \
    "$description: symlink created." \
    "$description: enlace simbólico creado.")"
}

# ============================================================================
# Clone Oh My Zsh plugin
# ============================================================================
clone_plugin() {
  local repo_url="$1"
  local dest="$2"
  local name="$3"

  if [[ -d "$dest" ]]; then
    success "$(msg "plugin_exists" \
      "Plugin $name is already installed." \
      "Plugin $name ya está instalado.")"
    return 0
  fi

  info "$(msg "plugin_install" \
    "Installing plugin $name..." \
    "Instalando plugin $name...")"
  git clone --depth=1 "$repo_url" "$dest"
  success "$(msg "plugin_done" \
    "Plugin $name installed." \
    "Plugin $name instalado.")"
}

# ============================================================================
# SSH Nerd Font config
# ============================================================================
configure_ssh_client() {
  if [[ "$UNATTENDED" == true ]]; then
    msg "ssh_skip" \
      "Skipping SSH Nerd Font client configuration in unattended mode. See README.md for manual setup." \
      "Omitiendo configuración SSH de Nerd Font en modo desatendido. Consulta README.md para configuración manual."
    return 0
  fi

  echo ""
  if ask_yes_no "$(msg "ssh_client_ask" \
    "Would you like to add SendEnv ON_SSH_SESSION_USE_NERD_FONT to ~/.ssh/config?" \
    "¿Deseas añadir SendEnv ON_SSH_SESSION_USE_NERD_FONT a ~/.ssh/config?")" "n"; then

    mkdir -p "$HOME/.ssh"
    local ssh_config="$HOME/.ssh/config"
    if [[ -f "$ssh_config" ]] && grep -q "SendEnv ON_SSH_SESSION_USE_NERD_FONT" "$ssh_config"; then
      success "$(msg "ssh_client_ok" \
        "SSH client config already contains SendEnv ON_SSH_SESSION_USE_NERD_FONT." \
        "La configuración SSH del cliente ya contiene SendEnv ON_SSH_SESSION_USE_NERD_FONT.")"
    else
      if [[ -f "$ssh_config" ]] && grep -q "^Host \*" "$ssh_config"; then
        # Add under existing Host *
        sed -i.bak '/^Host \*/a\
    SendEnv ON_SSH_SESSION_USE_NERD_FONT' "$ssh_config"
        rm -f "${ssh_config}.bak"
      else
        echo -e "\nHost *\n    SendEnv ON_SSH_SESSION_USE_NERD_FONT" >> "$ssh_config"
      fi
      success "$(msg "ssh_client_done" \
        "Added SendEnv ON_SSH_SESSION_USE_NERD_FONT to ~/.ssh/config." \
        "Añadido SendEnv ON_SSH_SESSION_USE_NERD_FONT a ~/.ssh/config.")"
    fi
  else
    warn "$(msg "ssh_client_reminder" \
      "Remember: you can manually add 'SendEnv ON_SSH_SESSION_USE_NERD_FONT' to ~/.ssh/config for SSH Nerd Font support." \
      "Recuerda: puedes añadir manualmente 'SendEnv ON_SSH_SESSION_USE_NERD_FONT' a ~/.ssh/config para soporte de Nerd Font por SSH.")"
  fi
}

configure_ssh_server() {
  if [[ "$UNATTENDED" == true ]]; then
    return 0
  fi

  echo ""
  warn "$(msg "ssh_server_disclaimer" \
    "DISCLAIMER: The following SSH server configuration is only intended for SSH servers you connect to via terminal." \
    "AVISO: La siguiente configuración de servidor SSH sólo está pensada para servidores SSH a los que te conectes a través de terminal.")"

  if ask_yes_no "$(msg "ssh_server_ask" \
    "Would you like to add AcceptEnv ON_SSH_SESSION_USE_NERD_FONT to /etc/ssh/sshd_config on THIS machine? (requires sudo)" \
    "¿Deseas añadir AcceptEnv ON_SSH_SESSION_USE_NERD_FONT a /etc/ssh/sshd_config en ESTA máquina? (requiere sudo)")" "n"; then

    local sshd_config="/etc/ssh/sshd_config"
    if [[ -f "$sshd_config" ]] && grep -q "ON_SSH_SESSION_USE_NERD_FONT" "$sshd_config"; then
      success "$(msg "ssh_server_ok" \
        "sshd_config already contains AcceptEnv ON_SSH_SESSION_USE_NERD_FONT." \
        "sshd_config ya contiene AcceptEnv ON_SSH_SESSION_USE_NERD_FONT.")"
    else
      if [[ -f "$sshd_config" ]] && grep -q "^AcceptEnv" "$sshd_config"; then
        sudo sed -i.bak 's/^AcceptEnv.*/& ON_SSH_SESSION_USE_NERD_FONT/' "$sshd_config"
        sudo rm -f "${sshd_config}.bak"
      else
        echo "AcceptEnv LANG LC_* ON_SSH_SESSION_USE_NERD_FONT" | sudo tee -a "$sshd_config" > /dev/null
      fi
      success "$(msg "ssh_server_done" \
        "Added AcceptEnv ON_SSH_SESSION_USE_NERD_FONT to sshd_config. Remember to restart sshd." \
        "Añadido AcceptEnv ON_SSH_SESSION_USE_NERD_FONT a sshd_config. Recuerda reiniciar sshd.")"
    fi
  else
    warn "$(msg "ssh_server_reminder" \
      "Remember: for remote SSH Nerd Font support, add 'AcceptEnv ON_SSH_SESSION_USE_NERD_FONT' to /etc/ssh/sshd_config on your servers." \
      "Recuerda: para soporte de Nerd Font en SSH remoto, añade 'AcceptEnv ON_SSH_SESSION_USE_NERD_FONT' a /etc/ssh/sshd_config en tus servidores.")"
  fi
}

# ============================================================================
# Show summary before proceeding
# ============================================================================
show_summary() {
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  msg "summary_header" \
    "The installer will perform the following actions:" \
    "El instalador realizará las siguientes acciones:"
  echo ""

  local actions=()

  if ! is_symlink_to "$TARGET_DIR/.zshrc" "$REPO_DIR/.zshrc"; then
    msg "action" "  • Create symlink: ~/.zshrc" "  • Crear enlace simbólico: ~/.zshrc"
  fi

  local plugins=("zsh-autosuggestions" "zsh-syntax-highlighting" "you-should-use" "zsh-bat")
  for p in "${plugins[@]}"; do
    if [[ ! -d "$ZSH_CUSTOM_DIR/plugins/$p" ]]; then
      msg "action" "  • Install Oh My Zsh plugin: $p" "  • Instalar plugin de Oh My Zsh: $p"
    fi
  done

  if [[ ! -d "$ZSH_CUSTOM_DIR/themes/powerlevel10k" ]]; then
    msg "action" "  • Install Powerlevel10k theme" "  • Instalar tema Powerlevel10k"
  fi

  local p10k_files=(".p10k.zsh" ".p10k.compatible-mode.zsh" ".p10k.enable-compatible-mode-emojis.zsh" ".p10k.my-terminal-extensions.zsh")
  for f in "${p10k_files[@]}"; do
    if ! is_symlink_to "$TARGET_DIR/$f" "$REPO_DIR/$f"; then
      msg "action" "  • Create symlink: ~/$f" "  • Crear enlace simbólico: ~/$f"
    fi
  done

  if ! is_symlink_to "$TARGET_DIR/.config/nvim/init.lua" "$REPO_DIR/.config/nvim/init.lua"; then
    msg "action" "  • Create symlink: ~/.config/nvim/init.lua" "  • Crear enlace simbólico: ~/.config/nvim/init.lua"
  fi

  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
}

# ============================================================================
# Main installation
# ============================================================================
main() {
  echo ""
  echo "============================================================"
  msg "welcome" \
    "  My Terminal - Installer" \
    "  My Terminal - Instalador"
  echo "============================================================"
  echo ""

  # --- Step: Check mandatory prerequisites ---
  step "$(msg "step_prereqs" "Check mandatory prerequisites" "Verificar pre-requisitos obligatorios")"
  install_prerequisites

  # --- Step: Neovim (optional) ---
  step "$(msg "step_nvim" "Neovim (optional)" "Neovim (opcional)")"
  ask_neovim

  # --- Step: Fonts (Mac only, interactive only) ---
  if is_mac; then
    step "$(msg "step_fonts" "Nerd Font installation" "Instalación de Nerd Fonts")"
    install_fonts
  fi

  # --- Show summary and ask to proceed ---
  if [[ "$UNATTENDED" == false ]]; then
    show_summary
    echo ""
    if ! ask_yes_no "$(msg "proceed" \
      "Do you want to proceed with the installation?" \
      "¿Deseas proceder con la instalación?")"; then
      msg "cancelled" "Installation cancelled." "Instalación cancelada."
      exit 0
    fi
  fi

  # --- Step: Zsh symlink ---
  step "$(msg "step_zshrc" "Configure .zshrc symlink" "Configurar enlace simbólico .zshrc")"
  create_symlink "$REPO_DIR/.zshrc" "$TARGET_DIR/.zshrc" ".zshrc"

  # --- Step: Oh My Zsh plugins ---
  step "$(msg "step_plugins" "Install Oh My Zsh plugins" "Instalar plugins de Oh My Zsh")"
  mkdir -p "$ZSH_CUSTOM_DIR/plugins"

  clone_plugin "https://github.com/zsh-users/zsh-autosuggestions" \
    "$ZSH_CUSTOM_DIR/plugins/zsh-autosuggestions" "zsh-autosuggestions"

  clone_plugin "https://github.com/zsh-users/zsh-syntax-highlighting" \
    "$ZSH_CUSTOM_DIR/plugins/zsh-syntax-highlighting" "zsh-syntax-highlighting"

  clone_plugin "https://github.com/MichaelAquilina/zsh-you-should-use" \
    "$ZSH_CUSTOM_DIR/plugins/you-should-use" "you-should-use"

  clone_plugin "https://github.com/fdellwing/zsh-bat" \
    "$ZSH_CUSTOM_DIR/plugins/zsh-bat" "zsh-bat"

  # --- Step: Powerlevel10k theme ---
  step "$(msg "step_p10k_theme" "Install Powerlevel10k theme" "Instalar tema Powerlevel10k")"
  mkdir -p "$ZSH_CUSTOM_DIR/themes"
  if [[ -d "$ZSH_CUSTOM_DIR/themes/powerlevel10k" ]]; then
    success "$(msg "p10k_exists" "Powerlevel10k is already installed." "Powerlevel10k ya está instalado.")"
  else
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM_DIR/themes/powerlevel10k"
    success "$(msg "p10k_done" "Powerlevel10k installed." "Powerlevel10k instalado.")"
  fi

  # --- Step: Powerlevel10k symlinks ---
  step "$(msg "step_p10k_links" "Configure Powerlevel10k symlinks" "Configurar enlaces simbólicos de Powerlevel10k")"
  create_symlink "$REPO_DIR/.p10k.zsh" "$TARGET_DIR/.p10k.zsh" ".p10k.zsh"
  create_symlink "$REPO_DIR/.p10k.compatible-mode.zsh" "$TARGET_DIR/.p10k.compatible-mode.zsh" ".p10k.compatible-mode.zsh"
  create_symlink "$REPO_DIR/.p10k.enable-compatible-mode-emojis.zsh" "$TARGET_DIR/.p10k.enable-compatible-mode-emojis.zsh" ".p10k.enable-compatible-mode-emojis.zsh"
  create_symlink "$REPO_DIR/.p10k.my-terminal-extensions.zsh" "$TARGET_DIR/.p10k.my-terminal-extensions.zsh" ".p10k.my-terminal-extensions.zsh"

  info "$(msg "p10k_configure_info" \
    "Note: You can customize Powerlevel10k at any time by running 'p10k configure'." \
    "Nota: Puedes personalizar Powerlevel10k en cualquier momento ejecutando 'p10k configure'.")"

  # --- Step: Neovim symlink ---
  step "$(msg "step_nvim_link" "Configure Neovim symlink" "Configurar enlace simbólico de Neovim")"
  if configure_neovim_symlink; then
    mkdir -p "$TARGET_DIR/.config/nvim"
    create_symlink "$REPO_DIR/.config/nvim/init.lua" "$TARGET_DIR/.config/nvim/init.lua" "init.lua"
  else
    warn "$(msg "nvim_skipped" \
      "Neovim symlink configuration skipped." \
      "Configuración del enlace simbólico de Neovim omitida.")"
  fi

  # --- Step: SSH Nerd Font support ---
  step "$(msg "step_ssh" "SSH Nerd Font support" "Soporte de Nerd Font por SSH")"
  configure_ssh_client
  configure_ssh_server

  # --- Done ---
  echo ""
  echo "============================================================"
  success "$(msg "done" \
    "Installation complete! Restart your terminal or run: source ~/.zshrc" \
    "¡Instalación completada! Reinicia tu terminal o ejecuta: source ~/.zshrc")"
  echo "============================================================"
}

main
