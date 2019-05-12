#!/usr/bin/env bash
# tested on Ubuntu 18.04

set -e

function add_to_file () {
    local file="$1"
    # replace any special regex characters with '.' (so they're always matched). Not perfect, but good enough.
    local input="$2"
    local search="$(echo "$input" | tr '|[]^.$()' '.')"
    touch "$file"
    if ! pcregrep -Mq "$search" "$file"; then
	# use the below instead of `echo "$input" >> "$file"`
    	# because some files need root permission to be modified
	echo "$input" | sudo tee -a "$file"
    fi
}

mkdir -p /tmp/config_install


sudo apt update
sudo apt install -y --show-progress curl wget screen tmux openssh-server net-tools git pcregrep
git config --global user.name "Rob Bowden"
git config --global user.email "rbowden91@gmail.com"
git config --global push.default simple

add_to_file ~/.bashrc $(cat <<-'EOF'
	export TERMINAL='termite'
	export EDITOR='vim'
EOF
)

mkdir -p ~/repos
#git clone https://github.com/rbowden91/config ~/repos/config
cd ~/repos/config
git remote set-url --push origin git@github.com:rbowden91/config

# vim
curl https://raw.githubusercontent.com/rbowden91/vimrc/master/install.sh | sh
cd ~/.vim
git remote set-url --push origin git@github.com:rbowden91/vimrc

mkdir -p ~/bin ~/.local/bin
# putting the `-` after `<<` allows you to put tabs for formatting that will be ignored
# putting `'` around `EOF` makes it so variables aren't interpolated
add_to_file ~/.profile "$(cat <<-'EOF'
	# set PATH so it includes user's private bin if it exists
	if [ -d "$HOME/.local/bin" ] ; then
	    PATH="$HOME/.local/bin:$PATH"
	fi
EOF
)"
add_to_file ~/.profile "$(cat <<-'EOF'
	# set PATH so it includes user's private bin if it exists
	if [ -d "$HOME/bin" ] ; then
	    PATH="$HOME/bin:$PATH"
	fi
EOF
)"
source ~/.profile
#
# Chrome
if ! sudo apt list 2> /dev/null | grep -q 'google-chrome-stable'; then
    wget -O /tmp/config_install/chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo apt install -y --show-progress /tmp/config_install/chrome.deb
fi
xdg-settings set default-web-browser google-chrome.desktop

# Dropbox
sudo apt install -y --show-progress python3-gpg
if [ ! -d ~/.dropbox-dist ]; then
    cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
fi
if [ ! -f ~/bin/dropbox ]; then
    wget -O ~/bin/dropbox 'https://www.dropbox.com/download?dl=packages/dropbox.py'
    chmod 700 ~/bin/dropbox
fi

if [ ! $(dropbox running) ]; then
    sudo pkill -9 dropbox
    dropbox start &> /dev/null
fi
chmod 664 ~/repos/config/dropbox.service
sudo ln ~/repos/config/dropbox.service /etc/systemd/system/
sudo systemctl enable dropbox.service
ln -s ~/'Dropbox (CS50)'/rob/identity/ssh ~/.ssh
add_to_file ~/.bashrc "alias db='cd \$HOME/\"Dropbox (CS50)\"'"
# TODO: change this to detect when things have gone through

wait_for_login () {
    status=$(dropbox status)
    if grep -Fq 'Connecting...' <<< "$status"; then
    	echo 'Waiting for dropbox to start...'
	return 1
    fi
    link="$(echo "$status" | grep -F 'https://')"
    if [ ! -z "$link" ]; then
	echo "Waiting for user to link dropbox at $link"
	return 1
    fi
    return 0
}

while ! wait_for_login; do
    sleep 3
done
dropbox exclude add Apps nick Screenshots shared rob/selective

# Spotify
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 931FF8E79F0876134EDDBDCCA87FF9DF48BF1C90
add_to_file '/etc/apt/sources.list.d/spotify.list' 'deb http://repository.spotify.com stable non-free'
sudo apt update
sudo apt install -y --show-progress spotify-client

# TeamViewer
if ! sudo apt list 2> /dev/null | grep -q 'teamviewer.*installed'; then
    wget -O /tmp/config_install/teamviewer.deb https://download.teamviewer.com/download/linux/teamviewer_amd64.deb
    sudo apt install -y --show-progress /tmp/config_install/teamviewer.deb
fi

# virtualenv
if [ ! -d ~/bin/venv ]; then
    sudo apt install -y --show-progress python3.6 python3-pip
    pip3 install --user virtualenv
    virtualenv --python=`which python3.6` ~/bin/venv
fi
add_to_file ~/.bashrc "alias venv='source ~/bin/venv/bin/activate'"

 latex / zathura / vimtex / etc.
sudo apt install -y --show-progress texlive-full libsynctex-dev libgtk-3-dev \
    libmagic-dev xdotool check intltool sqlite3 check ninja-build \
    python3.6 python3-pip poppler-utils libpoppler-glib-dev
pip3 install --user docutils meson


for i in girara zathura-pdf-poppler zathura; do
    cd /tmp/config_install
    git clone https://git.pwmt.org/pwmt/$i.git
    cd $i
    git checkout --track -b develop origin/master
    mkdir build
    meson build
    cd build
    # https://bugs.pwmt.org/project/girara/issue/34
    meson configure -Dlibdir=lib -Dplugindir=/usr/local/lib/zathura
    ninja
    sudo ninja install
done
sudo ldconfig
mkdir -p ~/.local/share/applications
# TODO: may need to replace a prior application/pdf line?
add_to_file ~/.local/share/applications/defaults.list 'application/pdf=zathura.desktop'

chmod 700 ~/repos/config/monitor.sh
if [ ! -f /etc/udev/rules.d/98-monitor-hotplug.rules ]; then
    echo <<-EOF |
KERNEL=="card0", SUBSYSTEM=="drm", ACTION=="change", ENV{DISPLAY}=":0", ENV{XAUTHORITY}="$HOME/.Xauthority", RUN+="$HOME/repos/config/monitor.sh"
EOF
    sudo tee -a /etc/udev/rules.d/98-monitor-hotplug.rules
fi

# TODO: what does this do?
# https://wikimatze.de/vimtex-the-perfect-tool-for-working-with-tex-and-vim/
cd /tmp/config_install
wget http://users.phys.psu.edu/%7Ecollins/software/latexmk-jcc/latexmk-445.zip
unzip latexmk*.zip
sudo cp latexmk/latexmk.pl /usr/local/bin/latexmk

 ssh-ident
sudo dpkg-divert --divert /usr/bin/ssh.ssh-ident --rename /usr/bin/sshfifi
sudo wget -O /usr/bin/ssh https://raw.githubusercontent.com/ccontavalli/ssh-ident/master/ssh-ident
sudo chmod 755 /usr/bin/ssh
add_to_file ~/.bashrc $(cat <<-'EOF'
	export BINARY_SSH="/usr/bin/ssh.ssh-ident"
	export DIR_AGENTS='$HOME/.ssh_agents'
	export SSH_DEFAULT_OPTIONS='-A'
EOF
)

# pushover
# https://mikebuss.com/2014/01/03/push-notifications-cli/
add_to_file ~/.bashrc $(cat <<-'EOF'
function push () {
    curl -s -F "token=a42feki7f68hvnqnqwpu7bjwjrv5fx" \
	-F "user=uoo537r5jdq62sg8p545oa4vgbd3gs" \
	-F "title=YOUR_TITLE_HERE" \
	-F "message=$1" https://api.pushover.net/1/messages.json
}
EOF
)

# install vte-ng (for termite)
sudo apt install -y --show-progress git g++ libgtk-3-dev gtk-doc-tools gnutls-bin valac intltool libpcre2-dev libglib3.0-cil-dev libgnutls28-dev libgirepository1.0-dev libxml2-utils gperf
cd /tmp/config_install
git clone https://github.com/thestinger/vte-ng.git
export LIBRARY_PATH="/usr/include/gtk-3.0:$LIBRARY_PATH"
cd vte-ng
./autogen.sh
make && sudo make install


# install termite
cd /tmp/config_install
git clone --recursive https://github.com/thestinger/termite.git
cd termite
make
sudo make install
sudo ldconfig
sudo mkdir -p /lib/terminfo/x
sudo ln -s /usr/local/share/terminfo/x/xterm-termite /lib/terminfo/x/xterm-termite
sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator /usr/local/bin/termite 60

# i3-gaps
sudo apt install -y --show-progress libxcb1-dev libxcb-keysyms1-dev
    libpango1.0-dev libxcb-util0-dev libxcb-icccm4-dev libyajl-dev \
    libstartup-notification0-dev libxcb-randr0-dev \
    libev-dev libxcb-cursor-dev libxcb-xinerama0-dev \
    libxcb-xkb-dev libxkbcommon-dev libxkbcommon-x11-dev \
    autoconf libxcb-xrm0 libxcb-xrm-dev automake
git clone https://www.github.com/Airblader/i3 /tmp/config_install/i3-gaps
cd /tmp/config_install/i3-gaps
autoreconf --force --install
rm -rf build/
mkdir -p build && cd build/
../configure --prefix=/usr --sysconfdir=/etc --disable-sanitizers
make
sudo make install

# lemonbar for i3
# TODO XXX
#sudo rm /etc/fonts/conf.d/70-no-bitmaps.conf
#mkdir -p ~/.fonts
#cp -r .fonts/* ~/.fonts/
#fc-cache -f
#git clone https://github.com/krypt-n/bar.git
#cd bar
#make
#sudo make install

# https://github.com/hastinbe/i3-volume
# git clone https://github.com/hastinbe/i3-volume.git ~/i3-volume

# TODO: OSX
# https://github.com/junegunn/fzf#installation
#brew install fzf
# To install useful key bindings and fuzzy completion:
#$(brew --prefix)/opt/fzf/install

#git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
#yes | ~/.fzf/install
#
#if [ ! -d ~/.tmux/plugins/tpm ]; then
#    mkdir -p ~/.tmux/plugins
#    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
#fi

# pavucontrol (volume)
# xclip (for tmux copy-paste)

rm -rf /tmp/config_install
