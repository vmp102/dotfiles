#!/bin/bash

# --- Media Control Section ---
if [ "$1" == "toggle" ]; then
  status=$(playerctl status 2>/dev/null)

  # Perform the play/pause action
  playerctl play-pause

  if [ "$status" == "Playing" ]; then
    msg="Paused Media"
    display_time=500
  else
    # Fetch metadata
    title=$(playerctl metadata title 2>/dev/null)
    artist=$(playerctl metadata artist 2>/dev/null)

    if [ -n "$title" ]; then
      if [ -n "$artist" ]; then
        msg="Playing: $title - $artist"
      else
        msg="Playing: $title"
      fi
    else
      msg="Resumed Media"
    fi
    display_time=2000
  fi

  # FIXED: Added stack-tag for Mako OSD behavior
  notify-send -h string:x-dunst-stack-tag:media-notify \
    -a "System" -u low -t "$display_time" "$msg"
  exit 0
fi

# --- Volume Control Section ---
if [[ "$1" == *%* ]]; then
  wpctl set-mute @DEFAULT_AUDIO_SINK@ 0
  wpctl set-volume @DEFAULT_AUDIO_SINK@ "$1" --limit 1.0
fi

# IMPROVED: Single awk call to handle rounding and mute status
# Using printf "%.0f" ensures 0.58 becomes 58 instead of 57
eval "$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{printf "current_vol=%.0f; is_muted=%d", $2 * 100, ($3 == "[MUTED]")}')"

if [ "$is_muted" -eq 1 ]; then
  notify-send -h string:x-dunst-stack-tag:volume-notify \
    -a "System" -u low -t 500 "Muted"
else
  # The 'int:value' hint allows Mako/Dunst to show a progress bar
  notify-send -h string:x-dunst-stack-tag:volume-notify \
    -h int:value:"$current_vol" \
    -a "System" -u low -t 500 "Volume: ${current_vol}%"
fi
