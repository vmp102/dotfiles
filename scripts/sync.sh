# IMPORTANT: This file is only for commiting my config to Github
#            and this script is probably useless for you, so don't use it

#!/bin/bash

TARGET_DIR="$HOME/Documents/dotfiles"
CONFIG_TARGET="$TARGET_DIR/.config"
CONFIGS=("fastfetch" "hypr" "kitty" "mako" "nvim" "rofi")

mkdir -p "$TARGET_DIR/scripts"
sudo cp -r /usr/local/bin/. "$TARGET_DIR/scripts/"
cp ~/.bashrc "$TARGET_DIR"

mkdir -p "$CONFIG_TARGET"

for dir in "${CONFIGS[@]}"; do
  if [ -d "$HOME/.config/$dir" ]; then
    mkdir -p "$CONFIG_TARGET/$dir"
    cp -r "$HOME/.config/$dir/." "$CONFIG_TARGET/$dir/"
  fi
done

sudo chown -R $(whoami):$(whoami) "$TARGET_DIR"
