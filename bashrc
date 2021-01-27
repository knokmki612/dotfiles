[[ "$(uname)" = "Linux" ]] && . /etc/skel/.bashrc

alias rm="confirm rm"
alias cp="confirm cp"
alias mv="confirm mv"
alias sfossdk='/srv/mer/sdks/sfossdk/mer-sdk-chroot'

PATH="$GOPATH/bin:$PATH"

[[ ! "$PATH" =~ "$HOME/.yarn/bin" ]] && {
  PATH="$HOME/.config/yarn/global/node_modules/.bin:$PATH"
  PATH="$HOME/.yarn/bin:$PATH"
}

export PATH

export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
