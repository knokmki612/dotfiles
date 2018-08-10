#!/bin/sh
backup_list=$(cat <<- +
	Bookmarks
	Notes
	Sessions
	Login Data
	Preferences
	Local App Settings
	Web Data
	Current Session
	Top Sites
	History
	Cookies
	Extension Rules
	Extension State
	Extensions
	Local Extension Settings
	Local Storage
	Managed Extension Storage
	Extension Cookies
	Secure Preferences
+
)
echo "$backup_list"                 |
sed 's;^;.config/vivaldi/Default/;' |
tr '\n' '\0'                        |
xargs -0 zip -r vivaldi-$(date +%Y%m%d_%H%M%S).zip
