#!/bin/bash

# use pactl list short sinks to view your devices
G435="alsa_output.usb-046d_G435_Wireless_Gaming_Headset_V001008005.1-01.analog-stereo"
MAJORV="bluez_output.00:25:D1:58:67:6E"
SPEAKERS="alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__Headphones__sink"

case "$1" in
1) TARGET=$G435 ;;
2) TARGET=$MAJORV ;;
3) TARGET=$SPEAKERS ;;
*) exit 1 ;;
esac

pactl set-default-sink "$TARGET"

# Move all currently playing streams to the new sink
pactl list sink-inputs short | awk '{print $1}' | while read -r stream_id; do
  pactl move-sink-input "$stream_id" "$TARGET"
done

FRIENDLY_NAME=$(pactl list sinks | grep -A 20 "$TARGET" | grep "Description:" | cut -d: -f2- | xargs)

notify-send -a "System" -t 2000 "Audio Switched" "Output: $FRIENDLY_NAME"
