/bin/cat "$HOME/.config/i3/config.base" > "$HOME/.config/i3/config"
if [ -f "$HOME/.config/i3/local_configs/config.$HOSTNAME" ]; then
    /usr/bin/cat "$HOME/.config/i3/local_configs/config.$HOSTNAME" >> "$HOME/.config/i3/config"
fi
exec /usr/bin/i3
