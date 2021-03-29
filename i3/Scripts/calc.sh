#!/usr/bin/env bash

# Simplified and less universal version of 
#   https://github.com/onespaceman/menu-calc
# Main changes:
# * removes logic for checking menu program and uses rofi directly
# * removes redundant close option, Esc is enough
# * makes it actually use the "clipboard" clipboard and not primary
# only like 10 SLOC.

# menu="rofi -dmenu -location 1 -width 100 -lines 2"
menu="dmenu -l 2"
answer=$(echo "$@" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')

action=$(echo -e "Copy to clipboard\nClear" |
$menu -p "= $answer")

case $action in
    "Clear") $0 ;;
    "Copy to clipboard") echo -n "$answer" | xclip -selection clipboard -r;;
    "") ;;
    *) $0 "$answer $action" ;;
esac
