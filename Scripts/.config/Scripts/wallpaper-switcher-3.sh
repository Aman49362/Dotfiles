#!/bin/bash
# Random wallpaper selector

WALLPAPER_DIR="$HOME/git/wallpaper/Wallpaper-Bank/wallpapers/"
CONFIG_FILE="$HOME/.config/wallpaper-switcher/last.txt"

# Get random wallpaper
WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.png" \) | shuf -n 1)

if [ -z "$WALLPAPER" ]; then
    notify-send "Error" "No wallpapers found in $WALLPAPER_DIR"
    exit 1
fi

# Set wallpaper
swww img "$WALLPAPER" --transition-type any --transition-step 20 --transition-fps 60

# Update colors
matugen image "$WALLPAPER" 
sleep 1
wal -i "$WALLPAPER" -n
walogram

# Reload hyprland
hyprctl reload

# Save selection
echo "$WALLPAPER" > "$CONFIG_FILE"
# sudo cp "$WALLPAPER" /home/god/.config/wlogout/last-wallpaper
#notify-send "Random Wallpaper" "$(basename "$WALLPAPER")" -i "$WALLPAPER"
