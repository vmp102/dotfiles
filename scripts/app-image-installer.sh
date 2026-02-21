#!/bin/bash

# Define paths for AppImages, icons, and desktop entries
APP_DIR="$HOME/AppImages"
ICON_DIR="$APP_DIR/icons"
DESKTOP_DIR="$HOME/.local/share/applications"

# Prevent the script from processing a literal asterisk if the directory is empty
shopt -s nullglob
mkdir -p "$ICON_DIR"

# Ensure all AppImage files have executable permissions
chmod +x "$APP_DIR"/*.AppImage

for app in "$APP_DIR"/*.AppImage; do
  # Strip path and extension to define the application name
  filename=$(basename "$app")
  app_name="${filename%.*}"

  echo "Processing: $app_name"

  # Move to the AppImage directory to perform extraction
  cd "$APP_DIR" || exit

  # Perform a full extraction to ensure all internal files are accessible
  # This addresses cases where specific path extraction fails
  "$app" --appimage-extract >/dev/null 2>&1

  # Check for the existence of .DirIcon as the primary source
  if [ -f "squashfs-root/.DirIcon" ]; then
    cp "squashfs-root/.DirIcon" "$ICON_DIR/$app_name.png"
    echo "Found .DirIcon"
  else
    # Search for any PNG or SVG file inside the entire extracted folder tree
    # Priority is given to icons not located in restricted system or locale folders
    EXTRACTED_ICON=$(find squashfs-root -type f \( -name "*.png" -o -name "*.svg" \) ! -path "*locales*" ! -path "*node_modules*" | head -n 1)

    if [ -n "$EXTRACTED_ICON" ]; then
      cp "$EXTRACTED_ICON" "$ICON_DIR/$app_name.png"
      echo "Found fallback icon: $(basename "$EXTRACTED_ICON")"
    else
      echo "No icon found for $app_name"
    fi
  fi

  # Remove the temporary extraction directory to save disk space
  rm -rf squashfs-root

  # Generate the .desktop file with the correct executable and icon paths
  cat <<EOF >"$DESKTOP_DIR/$app_name.desktop"
[Desktop Entry]
Type=Application
Name=$app_name
Exec=$app
Icon=$ICON_DIR/$app_name.png
Terminal=false
Categories=Utility;
EOF
done

# Rebuild the desktop database so the system recognizes new entries
update-desktop-database "$DESKTOP_DIR"

# Update timestamps on desktop files to trigger a refresh in the application menu
touch "$DESKTOP_DIR"/*.desktop

echo "All done! :3"
