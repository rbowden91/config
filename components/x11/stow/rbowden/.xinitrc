# start with numlock on
numlockx on

# high dpi
xrdb -merge ~/.Xresources
xrandr --dpi 192

# caps lock to escape
xmodmap ~/.xmodmap

# turn off screen saver, energy saver (Energy Star), and bell
xset s off
xset -dpms
xset -b

# Fix the touchpad speed
# Something for this could also go in something like:
# /usr/lib/udev/rules.d/
xinput set-prop "SynPS/2 Synaptics TouchPad" "libinput Accel Speed" 0.8

# Generate i3 config and start i3
~/.config/i3/gen_config.sh
exec /usr/bin/i3


#xset led named "Scroll Lock"
#xset led 3
#exec /usr/bin/i3 --shmlog-size=26214400

