#!/bin/bash

usage() {
  [[ "$2" ]] && echo "error: $2"
  echo "usage: $0 [-h] [-u] appname"
  echo "where: -u = unmute application (default action is to mute)"
  exit "$1"
}

# This function finds the PipeWire Node IDs for the app
get_ids() {
  local app_name="$1"

  # Strategy 1: Look for the PID via Hyprland's class name (most accurate for Element)
  local target_pid=$(hyprctl clients -j | jq -r --arg class "im.riot.Riot" '.[] | select(.class == $class) | .pid' | head -n 1)

  if [[ -n "$target_pid" ]]; then
    # Find IDs in PipeWire that match this PID
    pw-dump | jq -r --arg pid "$target_pid" '.[] | select(.info.props."application.process.id" == ($pid | tonumber)) | .id'
  else
    # Strategy 2: Fallback to searching by name (Chromium/Element) if Hyprland check fails
    wpctl status | grep -iE "Element|Chromium" | grep -oP '(?<=\[)\d+(?=\])'
  fi
}

adjust_muteness() {
  local app_name="$1"
  local mute_state="$2" # "1" for mute, "0" for unmute

  local ids=$(get_ids "$app_name")

  if [[ -z "$ids" ]]; then
    echo "error: no active audio streams found for: $app_name" >&2
    return 1
  fi

  for id in $ids; do
    wpctl set-mute "$id" "$mute_state"
  done

  # Visual feedback
  if [[ "$mute_state" == "1" ]]; then
    notify-send "Element" "Muted" -i audio-volume-muted
  else
    notify-send "Element" "Unmuted" -i audio-volume-high
  fi
}

mute() { adjust_muteness "$1" 1; }
unmute() { adjust_muteness "$1" 0; }

main() {
  local action=mute
  while getopts :hu option; do
    case "$option" in
    h) usage 0 ;;
    u) action=unmute ;;
    ?) usage 1 "invalid option: -$OPTARG" ;;
    esac
  done
  shift $((OPTIND - 1))

  if [[ "$1" ]]; then
    $action "$1"
  else
    # Default to Element if no name is provided
    $action "Element"
  fi
}

main "$@"
