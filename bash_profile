[ "$(uname -a)" = "Linux" ] && . /etc/skel/.bash_profile

export HISTSIZE=100000
export HISTTIMEFORMAT='%Y/%m/%d %H:%M:%S '

export RUBY_CONFIGURE_OPTS="--enable-shared"

export GOPATH="$HOME/.go"

PATH="/usr/games/bin:$PATH"
PATH="$HOME/.anyenv/bin:$PATH"
PATH="$GOPATH/bin:$PATH"
PATH="$HOME/.yarn/bin:$PATH"
PATH="$HOME/.local/bin:$PATH"
export PATH

eval "$(anyenv init -)"
