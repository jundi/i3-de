#!/bin/bash

title=$(xdotool getwindowfocus getwindowname)
server=$(echo $title | cut -d @ -f 2 | cut -d : -f 1)
path=$(echo $title | cut -d : -f 2)
user=$(echo $title | cut -d @ -f 1)

localhostname=$(hostname -s)
fullpath=$(echo $path | sed "s/~/\/home\/$user/")

if [[ $server == $localhostname ]]; then
	termite -d $fullpath
else
	termite --hold -e "ssh $server -t \"cd $path; bash --login\""
fi
