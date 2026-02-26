#!/bin/bash

# Device IDs
G435="alsa_output.usb-046d_G435_Wireless_Gaming_Headset_V001008005.1-01.analog-stereo"
MAJORV="bluez_output.00:25:D1:58:67:6E"

CURRENT_SINK=$(pactl get-default-sink)

# Logic for toggling between devices
if [ "$CURRENT_SINK" = "$G435" ]; then
  TARGET=$MAJORV
else
  TARGET=$G435
fi

# Check if the target device is actually connected
if ! pactl list short sinks | grep -q "$TARGET"; then
  # Target not found; exit
  exit 0
fi

# If target found; switch
pactl set-default-sink "$TARGET"

# Move all current audio streams to the new device
pactl list sink-inputs short | awk '{print $1}' | while read -r stream_id; do
  pactl move-sink-input "$stream_id" "$TARGET"
done

# Notify using Mako, but only on a successful switch
FRIENDLY_NAME=$(pactl list sinks | grep -A 20 "$TARGET" | grep "Description:" | cut -d: -f2- | xargs)
notify-send -a "System" -t 2000 "Audio Switched" "Output: $FRIENDLY_NAME"
