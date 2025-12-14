#!/bin/bash

WALLPAPER_DIR="/home/god/Pictures/trial/"
PREVIEW_DIR="$HOME/.cache/wallpaper-previews"
mkdir -p "$PREVIEW_DIR"

# Create a list with thumbnails
create_wallpaper_list() {
    while IFS= read -r -d '' img; do
        preview="$PREVIEW_DIR/$(basename "$img").png"
        # Generate thumbnail if it doesn't exist
        if [[ ! -f "$preview" ]]; then
            convert "$img" -thumbnail 100x100^ -gravity center -extent 100x100 "$preview" 2>/dev/null || cp "$img" "$preview"
        fi
        echo -e "$(basename "$img")\x00icon\x1f$preview"
    done < <(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" -o -name "*.webp" \) -print0)
}

# Get selection
selected_name=$(create_wallpaper_list | rofi -dmenu -i -p "🎨 Select wallpaper" \
    -show-icons \
    -theme ~/.config/rofi/wallpaper-picker.rasi)

if [[ -n "$selected_name" ]]; then
    # Remove icon part and get full path
    selected_name=$(echo "$selected_name" | cut -d$'\x1f' -f1)
    selected=$(find "$WALLPAPER_DIR" -name "$selected_name" -type f)
    
    if [[ -n "$selected" ]]; then
    swww img $selected --transition-type any --transition-step 20 --transition-fps 60
    cp "$selected" "$HOME/.cache/current_wallpaper/last-wallpaper"
    echo "$selected" > "$CURRENT_WALLPAPER"
    /home/god/.config/Scripts/light-mode.sh
    fi
fi
