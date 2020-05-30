[[ "$(uname)" = "Linux" ]] && . /etc/skel/.bashrc

alias rm="confirm rm"
alias cp="confirm cp"
alias mv="confirm mv"



[[ ! "$PATH" =~ "$HOME/.yarn/bin" ]] && {
  PATH="$HOME/.config/yarn/global/node_modules/.bin:$PATH"
  PATH="$HOME/.yarn/bin:$PATH"
}

export PATH
alias sfossdk='/srv/mer/sdks/sfossdk/mer-sdk-chroot'

export SDKMAN_DIR="/var/home/kimiaki/.sdkman"
[[ -s "/var/home/kimiaki/.sdkman/bin/sdkman-init.sh" ]] && source "/var/home/kimiaki/.sdkman/bin/sdkman-init.sh"
