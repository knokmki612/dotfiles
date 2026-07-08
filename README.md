# dotfiles

Personal dotfiles, managed by [dotfile-installer](https://github.com/knokmki612/dotfile-installer).

## Prerequisites

- An SSH key registered with GitHub — the dotfile-installer submodule is cloned over SSH
- `git` and a POSIX shell (everything else is installed later via mise)

## Install

```sh
git clone --recurse-submodules git@github.com:knokmki612/dotfiles.git
cd dotfiles
./install.sh
```

`install.sh` symlinks every file in this repository to `~/.<path>` with a dot
prefix (e.g. `bashrc` → `~/.bashrc`, `config/mise/config.toml` →
`~/.config/mise/config.toml`). List files you don't want linked on a machine
in `~/.dotfileignore`.

## Post-install

1. Install [mise](https://mise.jdx.dev/) to `~/.local/bin` (bashrc activates
   it from there):

   ```sh
   curl https://mise.run | sh
   ```

2. Install the pinned toolchain:

   ```sh
   mise install
   ```

3. Generate AI agent configs (rules, MCP servers, subagents) and install
   agent skills:

   ```sh
   mise run setup-agentic-ai
   mise run setup-agent-skills
   ```

## Layout

- `bashrc`, `profile`, `xprofile` — shell and X session setup
- `config/` — XDG configs (`~/.config/…`): mise, bspwm, sxhkd, and
  `agentic-ai` (the rulesync source for Claude Code / Codex / Copilot)
- `claude/settings.override.json` — repo-managed Claude Code permissions and
  hooks, merged into `~/.claude/settings.json` by bashrc; hook scripts live in
  `claude/hooks/`
- `local/bin/` — small utility scripts (`~/.local/bin/…`)
- `var/app/` — Flatpak app configs (VS Code)

Tool versions are pinned in `config/mise/config.toml` and kept up to date by
Renovate.
