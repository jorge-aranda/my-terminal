# My Terminal Extensions for Powerlevel10k
# This file is sourced after .p10k.zsh and contains my terminal extensions
# that are NOT part of the standard p10k configuration.
#
# Unlike .p10k.zsh, this file is NOT overwritten by `p10k configure`.
# To regenerate the base configuration, run: p10k configure
# Your extensions in this file will be preserved.

# Custom architecture segment
# Custom architecture with conditional colors
function prompt_my_arch() {
  # Detect if Nerd Font is available
  local has_nerd_font=$(check_nerd_font)

  local arch=$(uname -m)

  if [[ "$arch" == "arm64" || "$arch" == "aarch64" ]]; then
    if [[ "$has_nerd_font" == true ]]; then
      echo -n "%F{039}\ue266 $arch%f"  #   Clear Blue
    elif is_graphical_terminal; then
      echo -n "%F{039}🧠 $arch%f"  # 🧠 Clear Blue
    else
      echo -n "%F{039}$arch%f"  # Clear Blue
    fi
  elif [[ "$arch" == "x86_64" ]]; then
    if [[ "$has_nerd_font" == true ]]; then
      echo -n "%F{027}\ue266 $arch%f"  #   Dark Blue
    elif is_graphical_terminal; then
      echo -n "%F{027}🧠 $arch%f"  # 🧠 Dark Blue
    else
      echo -n "%F{027}$arch%f"  # Dark Blue
    fi
  else
    if [[ "$has_nerd_font" == true ]]; then
      echo -n "%F{030}\ue266 $arch%f"  #   Dark Cyan
    elif is_graphical_terminal; then
      echo -n "%F{030}🧠 $arch%f"  # 🧠 Dark Cyan
    else
      echo -n "%F{030}$arch%f"  # Dark Cyan
    fi
  fi
}
typeset -g POWERLEVEL9K_CUSTOM_ARCH="prompt_my_arch"

# Auto-detect OS and set appropriate icon
function set_os_icon() {
  local os_icon nerd_icon emoji_icon

  case "$(uname -s)" in
    Darwin*)  nerd_icon=$'\uF179'; emoji_icon='🍎' ;;
    Linux*)   nerd_icon=$'\uF17C'; emoji_icon='🐧' ;;
    CYGWIN*|MINGW*|MSYS*) nerd_icon=$'\uF17A'; emoji_icon='🪟' ;;
    *)        nerd_icon=$'\uF109'; emoji_icon='💻' ;;
  esac

  # Detect if Nerd Font is available
  local has_nerd_font=$(check_nerd_font)

  # Return appropriate icon
  if [[ "$has_nerd_font" == true ]]; then
    echo "$nerd_icon"
  else
    # Fallback: try emoji if graphical terminal, otherwise text
    if is_graphical_terminal; then
      echo "$emoji_icon"
    else
      case "$(uname -s)" in
        Darwin*)  echo '[Mac]' ;;
        Linux*)   echo '[Linux]' ;;
        *)        echo '[OS]' ;;
      esac
    fi
  fi
}

typeset -g POWERLEVEL9K_OS_ICON_CONTENT_EXPANSION="$(set_os_icon)"
