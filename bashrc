[[ -f "/etc/skel/.bashrc" ]] && {
  source "/etc/skel/.bashrc"
}

[[ -f "$HOME/bin/docker" ]] && {
  export DOCKER_HOST="unix:///run/user/1000/docker.sock"
}

[[ -z "$TMPDIR" ]] && {
  export TMPDIR="/tmp"
}

[[ ! "$PATH" =~ "$HOME/bin" ]] && {
  PATH="$HOME/bin:$PATH"
}

[[ ! "$PATH" =~ "$HOME/.local/bin" ]] && {
  PATH="$HOME/.local/bin:$PATH"
}

[[ -d "/usr/games/bin" ]] && {
  PATH="/usr/games/bin:$PATH"
}

[[ -d "$HOME/SDK/SailfishOS/bin" ]] && {
  PATH="$HOME/SDK/SailfishOS/bin:$PATH"
}

export PATH

alias rm="confirm rm"
alias cp="confirm cp"
alias mv="confirm mv"
alias sfossdk="/srv/mer/sdks/sfossdk/mer-sdk-chroot"

export HISTSIZE=100000
export HISTTIMEFORMAT="%Y/%m/%d %H:%M:%S "

export DEBEMAIL="knokmki612@gmail.com"
export DEBFULLNAME="Kimiaki Kuno"

export RUBY_CONFIGURE_OPTS="--enable-shared"

export EDITOR="/usr/bin/env vim"

export GIT_EDITOR="$EDITOR"

export CLAUDE_CONFIG_DIR="$HOME/.claude"

[[ -f "/var/lib/flatpak/exports/bin/com.google.Chrome" ]] && {
  export CHROME_PATH="/var/lib/flatpak/exports/bin/com.google.Chrome"
}

[[ -f "$HOME/.bashrc_override" ]] && {
	source "$HOME/.bashrc_override"
}

[[ -f "$HOME/.local/bin/mise" ]] && {
  eval "$($HOME/.local/bin/mise activate bash)"
}

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
