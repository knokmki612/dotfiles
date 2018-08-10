#!/bin/sh
ARCHIVE=$(mktemp)
curl https://repo.herecura.eu/herecura/x86_64/ > $ARCHIVE

for branch in vivaldi vivaldi-snapshot vivaldi-developer; do
	package="${branch}-ffmpeg-codecs"
	version=$(
		cat $ARCHIVE                                                           |
		grep ${package/developer/snapshot}                                     |
		sed "s;.*href=\"${package/developer/snapshot}-\([^\"]*\)-x86_64.*;\1;" |
		sort -V                                                                |
		uniq                                                                   |
		tail -n1)
	ebuild=${package}-${version/-1/_p1}.ebuild
	cd /usr/local/portage/www-plugins/${package}
	current_ebuild=$(
		ls -f                  |
		grep ${package}        |
		sort -V                |
		tail -n1)
	if [ ! -f $ebuild ]; then
		cp -n "$current_ebuild" "$ebuild"
		ebuild "$ebuild" digest || exit 1
	fi
done

rm $ARCHIVE
