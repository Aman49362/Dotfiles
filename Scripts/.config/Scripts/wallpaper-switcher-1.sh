#!/bin/bash
# Rofi wallpaper switcher with Matugen integration

WALLPAPER_DIR="$HOME/Pictures/Wallpapers/"
CONFIG_DIR="$HOME/.config/wallpaper-switcher"

# Create config directory
mkdir -p "$CONFIG_DIR"

# Get list of wallpapers
WALLPAPERS=$(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" \) | sort)

if [ -z "$WALLPAPERS" ]; then
    rofi -e "No wallpapers found in $WALLPAPER_DIR"
    exit 1
fi

# Display wallpapers in rofi and get selection
SELECTED=$(echo "$WALLPAPERS" | rofi -dmenu -i -p "🎨 Select wallpaper" -theme-str 'window {width: 60%;} listview {lines: 10;}')

if [ -n "$SELECTED" ] && [ -f "$SELECTED" ]; then
    # Set wallpaper with swww and update colors
    swww img "$SELECTED" --transition-type simple --transition-fps 60
    
    # Update matugen colors
    matugen image "$SELECTED"
    
    # Reload hyprland
    hyprctl reload
    
    # Save last selection
    echo "$SELECTED" > "$CONFIG_DIR/last-wallpaper"
    
    notify-send "Wallpaper Changed" "$(basename "$SELECTED")" -i "$SELECTED"
fi
