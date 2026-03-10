#!/bin/bash

# --- Device IDs ---
G435="alsa_output.usb-046d_G435_Wireless_Gaming_Headset_V001008005.1-01.analog-stereo"
MAJORV_BT="bluez_output.00:25:D1:58:67:6E"
MAJORV_JACK="alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__Headphones__sink"

CURRENT_SINK=$(pactl get-default-sink)

# --- Determine the "Major V" Status ---
# Check if Jack is plugged in first; if not, check for Bluetooth
if pactl list short sinks | grep -q "$MAJORV_JACK"; then
  MAJORV_ACTIVE="$MAJORV_JACK"
elif pactl list short sinks | grep -q "$MAJORV_BT"; then
  MAJORV_ACTIVE="$MAJORV_BT"
else
  MAJORV_ACTIVE=""
fi

# --- Logic for Toggling ---
# If we are on G435, switch to Major V (if available)
if [ "$CURRENT_SINK" = "$G435" ]; then
  if [ -n "$MAJORV_ACTIVE" ]; then
    TARGET="$MAJORV_ACTIVE"
  else
    # Major V not found; nowhere to switch
    exit 0
  fi
# If we are currently on ANY Major V connection, switch to G435
else
  if pactl list short sinks | grep -q "$G435"; then
    TARGET="$G435"
  else
    # G435 not found; stay on current
    exit 0
  fi
fi

# --- Execute the Switch ---
pactl set-default-sink "$TARGET"

# Move all active audio streams to the new device
pactl list sink-inputs short | awk '{print $1}' | while read -r stream_id; do
  pactl move-sink-input "$stream_id" "$TARGET"
done

# --- Notification ---
FRIENDLY_NAME=$(pactl list sinks | grep -A 20 "$TARGET" | grep "Description:" | cut -d: -f2- | xargs)
notify-send -a "System" -t 2000 "Audio Switched" "Output: $FRIENDLY_NAME"
