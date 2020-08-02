# Prefix with 00 so it always gets included early on.

# FIXME: This is all currently platform-specific...
XDG_DATA_HOME="$HOME/.local/share"
XDG_CONFIG_HOME="$HOME/.config"
XDG_DATA_DIRS="/usr/local/share/:/usr/share/"
XDG_CONFIG_DIRS="/etc/xdg"
XDG_CACHE_HOME="$HOME/.cache"
XDG_RUNTIME_DIR="/run/user/$(id -u)"
