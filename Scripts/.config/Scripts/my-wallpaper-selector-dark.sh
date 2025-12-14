#!/bin/bash

CACHE_ROOT=~/.wallpapers/cached_imgs
WALLPAPER_ROOT=~/.wallpapers
CURRENT_WALLPAPER="$HOME/.wallpapers/current_wallpaper/wallpaper.txt"

mapfile -t originPath < <(find ${WALLPAPER_ROOT} -maxdepth 1 -type f)
mapfile -t cachedPath < <(find ${CACHE_ROOT} -maxdepth 1 -type f)
declare -A bgresult
declare -A cachedresult

bgnames=()

function cacheImg {
    resolution=$(ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=p=0 $1)
    width_=$(echo "${resolution}" | awk -F',' '{print $1}')
    height_=$(echo "${resolution}" | awk -F',' '{print $2}')
    if [ "${width_}" -lt "${height_}" ]
    then
        ffmpeg -i $1 -loglevel quiet -vf  "scale=600:-1, crop=600:600:0:(iw-600)/2" $2
    else
        ffmpeg -i $1 -loglevel quiet -vf  "scale=-1:600, crop=600:600:(iw-600)/2:0" $2
    fi
    echo $2
}

function getFileName {
    echo "$1" | xargs basename | awk -F'.' '{print $1}'
}

for pathIDX in "${!originPath[@]}"; do
    filename=$(getFileName "${originPath[$pathIDX]}")
    bgresult["${filename}"]="${originPath[$pathIDX]}"
    bgnames[$pathIDX]+="${filename}"
done


for pathIDX in "${!cachedPath[@]}"; do
    filename=$(getFileName "${cachedPath[$pathIDX]}")
    cachedresult["${filename}"]="${cachedPath[$pathIDX]}"
done


for fName in "${bgnames[@]}"; do
    if [[ -v cachedresult[$fName] ]] 
    then
        :
    else
        cachedresult[$fName]=$(cacheImg "${bgresult[$fName]}" "${CACHE_ROOT}/${fName}.png")
    fi
done

strrr=""
for fName in "${bgnames[@]}"; do
    strrr+="$(echo -n "${fName}\0icon\x1f${cachedresult[$fName]}\n")"
done

selected=$(echo -en "${strrr}" | rofi -dmenu -no-layers -p "search" -config /home/god/.config/rofi/wallpaper-picker.rasi )
swww img "${bgresult[$selected]}" --transition-type any --transition-step 20 --transition-fps 60

## Save selection
echo "${bgresult[$selected]}" > "$CURRENT_WALLPAPER"
cp "${bgresult[$selected]}" "$HOME/.wallpapers/current_wallpaper/last-wallpaper"

## Apply colors
## SETTING SYSTEM THEME
gsettings set org.gnome.desktop.interface icon-theme "'Papirus'"
gsettings set org.gnome.desktop.interface color-scheme "'prefer-dark'"

## SETTING MATUGEN COLORS
matugen image $HOME/.wallpapers/current_wallpaper/last-wallpaper --mode dark 
## SETTING PYWAL16 COLORS
wal -i $HOME/.wallpapers/current_wallpaper/last-wallpaper -n 

## SETTING TELEGRAM COLORS
walogram

gsettings set org.gnome.desktop.interface gtk-theme "'adw-gtk3-dark'"