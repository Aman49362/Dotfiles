#!/bin/bash

## SETTING SYSTEM THEME
gsettings set org.gnome.desktop.interface icon-theme "'Papirus-Light'"
gsettings set org.gnome.desktop.interface color-scheme "'prefer-light'"

## SETTING MATUGEN COLORS
matugen image $HOME/.wallpapers/current_wallpaper/last-wallpaper --mode light 
## SETTING PYWAL16 COLORS
wal -i $HOME/.wallpapers/current_wallpaper/last-wallpaper -l -n 

## SETTING TELEGRAM COLORS
walogram

gsettings set org.gnome.desktop.interface gtk-theme "'adw-gtk3'"