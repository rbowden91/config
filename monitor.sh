#!/usr/bin/env bash
# https://frdmtoplay.com/i3-udev-xrandr-hotplugging-output-switching/

HN="$(hostname)"

# TODO: when the monitor switches PBP mode, xrandr seems to briefly go out of sync with the card state
while (grep -q 'HDMI-A-0 connected' <(xrandr) &&
    [ "$(</sys/class/drm/card0/card0-HDMI-A-1/status)" = "disconnected" ]) ||
    (grep -q 'HDMI-A-0 disconnected' <(xrandr) &&
    [ "$(</sys/class/drm/card0/card0-HDMI-A-1/status)" = "connected" ]) ; do
    sleep .1
done

MONITOR_STATUS=$([ "$(</sys/class/drm/card0/card0-HDMI-A-1/status)" = "connected" ])$?
TV_STATUS=$([ "$(</sys/class/drm/card0/card0-HDMI-A-2/status)" = "connected" ])$?

if [ $MONITOR_STATUS -eq 0 -a $TV_STATUS -eq 0 ]; then
    /usr/bin/xrandr --output HDMI-A-1 --left-of HDMI-A-0 --auto
elif [ $MONITOR_STATUS -eq 0 ]; then
    /usr/bin/xrandr --output HDMI-A-0 --auto
elif [ $TV_STATUS -eq 0 ]; then
    /usr/bin/xrandr --output HDMI-A-1 --auto
fi

#i3-msg "workspace 6, move workspace to output DP2"

