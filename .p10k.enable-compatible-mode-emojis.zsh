##############################################
# Emoji-only icons for Powerlevel10k (p10k)
# Goal: no Nerd Fonts / no PUA glyphs.
##############################################

# 0) If you use your own Nerd Font detection flag, force it to false.
# (Optional; only if you're using it elsewhere in your config.)
# export USE_NERD_FONT=false

# 1) Optional: reduce prompt "jump" with instant prompt + emojis.
# This does NOT fix "console output during zsh initialization" warnings,
# but it can help keep the prompt more stable visually.
# typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet   # optional

##############################################
# DIRECTORY
##############################################
typeset -g POWERLEVEL9K_DIR_SHOW_VISUAL_IDENTIFIER=true
typeset -g POWERLEVEL9K_DIR_VISUAL_IDENTIFIER_EXPANSION='📁'
typeset -g POWERLEVEL9K_DIR_NOT_WRITABLE_VISUAL_IDENTIFIER_EXPANSION='🔒'

# (Optional) Home folder icon
typeset -g POWERLEVEL9K_DIR_HOME_ICON='🏠'
# (Optional) Home subfolder icon
# typeset -g POWERLEVEL9K_DIR_HOME_SUBFOLDER_ICON='🏠'

##############################################
# GIT / VCS
##############################################
# Branch icon
typeset -g POWERLEVEL9K_VCS_BRANCH_ICON='🌿'

# Useful extras (only visible if your config shows them)
typeset -g POWERLEVEL9K_VCS_STAGED_ICON='➕'
typeset -g POWERLEVEL9K_VCS_UNSTAGED_ICON='✏️'
typeset -g POWERLEVEL9K_VCS_UNTRACKED_ICON='❔'
typeset -g POWERLEVEL9K_VCS_CONFLICTED_ICON='💥'
typeset -g POWERLEVEL9K_VCS_INCOMING_CHANGES_ICON='⬇️'
typeset -g POWERLEVEL9K_VCS_OUTGOING_CHANGES_ICON='⬆️'
typeset -g POWERLEVEL9K_VCS_TAG_ICON='🏷️'

##############################################
# STATUS (exit code, root, background jobs)
##############################################
typeset -g POWERLEVEL9K_STATUS_OK_VISUAL_IDENTIFIER_EXPANSION='✅'
typeset -g POWERLEVEL9K_STATUS_ERROR_VISUAL_IDENTIFIER_EXPANSION='❌'
typeset -g POWERLEVEL9K_STATUS_OK=false   # show only errors (true = always show)

typeset -g POWERLEVEL9K_ROOT_ICON='🧑‍💻'  # or '⚡' if you prefer
# Jobs (if you use the "background_jobs" segment)
typeset -g POWERLEVEL9K_BACKGROUND_JOBS_VISUAL_IDENTIFIER_EXPANSION='🧵'

##############################################
# CURRENT TIME (time) + TIMEZONE
##############################################
typeset -g POWERLEVEL9K_TIME_SHOW_VISUAL_IDENTIFIER=true
typeset -g POWERLEVEL9K_TIME_VISUAL_IDENTIFIER_EXPANSION='🕒'

##############################################
# TOOK (command_execution_time)
##############################################
typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_SHOW_VISUAL_IDENTIFIER=true
typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_VISUAL_IDENTIFIER_EXPANSION='⏱'

##############################################
# CONTEXT (user@host) + SSH
##############################################
# If you use the "context" segment, this makes SSH sessions obvious.
typeset -g POWERLEVEL9K_CONTEXT_TEMPLATE='%n@%m'
typeset -g POWERLEVEL9K_CONTEXT_REMOTE_TEMPLATE='🔐 %n@%m'  # for remote/ssh

##############################################
# LANGUAGES / RUNTIMES (enable only what you use)
##############################################
# Python (python/virtualenv/pyenv depending on your setup)
typeset -g POWERLEVEL9K_PYTHON_VISUAL_IDENTIFIER_EXPANSION='🐍'
typeset -g POWERLEVEL9K_VIRTUALENV_VISUAL_IDENTIFIER_EXPANSION='🧪'

# Node
typeset -g POWERLEVEL9K_NODE_VERSION_VISUAL_IDENTIFIER_EXPANSION='🟩'

# Go / Rust / Java / Ruby / PHP
typeset -g POWERLEVEL9K_GO_VERSION_VISUAL_IDENTIFIER_EXPANSION='🐹'
typeset -g POWERLEVEL9K_RUST_VERSION_VISUAL_IDENTIFIER_EXPANSION='🦀'
typeset -g POWERLEVEL9K_JAVA_VERSION_VISUAL_IDENTIFIER_EXPANSION='☕'
typeset -g POWERLEVEL9K_RBENV_VISUAL_IDENTIFIER_EXPANSION='💎'
typeset -g POWERLEVEL9K_PHP_VERSION_VISUAL_IDENTIFIER_EXPANSION='🐘'

##############################################
# CONTAINERS / ORCHESTRATION
##############################################
typeset -g POWERLEVEL9K_DOCKER_CONTEXT_VISUAL_IDENTIFIER_EXPANSION='🐳'
typeset -g POWERLEVEL9K_KUBECONTEXT_VISUAL_IDENTIFIER_EXPANSION='☸️'

##############################################
# CLOUD / IaC
##############################################
typeset -g POWERLEVEL9K_AWS_VISUAL_IDENTIFIER_EXPANSION='☁️'
typeset -g POWERLEVEL9K_TERRAFORM_VISUAL_IDENTIFIER_EXPANSION='🏗️'

##############################################
# SYSTEM
##############################################
# Battery
typeset -g POWERLEVEL9K_BATTERY_VISUAL_IDENTIFIER_EXPANSION='🔋'
# If you use "load" / "ram" segments (not always present in presets)
typeset -g POWERLEVEL9K_LOAD_VISUAL_IDENTIFIER_EXPANSION='📈'
typeset -g POWERLEVEL9K_RAM_VISUAL_IDENTIFIER_EXPANSION='🧠'

##############################################
# CUSTOM SEGMENTS (CUSTOM_*)
##############################################
# Example: custom "arch" segment
# prompt_my_arch() { p10k segment -i '🐧' -t "$(uname -m)" }
# typeset -g POWERLEVEL9K_CUSTOM_ARCH='prompt_my_arch'
# (If you prefer setting the icon via variable)
# typeset -g POWERLEVEL9K_CUSTOM_ARCH_VISUAL_IDENTIFIER_EXPANSION='🐧'

##############################################
# TIP: prefer "simple" emojis to avoid width/alignment issues
##############################################
# If you notice misalignment, avoid compound emojis (👩‍💻, flags, etc.)
# and stick to basic ones (📁 🌿 ⏱ 🕒 ✅ ❌ 🐳 ☸️).