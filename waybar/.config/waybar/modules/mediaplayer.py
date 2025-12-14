#!/usr/bin/env python3
import sys
import json
import argparse
import subprocess
import time

def get_media_info(player):
    try:
        # Check if player exists
        players = subprocess.check_output(["playerctl", "--list-all"], stderr=subprocess.DEVNULL, text=True)
        if player not in players:
            return {"text": "", "class": "stopped"}
        
        # Get player status
        status = subprocess.check_output(
            ["playerctl", "--player", player, "status"], 
            stderr=subprocess.DEVNULL, text=True
        ).strip()
        
        if status != "Playing":
            return {"text": "", "class": "stopped"}
        
        # Get metadata safely
        metadata = subprocess.check_output(
            ["playerctl", "--player", player, "metadata", "--format", "{{artist}}|||{{title}}"],
            stderr=subprocess.DEVNULL, text=True
        ).strip()
        
        if not metadata or metadata == "|||":
            return {"text": "Unknown Song", "class": "playing"}
        
        # Split artist and title
        parts = metadata.split("|||", 1)
        artist = parts[0].strip() if len(parts) > 0 and parts[0] else "Unknown Artist"
        title = parts[1].strip() if len(parts) > 1 and parts[1] else "Unknown Title"
        
        # Clean and truncate
        display_text = f"{artist} - {title}"
        if len(display_text) > 35:
            display_text = display_text[:32] + "..."
        
        return {"text": display_text, "class": "playing"}
        
    except subprocess.CalledProcessError:
        return {"text": "", "class": "stopped"}
    except Exception as e:
        return {"text": "Error", "class": "error"}

def main():
    parser = argparse.ArgumentParser(description='Media player info for Waybar')
    parser.add_argument('--player', default='spotify', help='Player name (default: spotify)')
    args = parser.parse_args()
    
    last_output = ""
    while True:
        media_info = get_media_info(args.player)
        current_output = json.dumps(media_info)
        
        # Only output if something changed
        if current_output != last_output:
            print(current_output, flush=True)
            last_output = current_output
        
        time.sleep(1)  # Check every second

if __name__ == "__main__":
    main()