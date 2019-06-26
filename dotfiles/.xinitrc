/bin/cat "$HOME/.config/i3/config.base" > "$HOME/.config/i3/config"
if [ -f "$HOME/.config/i3/local_configs/$HOSTNAME" ]; then
    /bin/cat "$HOME/.config/i3/local_configs/$HOSTNAME" >> "$HOME/.config/i3/config"
fi
xmodmap "$HOME/.xmodmap"
numlockx on
xset s off # turn off screensaver
xset -dpms # turn off energy saver (Energy Star)
exec /usr/bin/i3
