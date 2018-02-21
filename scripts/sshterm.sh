#!/bin/bash

title=$(xdotool getwindowfocus getwindowname)
server=$(echo $title | cut -d : -f 1)
path=$(echo $title | cut -d : -f 2)
user=$(echo $title | cut -d @ -f 1)

localhostname=$(hostname -s)
localmachine="${user}@${localhostname}"
fullpath=$(echo $path | sed "s/~/\/home\/$user/")

if [[ $server == $localmachine ]]; then
	termite -d $fullpath
else
	termite --hold -e "ssh $server -t \"cd $path; bash --login\""
fi
