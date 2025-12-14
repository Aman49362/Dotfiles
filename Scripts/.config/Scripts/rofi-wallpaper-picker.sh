#!/bin/bash

WALLPAPER_DIR="$HOME/git/wallpaper/Wallpaper-Bank/wallpapers"
CURRENT_WALLPAPER="$HOME/.cache/current_wallpaper"
# DISCORD_CSS="$HOME/.config/BetterDiscord/themes/pywal-discord.theme.css"

# Get list of wallpapers
wallpapers=$(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" -o -name "*.webp" \) | sort)

# Use Rofi to select wallpaper
selected=$(echo "$wallpapers" | rofi -dmenu -i -p "🎨 Select wallpaper" -theme ~/.config/rofi/wallpaper/wallpaper-picker.rasi)

if [[ -n "$selected" ]]; then
    echo "Applying: $(basename "$selected")"
    
    # Set wallpaper with swww
    swww img "$selected" --transition-type any --transition-step 20 --transition-fps 60
    
    # Store current wallpaper
    echo "$selected" > "$CURRENT_WALLPAPER"
fi

    # 1. Update Matugen colors
    matugen image "$selected" --mode light
    
    # 2. Update pywal
    wal -i "$selected" -n
    
    # 3. Update Telegram theme
    update_telegram_theme
    
    # 4. Update Spicetify
    update_spicetify
    
    # 5. Update BetterDiscord
    update_betterdiscord
    
    notify-send "Theme Updated" "Wallpaper and colors applied successfully!" -i "$wallpaper"
}

update_telegram_theme() {
    if [[ -f "$HOME/.telegram-palette-gen/telegram-palette-gen" ]]; then
        "$HOME/.telegram-palette-gen/telegram-palette-gen" -o
    elif command -v pywal-telegram &> /dev/null; then
        pywal-telegram
    fi
}

update_spicetify() {
    if command -v spicetify &> /dev/null; then
        spicetify config current_theme pywal
        spicetify config color_scheme base
        spicetify apply
    fi
}

update_betterdiscord() {
    # Wait a bit for pywal to generate colors
    sleep 1
    
    # Source pywal colors
    if [[ -f "$HOME/.cache/wal/colors.sh" ]]; then
        source "$HOME/.cache/wal/colors.sh"
        
        # Create BetterDiscord theme CSS
        cat > "$DISCORD_CSS" << EOF
/**
 * Pywal Discord Theme
 * Generated automatically from wallpaper
 */

:root {
    --pywal-background: $background;
    --pywal-foreground: $foreground;
    --pywal-color0: $color0;
    --pywal-color1: $color1;
    --pywal-color2: $color2;
    --pywal-color3: $color3;
    --pywal-color4: $color4;
    --pywal-color5: $color5;
    --pywal-color6: $color6;
    --pywal-color7: $color7;
    --pywal-color8: $color8;
    --pywal-color9: $color9;
    --pywal-color10: $color10;
    --pywal-color11: $color11;
    --pywal-color12: $color12;
    --pywal-color13: $color13;
    --pywal-color14: $color14;
    --pywal-color15: $color15;
}

.theme-dark {
    --background-primary: var(--pywal-background);
    --background-secondary: var(--pywal-color0);
    --background-secondary-alt: var(--pywal-color8);
    --background-tertiary: var(--pywal-color0);
    --background-accent: var(--pywal-color4);
    --background-floating: var(--pywal-color8);
    --channeltextarea-background: var(--pywal-color0);
    --header-primary: var(--pywal-foreground);
    --header-secondary: var(--pywal-color7);
    --text-normal: var(--pywal-foreground);
    --text-muted: var(--pywal-color7);
    --interactive-normal: var(--pywal-color7);
    --interactive-hover: var(--pywal-foreground);
    --interactive-active: var(--pywal-foreground);
    --interactive-muted: var(--pywal-color8);
}

/* Scrollbars */
.scrollbar-2rkZSL {
    background: var(--pywal-color0) !important;
}

.thumb-2JwNFC {
    background: var(--pywal-color4) !important;
}

/* Server list */
.guilds-1SWlCJ {
    background: var(--pywal-color0) !important;
}

/* Message area */
.chat-3bRxxu {
    background: var(--pywal-background) !important;
}

/* Settings sidebar */
.sidebarRegion-VFTUkN {
    background: var(--pywal-color0) !important;
}

/* Buttons */
.lookFilled-1Gx00P.colorBrand-3pXr91 {
    background-color: var(--pywal-color4) !important;
}

.lookFilled-1Gx00P.colorBrand-3pXr91:hover {
    background-color: var(--pywal-color12) !important;
}
EOF
        
        echo "BetterDiscord theme updated at: $DISCORD_CSS"
    else
        echo "Pywal colors not found. Skipping BetterDiscord update."
    fi
}