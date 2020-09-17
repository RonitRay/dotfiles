#!/usr/bin/env bash
set -euo pipefail

PACMAN_UPDATES="$(pacman -Qu|wc -l)"
AUR_UPDATES="$(yay -Qau|wc -l)"

if [ "$PACMAN_UPDATES" -ne 0 ]
then
    MSG="UPDATES: $PACMAN_UPDATES"
fi

if [ "$AUR_UPDATES" -ne 0 ]
then
    MSG="$MSG, AUR: $AUR_UPDATES"
fi

echo "$MSG"
