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

[[ ! "$PATH" =~ "$HOME/bin" ]] && {
  PATH="$HOME/bin:$PATH"
}

[[ ! "$PATH" =~ "$HOME/.local/bin" ]] && {
  PATH="$HOME/.local/bin:$PATH"
}

[[ -d "/usr/games/bin" ]] && {
  PATH="/usr/games/bin:$PATH"
}

[[ -d "$HOME/.asdf" ]] && {
  source "$HOME/.asdf/asdf.sh"
  source "$HOME/.asdf/completions/asdf.bash"
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

[[ -f "$HOME/.bashrc_override" ]] && {
	source "$HOME/.bashrc_override"
}
