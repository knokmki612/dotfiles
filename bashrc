[[ -f "/etc/skel/.bashrc" ]] && {
  source "/etc/skel/.bashrc"
}

[[ -f "$HOME/bin/docker" ]] && {
  export DOCKER_HOST="unix:///run/user/1000/docker.sock"
}
[[ "$(uname -a)" =~ "microsoft"  ]] && {
	export DISPLAY="$(cat /etc/resolv.conf | grep "nameserver" | cut -d ' ' -f 2):0.0"
}

[[ -z "$TMPDIR" ]] && {
  export TMPDIR="/tmp"
}

[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && {
  export SDKMAN_DIR="$HOME/.sdkman"
  source "$HOME/.sdkman/bin/sdkman-init.sh"
}

[[ ! "$PATH" =~ "$HOME/bin" ]] && {
  PATH="$HOME/bin:$PATH"
}

[[ ! "$PATH" =~ "$HOME/.local/bin" ]] && {
  PATH="$HOME/.local/bin:$PATH"
}

[[ ! "$PATH" =~ "$HOME/.yarn/bin" ]] && {
  PATH="$HOME/.config/yarn/global/node_modules/.bin:$PATH"
  PATH="$HOME/.yarn/bin:$PATH"
}

[[ -d "/usr/games/bin" ]] && {
  PATH="/usr/games/bin:$PATH"
}

[[ -d "$HOME/.npm-global/bin" ]] && {
  PATH="$HOME/.npm-global/bin:$PATH"
}

[[ -d "$HOME/.anyenv/envs/pyenv" ]] && {
  export PYENV_ROOT="$HOME/.anyenv/envs/pyenv"
  PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init --path)"
}

[[ -d "$HOME/.anyenv/bin" ]] && {
  PATH="$HOME/.anyenv/bin:$PATH"
  eval "$(anyenv init -)"
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

[[ -f "$HOME/.bashrc_override" ]] && {
	source "$HOME/.bashrc_override"
}
