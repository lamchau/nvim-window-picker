#!/usr/bin/env bash

# macOS/homebrew:
#  - hardcoded via `man` -> /opt/homebrew/Cellar/toilet/0.3/share/figlet
#  - dynamic: `ls $(realpath $(which toilet)"/../../share/figlet")`
# Linux: /usr/share/figlet

# render fonts using their own name
find "$1" -type f|
    sort -V |
    xargs -n1 bash -c 'basename "${1%.*}"' bash |
    xargs -n1 bash -c '
        printf "\nfont: %s\n" "$1"
        toilet \
            --font "$(basename ${1%.*})" \
            --filter crop \
            --termwidth "${1%.*}" || true' bash
