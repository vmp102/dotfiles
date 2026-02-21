#!/bin/bash

if [ "$1" == "toggle" ]; then
  status=$(playerctl status 2>/dev/null)

  playerctl play-pause

  if [ "$status" == "Playing" ]; then
    msg="Paused Media"
  else
    msg="Resumed Media"
  fi

  notify-send -h string:x-canonical-private-synchronous:sys-notify \
    -u low -t 500 "$msg"
  exit 0
fi

if [[ "$1" == *%* ]]; then
  wpctl set-mute @DEFAULT_AUDIO_SINK@ 0
  wpctl set-volume @DEFAULT_AUDIO_SINK@ "$1" --limit 1.0
fi

current_vol=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2 * 100)}')
is_muted=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -c "\[MUTED\]")

if [ "$is_muted" -eq 1 ]; then
  notify-send -h string:x-canonical-private-synchronous:sys-notify \
    -u low -t 500 "Muted"
else
  notify-send -h string:x-canonical-private-synchronous:sys-notify \
    -h int:value:"$current_vol" \
    -u low -t 500 "Volume: ${current_vol}%"
fi
