#!/bin/bash

# Replace these with the names found via: pactl list short sinks
DEV1="alsa_output.usb-046d_G435_Wireless_Gaming_Headset_V001008005.1-01.analog-stereo"
DEV2="bluez_output.00:25:D1:58:67:6E"

CURRENT_SINK=$(pactl info | grep "Default Sink" | awk '{print $3}')

if [ "$CURRENT_SINK" = "$DEV1" ]; then
  TARGET=$DEV2
else
  TARGET=$DEV1
fi

pactl set-default-sink "$TARGET"

pactl list sink-inputs short | awk '{print $1}' | while read -r stream_id; do
  pactl move-sink-input "$stream_id" "$TARGET"
done

FRIENDLY_NAME=$(pactl list sinks | grep -A 20 "$TARGET" | grep "Description:" | cut -d: -f2- | xargs)

# Notify using mako (via notify-send)
# Mako picks up standard desktop notifications.
notify-send -a "System" -t 2000 "Audio Switched" "Output: $FRIENDLY_NAME"
