if [ -f "$HOME/.profile" ]; then
    . "$HOME/.profile"
elif [ -f "$HOME/.config/rbshellrc/rbshell.sh" ]; then
    . "$HOME/.config/rbshellrc/rbshell.sh" login
fi
