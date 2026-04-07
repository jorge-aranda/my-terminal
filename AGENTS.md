# Agents

This repository is maintained and updated with the help of AI agents.

## Conventions

When working with this repository, agents should follow these rules:

### Commit Messages

All commits must follow the [Conventional Commits](https://www.conventionalcommits.org/) format with a specific scope:

*   `feat(<scope>): <<message>>` for new features or infrastructure additions.
*   `fix(<scope>): <<message>>` for bug fixes or configuration corrections.
*   `enhancement(<scope>): <<message>>` for improvements to existing features.
*   `docs(<scope>): <<message>>` for documentation changes.
*   `refactor(<scope>): <<message>>` for code restructuring without changing functionality.
*   `chore(<scope>): <<message>>` for maintenance tasks (dependency updates, cleanup, etc.).
*   `style(<scope>): <<message>>` for formatting changes that don't affect code meaning.
*   `test(<scope>): <<message>>` for adding or updating tests.
*   `ci(<scope>): <<message>>` for CI/CD pipeline changes.
*   `perf(<scope>): <<message>>` for performance improvements.
*   `revert(<scope>): <<message>>` for reverting a previous commit.

Common scopes include: `build`, `zsh`, `nvim`, `powerlevel10k`, `AGENTS.md`, `README.md`.

### Project Structure

The repository is intended to be cloned into:
`~/repos/jorge-aranda/my-terminal`

### Environment Requirements

*   **Neovim**: Configuration located in `.config/nvim/init.lua`
*   **Oh My Zsh**: Configuration located in `.zshrc`
*   **Powerlevel10k**: Theme configuration in `.p10k.zsh`
*   **Fira Code Nerd Font**: Required for icons and symbols.
*   **pyenv**: Python version management, configured in `.zshrc`
