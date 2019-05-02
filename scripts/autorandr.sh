#!/bin/bash

# Primary monitors
primary_monitors="DP1-1 DP-1-1 DP1-2 DP-1-2 eDP1 eDP-1"


# Function that prints list of connected monitors
isconnected () {
    for i in $connected_monitors; do
        if [[ "$i" == "$1" ]]; then
            return 0
        fi
    done
    return 1
}


# Check monitors available
all_monitors=$(xrandr | grep "connected" | cut -d " " -f1)
connected_monitors=$(xrandr | grep -w "connected" | cut -d " " -f1)
monitornum=$(echo "$connected_monitors" | wc -w)
echo -e "Possible outputs:\n$all_monitors"
echo -e "\n$monitornum connected monitors:\n$connected_monitors"


# Put all primary monitors on left side
randr_command="xrandr"
primary_monitor=""
for monitor in $primary_monitors; do
    if $(isconnected $monitor); then
        if [[ -z $primary_monitor ]]; then
            primary_monitor=$monitor
            randr_command="$randr_command --output $monitor --primary --auto"
        else
            randr_command="$randr_command --output $monitor --right-of $left_monitor --auto"
        fi
        left_monitor=$monitor
        # wake up monitor
        xrandr --output $monitor --off
        xrandr --output $monitor --auto
	fi
done

echo -e "\nUsing $primary_monitor as primary monitor"


# All other monitors on right side of primary
for monitor in $all_monitors; do

    # Skip primary monitors
    if echo ${primary_monitors} | grep -q -w ${monitor}; then
        continue
    fi

    if $(isconnected $monitor); then
        randr_command="$randr_command --output $monitor --right-of $left_monitor --auto"
        left_monitor=$monitor
        # wake up monitor
        xrandr --output $monitor --auto
    else
        randr_command="$randr_command --output $monitor --off"
    fi

done


# run xrandr
echo -e "\nRunning command:\n$randr_command"
$randr_command


# Restart i3
i3-msg restart

# vim: sw=4:tabstop=4
