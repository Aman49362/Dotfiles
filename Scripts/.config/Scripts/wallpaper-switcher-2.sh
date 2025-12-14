#!/bin/bash
# Advanced wallpaper switcher with thumbnails preview

WALLPAPER_DIR="$HOME/Pictures/Wallpapers/"
THUMBNAIL_DIR="$HOME/.cache/wallpaper-thumbnails"
CONFIG_FILE="$HOME/.config/wallpaper-switcher/last.txt"

mkdir -p "$THUMBNAIL_DIR"
mkdir -p "$(dirname "$CONFIG_FILE")"

# Generate thumbnails if they don't exist
generate_thumbnails() {
    find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.png" \) | while read -r wallpaper; do
        thumb_name=$(echo "$wallpaper" | md5sum | cut -d' ' -f1)
        thumb_path="$THUMBNAIL_DIR/$thumb_name.jpg"
        
        if [ ! -f "$thumb_path" ]; then
            convert "$wallpaper" -resize 200x100^ -gravity center -extent 200x100 "$thumb_path" 2>/dev/null
        fi
    done
}

# Create selection list with thumbnails
create_selection_list() {
    find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.png" \) | while read -r wallpaper; do
        thumb_name=$(echo "$wallpaper" | md5sum | cut -d' ' -f1)
        thumb_path="$THUMBNAIL_DIR/$thumb_name.jpg"
        echo -e "$(basename "$wallpaper")\x00icon\x1f$thumb_path\x1finfo\x1f$wallpaper"
    done
}

generate_thumbnails

SELECTED=$(create_selection_list | rofi -dmenu -i -p "🖼️ Select wallpaper" \
    -theme-str 'window {width: 50%;}' \
    -theme-str 'listview {lines: 6;}' \
    -show-icons)

if [ -n "$SELECTED" ]; then
    # Extract full path from selection
    WALLPAPER_PATH=$(echo "$SELECTED" | grep -oP 'info\x1f\K[^\x1f]*')
    
    if [ -f "$WALLPAPER_PATH" ]; then
        # Set wallpaper
        swww img "$WALLPAPER_PATH" --transition-type simple --transition-fps 60
        sleep 1
        
        # Update colors
        matugen image "$WALLPAPER_PATH"
        
        # Reload hyprland
        hyprctl reload
        
        # Save to config
        echo "$WALLPAPER_PATH" > "$CONFIG_FILE"
        
        notify-send "Wallpaper Set" "$(basename "$WALLPAPER_PATH")" -i "$WALLPAPER_PATH"
    fi
fi
