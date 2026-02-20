#!/usr/bin/env bash

## Author : Aditya Shakya (adi1090x)
## Modified by vmp102

# Current Theme
dir="$HOME/.config/rofi/powermenu/type-2"
theme='style-2'

# CMDs
uptime="`uptime -p | sed -e 's/up //g'`"

# Options (Reordered: Shutdown, Reboot, Logout, Lock)
shutdown=''
reboot=''
logout='󰍃'
lock=''
yes=''
no=''

rofi_cmd() {
    rofi -dmenu \
        -p "Uptime: $uptime" \
        -mesg "Uptime: $uptime" \
        -theme-str 'window {width: 650px;}' \
        -theme-str 'listview {columns: 4; lines: 1;}' \
        -theme ${dir}/${theme}.rasi
}

# Confirmation CMD
confirm_cmd() {
    rofi -theme-str 'window {location: center; anchor: center; fullscreen: false; width: 350px;}' \
        -theme-str 'mainbox {children: [ "message", "listview" ];}' \
        -theme-str 'listview {columns: 2; lines: 1;}' \
        -theme-str 'element-text {horizontal-align: 0.5;}' \
        -theme-str 'textbox {horizontal-align: 0.5;}' \
        -dmenu \
        -p 'Confirmation' \
        -mesg 'Are you Sure?' \
        -theme ${dir}/${theme}.rasi
}

# Ask for confirmation
confirm_exit() {
    echo -e "$yes\n$no" | confirm_cmd
}

# Pass variables to rofi dmenu (Updated order and count)
run_rofi() {
    echo -e "$shutdown\n$reboot\n$logout\n$lock" | rofi_cmd
}

# Execute Command

run_cmd() {
    if [[ $1 == '--lock' ]]; then
			hyprlock
    else
        selected="$(confirm_exit)"
        if [[ "$selected" == "$yes" ]]; then
            if [[ $1 == '--shutdown' ]]; then
                systemctl poweroff
            elif [[ $1 == '--reboot' ]]; then
                systemctl reboot
            elif [[ $1 == '--logout' ]]; then
                if [[ "$DESKTOP_SESSION" == 'openbox' ]]; then
                    openbox --exit
                elif [[ "$DESKTOP_SESSION" == 'bspwm' ]]; then
                    bspc quit
                elif [[ "$DESKTOP_SESSION" == 'i3' ]]; then
                    i3-msg exit
                elif [[ "$DESKTOP_SESSION" == 'plasma' ]]; then
                    qdbus org.kde.ksmserver /KSMServer logout 0 0 0
                fi
            fi
        else
            exit 0
        fi
    fi
}
# Actions
chosen="$(run_rofi)"
case ${chosen} in
    $shutdown)
        run_cmd --shutdown
        ;;
    $reboot)
        run_cmd --reboot
        ;;
    $logout)
        run_cmd --logout
        ;;
    $lock)
        run_cmd --lock
        ;;
esac
