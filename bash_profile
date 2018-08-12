[[ "$(uname)" = "Linux" ]] && [[ -f "/etc/skel/.bash_profile" ]] && {
	. /etc/skel/.bash_profile
}

[[ "$(uname)" = "Linux" ]] && [[ -f "/etc/skel/.profile" ]] && {
	. /etc/skel/.profile
}

[[ "$(uname -a)" =~ "Microsoft"  ]] && {
	export DISPLAY="localhost:0.0"
}

export HISTSIZE=100000
export HISTTIMEFORMAT='%Y/%m/%d %H:%M:%S '

export DEBEMAIL="knokmki612@gmail.com"
export DEBFULLNAME="Kimiaki Kuno"

export RUBY_CONFIGURE_OPTS="--enable-shared"

export GOPATH="$HOME/.go"

PATH="/usr/games/bin:$PATH"
PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
PATH="$HOME/.anyenv/bin:$PATH"
PATH="$GOPATH/bin:$PATH"
PATH="$HOME/.local/bin:$PATH"
export PATH

eval "$(anyenv init -)"
