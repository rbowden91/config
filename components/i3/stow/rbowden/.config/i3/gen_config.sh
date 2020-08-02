#/bin/sh
cd ~/.config/i3
if [ -f config ]; then
    cp config config.old
fi
cat conf.d/*.conf > config

if [ -z "$HOSTNAME" ]; then
    # $HOST also exists?
    HOSTNAME="$(hostname)"
fi
if [ -d conf.d/local_config/"$HOSTNAME" ]; then
    cat conf.d/local_config/"$HOSTNAME"/* >> config
fi
