!/bin/bash

if [ "$1" == "toggle" ]; then
  wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
fi

if [[ "$1" == *%* ]]; then
  wpctl set-volume @DEFAULT_AUDIO_SINK@ "$1" --limit 1.0
fi

current_vol=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2 * 100)}')
is_muted=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -c "\[MUTED\]")

if [ "$is_muted" -eq 1 ]; then
  notify-send -h string:x-canonical-private-synchronous:sys-notify \
    -u low "Muted"
else
  notify-send -h string:x-canonical-private-synchronous:sys-notify \
    -h int:value:"$current_vol" \
    -u low "Volume: ${current_vol}%"
fi
