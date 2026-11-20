# dotfiles

Personal dotfiles, managed by [dotfile-installer](https://github.com/knokmki612/dotfile-installer).

## Prerequisites

- `git`, `curl` and a POSIX shell (everything else is installed via mise)

## Install

1. Install [mise](https://mise.jdx.dev/) to `~/.local/bin` (bashrc activates
   it from there):

   ```sh
   curl https://mise.run | sh
   ```

2. Clone this repository and link the dotfiles with
   [dotfile-installer](https://github.com/knokmki612/dotfile-installer),
   fetched by mise (the mise config itself is one of the linked files, so the
   first run uses `mise exec` directly):

   ```sh
   git clone https://github.com/knokmki612/dotfiles.git
   cd dotfiles
   ~/.local/bin/mise exec github:knokmki612/dotfile-installer@1.3.0 -- dotfile-installer
   ```

   Afterwards dotfile-installer is pinned in `config/mise/config.toml`, so
   re-linking is just `dotfile-installer` in this directory.

   The installer is also kept as a git submodule (cloned over SSH, so an SSH
   key registered with GitHub is needed). With it, the classic flow still
   works:

   ```sh
   git clone --recurse-submodules git@github.com:knokmki612/dotfiles.git
   cd dotfiles
   ./install.sh
   ```

dotfile-installer symlinks every file in this repository to `~/.<path>` with
a dot prefix (e.g. `bashrc` → `~/.bashrc`, `config/mise/config.toml` →
`~/.config/mise/config.toml`). List files you don't want linked on a machine
in `~/.dotfileignore`.

## Post-install

1. Install the pinned toolchain:

   ```sh
   mise install
   ```

2. Generate AI agent configs (rules, subagents, permissions), install agent
   skills, and install Claude Code plugins:

   ```sh
   mise run setup-agentic-ai
   mise run setup-agent-skills
   mise run setup-claude-plugins
   ```

## Layout

- `bashrc`, `profile`, `xprofile` — shell and X session setup
- `config/` — XDG configs (`~/.config/…`): mise, bspwm, sxhkd, and
  `agentic-ai` (the rulesync source for Claude Code / Codex / Copilot /
  OpenCode)
- `claude/settings.override.json` — repo-managed Claude Code hooks, merged
  into `~/.claude/settings.json` by bashrc; hook scripts live in
  `claude/hooks/`. Permissions come from rulesync instead
  (`config/agentic-ai/.rulesync/permissions.jsonc`, Claude Code and OpenCode)
- `local/bin/` — small utility scripts (`~/.local/bin/…`)
- `var/app/` — Flatpak app configs (VS Code)

Tool versions are pinned in `config/mise/config.toml` and kept up to date by
Renovate.
