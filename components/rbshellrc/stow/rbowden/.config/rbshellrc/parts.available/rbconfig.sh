#/usr/bin/env bash

rbconfig () {
    local operation="$1"
    local component="$2"
    # replace any special regex characters with '.' (so they're always matched).
    # It's not perfect, but good enough.
    cd "$HOME/.config/rbshellrc/"
    case $operation in
        enable)
            ln -s parts.available/$operation parts.enabled/
    esac
}

alias rbconfig='. rbconfig()'
