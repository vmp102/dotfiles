#!/bin/bash

TARGET_DIR="$HOME/Documents/dotfiles"
CONFIG_TARGET="$TARGET_DIR/.config"
SCRIPTS_TARGET="$TARGET_DIR/scripts"
CONFIGS=("fastfetch" "hypr" "kitty" "mako" "nvim" "rofi")

rm -rf "$SCRIPTS_TARGET"/*
rm -rf "$CONFIG_TARGET"/*

mkdir -p "$SCRIPTS_TARGET"
sudo cp -r /usr/local/bin/. "$SCRIPTS_TARGET/"
cp ~/.zshrc "$TARGET_DIR"

mkdir -p "$CONFIG_TARGET"

for dir in "${CONFIGS[@]}"; do
  if [ -d "$HOME/.config/$dir" ]; then
    mkdir -p "$CONFIG_TARGET/$dir"
    cp -r "$HOME/.config/$dir/." "$CONFIG_TARGET/$dir/"
  fi
done

sudo chown -R $(whoami):$(whoami) "$TARGET_DIR"
