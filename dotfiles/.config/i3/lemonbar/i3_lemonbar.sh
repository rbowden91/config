#!/bin/bash
#
# Input parser for i3 bar
# 14 ago 2015 - Electro7
panel_fifo="/var/run/user/$UID/i3_lemonbar_fifo"
geometry="x24"
font='Terminess Powerline:style=Regular-24'
iconfont='FontAwesome:style=Regular-24'

# color definitions
color_back="#FF1D1F21"              # Default background
color_fore="#FFC5C8C6"              # Default foreground
color_head="#FFB5BD68"              # Background for first element
color_sec_b1="#FF282A2E"            # Background for section 1
color_sec_b2="#FF454A4F"            # Background for section 2
color_sec_b3="#FF60676E"            # Background for section 3
color_icon="#FF979997"              # For icons
color_mail="#FFCE935F"              # Background color for mail alert
color_chat="#FFCC6666"              # Background color for chat alert
color_cpu="#FF5F819D"               # Background color for cpu alert
color_net="#FF5E8D87"               # Background color for net alert
color_disable="#FF1D1F21"           # Foreground for disable elements
color_wsp="#FF8C9440"               # Background for selected workspace

if [ $(pgrep -cx $(basename $0)) -gt 1 ] ; then
    printf "%s\n" "The status bar is already running." >&2
    exit 1
fi

trap 'trap - TERM; kill 0' INT TERM QUIT EXIT

[ -e "${panel_fifo}" ] && rm "${panel_fifo}"
mkfifo "${panel_fifo}"

# Event Listeners

# Window title, "WIN"
xprop -spy -root _NET_ACTIVE_WINDOW | sed -un 's/.*\(0x.*\)/WIN\1/p' | while read -r line
do
    # window title
    title=$(xprop -id ${line#???} | awk '/_NET_WM_NAME/{$1=$2="";print}' | cut -d'"' -f2)
    title="%{F${color_head} B${color_sec_b2}}%{F${color_head} B${color_sec_b2} T2} ${icon_prog} %{F${color_sec_b2} B-}%{F- B- T1} ${title}"
    printf "%s\n" "export WIN='$title'"
done > "${panel_fifo}" &

# i3 Workspaces, "WSP"
$(dirname $0)/i3_workspaces.py | while read -r line
do
      wsp="%{F${color_back} B${color_head}} %{T2}${icon_wsp}%{T1}"
      set -- ${line#???}
      while [ $# -gt 0 ] ; do
        case $1 in
         FOC*)
           wsp="${wsp}%{F${color_head} B${color_wsp}}%{F${color_back} B${color_wsp} T1} ${1#???} %{F${color_wsp} B${color_head}}"
           ;;
         INA*|URG*|ACT*)
           #wsp="${wsp}%{F${color_disable} T1} %{A:i3-msg 'workspace "${1#???}"' &:}${1#???} %{A} "
           wsp="${wsp}%{F${color_disable} T1} ${1#???} "
           ;;
        esac
        shift
      done
      printf "%s\n" "export WSP='${wsp}'"
done > "${panel_fifo}" &

# Conky, "CONK". Controls system stuff, as well as anything
# that is checked at given intervals
conky -c $(dirname $0)/i3_lemonbar_conky > "${panel_fifo}" &

# min init
title="%{F${color_head} B${color_sec_b2}}%{F${color_head} B${color_sec_b2}%{T2} ${icon_prog} %{F${color_sec_b2} B-}%{F- B- T1}"

while read -r line
do
    eval "${line}"

    # Output for lemonbar
    #printf "%s\n" "%{S1}%{l}${WSP}${WIN} %{c}${CPU}${MEM}${FS}${DISK}${LOAD}${CAL}${TIME}%{SEC} %{r}%{A:google-chrome &:}       %{A}"
    printf "%s\n" "%{S1}%{l}${WSP}${WIN} %{c}${CAL}%{A:echo -e 'export TIME=\n' > \"${panel_fifo}\" &:}${TIME}%{A} %{r}%{A:google-chrome &:}       %{A}"

done < "${panel_fifo}" | \
lemonbar -p -f "${font}" -f "${iconfont}" -g "${geometry}" \
	    -B "${color_back}" -F "${color_fore}" |
while read -r line
do
    eval "${line}"
done
