#!/usr/bin/env bash
set -euo pipefail

choices="Logout\nShutdown\nRestart"

chosen=$(echo -e "$choices" | rofi -i -dmenu -matching normal -location 1 -width 100 -lines 3 -p 'Choose')

case "$chosen" in
    Logout)
        i3-msg exit ;;
    Shutdown)
        shutdown now ;;
    Restart)
        shutdown -r now ;;
esac
