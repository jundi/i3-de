#!/bin/bash
notify-send -t 2000 -- "clipboard" "`xsel -b`"
notify-send -t 2000 "primary" "\r `xsel -p`"
