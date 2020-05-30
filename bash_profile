[[ "$(uname)" = "Linux" ]] && [[ -f "/etc/skel/.bash_profile" ]] && {
	. /etc/skel/.bash_profile
}

[[ "$(uname)" = "Linux" ]] && [[ -f "/etc/skel/.profile" ]] && {
	. /etc/skel/.profile
}

[[ -f "$HOME/.homebrew_profile" ]] && {
	. "$HOME/.homebrew_profile"
}

[[ "$(uname -a)" =~ "microsoft"  ]] && {
	export DISPLAY="$(cat /etc/resolv.conf | grep "nameserver" | cut -d ' ' -f 2):0.0"
}

[[ -f "$HOME/bin/docker" ]] && {
  export DOCKER_HOST="unix:///run/user/1000/docker.sock"
}

export HISTSIZE=100000
export HISTTIMEFORMAT='%Y/%m/%d %H:%M:%S '

export DEBEMAIL="knokmki612@gmail.com"
export DEBFULLNAME="Kimiaki Kuno"

export RUBY_CONFIGURE_OPTS="--enable-shared"

export EDITOR="/usr/bin/env vim"

PATH="$HOME/SDK/Qt/5.9.1/gcc_64/bin:$PATH"
PATH="$HOME/SDK/julia/bin:$PATH"
PATH="$HOME/.anyenv/bin:$PATH"

[[ ! "$PATH" =~ "$HOME/bin" ]] && {
  PATH="$HOME/bin:$PATH"
}

[[ ! "$PATH" =~ "$HOME/.local/bin" ]] && {
  PATH="$HOME/.local/bin:$PATH"
}

[[ ! "$PATH" =~ "$HOME/.local/bin" ]] && {
  PATH="$HOME/.local/bin:$PATH"
}

[[ -d "/usr/games/bin" ]] && {
  PATH="/usr/games/bin:$PATH"
}

export PATH

eval "$(anyenv init -)"
