#!/bin/bash

shortcuts="Super + Enter         Terminal
Super + Space         App launcher
Super + Shift + Q     Close window
Super + Shift + C     Reload config
Super + Shift + E     Power menu
Super + Shift + /     Shortcuts (this)
Super + F2            Brightness up
Super + F3            Brightness down
Super + H/J/K/L       Focus left/down/up/right
Super + Shift + H/J/K/L   Move window
"

echo "$shortcuts" | wofi --width 400 --height 350 --dmenu --cache-file /dev/null --prompt "Shortcuts" --define=hide_search=true
