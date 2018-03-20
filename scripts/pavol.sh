#!/bin/bash
SINK_NAME="alsa_output.pci-0000_00_1b.0.analog-stereo"
VOL_STEP="0x01000"

VOL_NOW=`pacmd dump | grep -P "^set-sink-volume $SINK_NAME\s+" | perl -p -i -e 's/.+\s(.x.+)$/$1/'`

case "$1" in
  plus)
    VOL_NEW=$((VOL_NOW + VOL_STEP))
    #if [ $VOL_NEW -gt $((0x10000)) ]
    #then
    #  VOL_NEW=$((0x10000))
    #fi
    pacmd set-sink-volume $SINK_NAME `printf "0x%X" $VOL_NEW`

    ;;
  minus)
    VOL_NEW=$((VOL_NOW - VOL_STEP))
    if [ $(($VOL_NEW)) -lt $((0x00000)) ]
    then
      VOL_NEW=$((0x00000))
    fi
    pacmd set-sink-volume $SINK_NAME `printf "0x%X" $VOL_NEW`
    ;;
  unmute)
      pactl set-sink-mute $SINK_NAME 0
    ;;
  mute)
      pactl set-sink-mute $SINK_NAME 1
    ;;
  toggle)
    MUTE_STATE=`pacmd dump | grep -P "^set-sink-mute $SINK_NAME\s+" | perl -p -i -e 's/.+\s(yes|no)$/$1/'`
    if [ $MUTE_STATE = no ]
    then
      pactl set-sink-mute $SINK_NAME 1
    elif [ $MUTE_STATE = yes ]
    then
      pactl set-sink-mute $SINK_NAME 0
    fi
    ;;
  reset)
    pacmd set-sink-volume $SINK_NAME `printf "0x%X" $VOL_NOW`
esac

mute=`pacmd dump | grep "set-sink-mute alsa_output.pci-0000_00_1b.0.analog-stereo" | cut -d " " -f 3` 
if [[ $mute = yes ]]; then
  result="mute"
else
  hexa=`pacmd dump | grep "set-sink-volume alsa_output.pci-0000_00_1b.0.analog-stereo" | cut -f 3 -d" "`
  percent=`printf "%d\n" $hexa`
  full=655.36
  result=`echo $percent/$full | bc`
  result="$result%"
fi

echo $result | dzen2 -fn 'Bitstream Vera Sans-38:Bold' -p 2 -w 220 -x 850 -y 520
