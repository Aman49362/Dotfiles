#!/bin/bash

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