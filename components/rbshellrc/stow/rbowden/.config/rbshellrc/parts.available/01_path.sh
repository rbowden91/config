# set PATH so it includes user's private bins, if they exist
if [ -d "$HOME/bin" ] ; then
    export PATH="$HOME/bin:$PATH"
fi
if [ -d "$HOME/.local/bin" ] ; then
    export PATH="$HOME/.local/bin:$PATH"
fi

# necessary so that gpg appropriately asks for password when SSH'd into the machine
# export GPG_TTY=$(tty) export PINENTRY_USER_DATA="USE_CURSES=1"
