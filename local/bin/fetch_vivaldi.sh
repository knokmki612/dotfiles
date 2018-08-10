#!/bin/sh
ARCHIVE=$(mktemp)
curl http://repo.vivaldi.com/archive/deb/pool/main/ > $ARCHIVE

for branch in vivaldi-stable vivaldi-snapshot; do
	version=$(
		cat $ARCHIVE   |
		grep -v armhf  |
		grep $branch   |
		cut -d '_' -f2 |
		sort -V        |
		tail -n1)
	ebuild=${branch/-stable/}-${version/-/_p}.ebuild
	cd /usr/local/portage/www-client/${branch/-stable}
	current_ebuild=$(
		ls -f                  |
		grep ${branch/-stable} |
		sort -V                |
		tail -n1)
	if [ ! -f $ebuild ]; then
		cp -n "$current_ebuild" "$ebuild"
		ebuild "$ebuild" digest || exit 1
	fi
done

rm $ARCHIVE
