[[ "$(uname)" = "Linux" ]] && . /etc/skel/.bashrc

confirm_rm() {
	echo "rm $@"
	echo "are you sure you want to remove these files?"
	while true; do
		echo -n '(y/n): '
		read res
		if echo "$res" | grep '^[yn]$' 2>&1 >/dev/null; then
			break
		fi
	done
	if [ "$res" = y ]; then
		\rm "$@"
	else
		echo 'these files were saved!'
	fi
}

confirm_cp() {
	echo "cp $@"
	echo "are you sure you want to copy these files?"
	while true; do
		echo -n '(y/n): '
		read res
		if echo "$res" | grep '^[yn]$' 2>&1 >/dev/null; then
			break
		fi
	done
	if [ "$res" = y ]; then
		\cp "$@"
	else
		echo 'these files were saved!'
	fi
}

confirm_mv() {
	echo "mv $@"
	echo "are you sure you want to move these files?"
	while true; do
		echo -n '(y/n): '
		read res
		if echo "$res" | grep '^[yn]$' 2>&1 >/dev/null; then
			break
		fi
	done
	if [ "$res" = y ]; then
		\mv "$@"
	else
		echo 'these files were saved!'
	fi
}

alias rm="confirm_rm"
alias cp="confirm_cp"
alias mv="confirm_mv"
[[ ! "$PATH" =~ "$HOME/.yarn/bin" ]] && {
  PATH="$HOME/.config/yarn/global/node_modules/.bin:$PATH"
  PATH="$HOME/.yarn/bin:$PATH"
}

export PATH
alias sfossdk='/srv/mer/sdks/sfossdk/mer-sdk-chroot'

export SDKMAN_DIR="/var/home/kimiaki/.sdkman"
[[ -s "/var/home/kimiaki/.sdkman/bin/sdkman-init.sh" ]] && source "/var/home/kimiaki/.sdkman/bin/sdkman-init.sh"
