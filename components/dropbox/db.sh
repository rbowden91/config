#!/bin/bash
set -e

sudo apt install -y --show-progress python3-gpg
if [ ! -d ~/.dropbox-dist ]; then
    cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
fi
if [ ! -f ~/.local/bin/dropbox ]; then
    wget -O ~/.local/bin/dropbox 'https://www.dropbox.com/download?dl=packages/dropbox.py'
    chmod 700 ~/.local/bin/dropbox
fi

export PATH="$HOME/.local/bin:$PATH"

#if [ ! $(dropbox running) ]; then
#    # make sure you don't kill the current script! That's why this is called "db.sh"
#    # TODO: enforce this
#    sudo pkill -9 dropbox &> /dev/null || true
#    dropbox start &> /dev/null
#fi
#chmod 664 ${CONFIG}/dropbox.service
#sudo ln ${CONFIG}/config/dropbox.service /etc/systemd/system/
#sudo systemctl enable dropbox.service
#dropbox autostart y
#dropbox start
# TODO: probably move this if it exists to, e.g., .ssh-old
#ln -s ~/'Dropbox (CS50)'/rob/identity/ssh ~/.ssh
#ln -s ~/'Dropbox (CS50)'/rob/wallpapers ~/.wallpapers
#add_to_file ~/.generic_profile "alias db='cd \${HOME}/\"Dropbox (CS50)\"'"

# TODO: change this to detect when things have gone through

wait_for_login () {
    status=$(dropbox status)
    if grep -Fq 'Connecting...' <<< "$status"; then
	echo 'Waiting for dropbox to start...'
	return 1
    fi
    link="$(echo "${status}" | grep -F 'https://')"
    if [ ! -z "${link}" ]; then
	echo "Waiting for user to link dropbox at ${link}"
	return 1
    fi
    return 0
}

#while ! wait_for_login; do
#    sleep 3
#done
# TODO: while this directory doesn't exist...
#cd "$HOME/Dropbox (CS50)/"
# TODO: do the directories have to exist first??
#dropbox exclude add Apps nick Screenshots shared rob/selective
