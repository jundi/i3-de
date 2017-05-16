#!/bin/bash

# Laptop screen
laptop_monitor="eDP1"
# Primary monitors
primary_monitors="DP1-1 DP1-2"


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


# Choose first connected primary monitor from list (laptop_monitor as fallback)
primary_monitor=$laptop_monitor
for monitor in $primary_monitors; do
    if $(isconnected $monitor); then
	primary_monitor=$monitor
	break
    fi
done

echo -e "\nUsing $primary_monitor as primary monitor"


# Primary monitor on left side
randr_command="xrandr --output $primary_monitor --primary --auto"
# wake up monitor
xrandr --output $primary_monitor --primary --auto


# All other monitors on right side of primary
left_monitor=$primary_monitor
for monitor in $all_monitors; do

    # Skip primary monitor
    if [[ $monitor == $primary_monitor ]]; then
        continue
    fi

    # Skip laptop monitor
    if [[ $monitor == $laptop_monitor ]]; then
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

# Laptop screen on right side
if [[ $primary_monitor != $laptop_monitor ]]; then
    randr_command="$randr_command --output eDP1 --auto --right-of $left_monitor"
fi

# run xrandr
echo -e "\nRunning command:\n$randr_command"
$randr_command


# Restart i3
#i3-msg restart

# vim: sw=4
