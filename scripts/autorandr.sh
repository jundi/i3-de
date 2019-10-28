#!/bin/bash

# Left monitors and primary monitors
left_monitors="DP-1 HDMI-1 DP1-1 DP-1-1 DP1-2 DP-1-2 eDP1 eDP-1"
primary_monitors="DP-1-1 DP-1 eDP1 eDP-1"


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


# Put all left monitors on left side
randr_command="xrandr"
left_monitor=""
for monitor in $left_monitors; do
    if $(isconnected $monitor); then
        if [[ -z $left_monitor ]]; then
            left_monitor=$monitor
            randr_command="$randr_command --output $monitor --primary --auto"
        else
            randr_command="$randr_command --output $monitor --right-of $left_monitor --auto"
        fi
        left_monitor=$monitor
    fi
done


# All other monitors on right side of left monitors
for monitor in $all_monitors; do

    # Skip left monitors
    if echo ${left_monitors} | grep -q -w ${monitor}; then
        continue
    fi

    if $(isconnected $monitor); then
        randr_command="$randr_command --output $monitor --right-of $left_monitor --auto"
        left_monitor=$monitor
    else
        randr_command="$randr_command --output $monitor --off"
    fi

done


# Reset everything
xrandr --auto


# run xrandr
echo -e "\nRunning command:\n$randr_command"
$randr_command


# choose primary monitor
for monitor in $primary_monitors; do
    if $(isconnected $monitor); then
        xrandr --output $monitor --primary
        break
    fi
done


# Restart i3
i3-msg restart

# vim: sw=4:tabstop=4
