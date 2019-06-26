#!/usr/bin/env bash

insidecolor=00000000
ringcolor=ffffffff
keyhlcolor=d23c3dff
bshlcolor=d23c3dff
separatorcolor=00000000
insidevercolor=00000000
insidewrongcolor=d23c3dff
ringvercolor=ffffffff
ringwrongcolor=ffffffff
verifcolor=ffffffff
timecolor=ffffffff
datecolor=ffffffff
loginbox=00000066
font="sans-serif"
locktext='Type password to unlock...'

tmpdir="/tmp/lock.png"
res=$(xdpyinfo | grep dimensions: | tr -s ' ' | cut -d ' ' -f 3)
ffmpeg -loglevel quiet -f x11grab -video_size "${res}" -y -i $DISPLAY -filter_complex "boxblur=10" -vframes 1 -c:v png -f rawvideo -an - > "${tmpdir}"

i3lock \
-t -i "${tmpdir}" \
	--indpos='x+280:h-70' \
	--date-align 1 \
	--datepos='x+50:h-73' \
	--datecolor="$datecolor" \
	--datestr="%A, %B %d, %Y" \
	--date-font="$font" \
	--time-align 1 \
	--timepos='x+50:h-100' \
	--timestr='%I:%M:%S %p' \
	--timecolor="$timecolor" \
	--time-font="$font" \
	--greetertext="${locktext}" \
	--greetercolor="${timecolor}" \
	--greeter-font="${font}" \
	--greetersize="14" \
	--greeterpos='x+50:h-50' \
	--greeter-align 1 \
	--veriftext='' \
	--verifcolor="$verifcolor" \
	--verif-font="$font" \
	--wrongtext='' \
	--wrong-font="$font" \
	--layout-font="$font" \
	--clock \
	--insidecolor=$insidecolor --ringcolor=$ringcolor --line-uses-inside \
	--keyhlcolor=$keyhlcolor --bshlcolor=$bshlcolor --separatorcolor=$separatorcolor \
	--insidevercolor=$insidevercolor --insidewrongcolor=$insidewrongcolor \
	--ringvercolor=$ringvercolor --ringwrongcolor=$ringwrongcolor \
	--radius=20 --ring-width=4 \
	--noinputtext='' --force-clock
