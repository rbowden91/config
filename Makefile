.ONESHELL:

#sudo add-apt-repository ppa:landronimirc/skippy-xd-daily
#sudo apt update
#sudo apt install skippy-xd
#libjpeg-dev libgif-dev


# sudo apt install progress

# https://go.skype.com/skypeforlinux-64.deb

# sshfs
# screenshots/xwd: http://blog.tordeu.com/?p=135%20screenshots
# ntfy: https://github.com/dschep/ntfy
# bash-preexec: https://github.com/rcaloras/bash-preexec
# xmodmap: https://cs.gmu.edu/~sean/stuff/n800/keyboard/old.html

#sudo apt-get install software-properties-common
#sudo add-apt-repository ppa:x2go/stable
#sudo apt-get update
#sudo apt-get install x2goserver x2goserver-xsession xbacklight redshift redshift-gtk
# jq

#sudo apt install mosh


# https://askubuntu.com/questions/51445/how-do-i-calibrate-a-touchscreen-on-a-dual-monitor-system
#pip3 install pywal

PREFIX:=${HOME}/repos/
CONFIGNAME:=rbconfig
CONFIG:=${PREFIX}${CONFIGNAME}
TMPDIR:=/tmp

#if [ -f /etc/os-release ]; then
#    # freedesktop.org and systemd
#    . /etc/os-release
#    OS=$NAME
#    VER=$VERSION_ID
#elif type lsb_release >/dev/null 2>&1; then
#    # linuxbase.org
#    OS=$(lsb_release -si)
#    VER=$(lsb_release -sr)
#elif [ -f /etc/lsb-release ]; then
#    # For some versions of Debian/Ubuntu without lsb_release command
#    . /etc/lsb-release
#    OS=$DISTRIB_ID
#    VER=$DISTRIB_RELEASE
#elif [ -f /etc/debian_version ]; then
#    # Older Debian/Ubuntu/etc.
#    OS=Debian
#    VER=$(cat /etc/debian_version)
#elif [ -f /etc/SuSe-release ]; then
#    # Older SuSE/etc.
#    ...
#elif [ -f /etc/redhat-release ]; then
#    # Older Red Hat, CentOS, etc.
#    ...
#else
#    # Fall back to uname, e.g. "Linux <version>", also works for BSD, etc.
#    OS=$(uname -s)
#    VER=$(uname -r)
#fi




#path := $(abspath $(lastword $(MAKEFILE_LIST)))
#current_dir := $(notdir $(patsubst %/,%,$(dir $(path))))
#
#test:
#	echo "$(path)"
#	echo "$(dir $(path))"
#	echo "$(patsubst %/,%,$(dir $(path)))"
#	echo "$(notdir $(patsubst %/,%,$(dir $(path))))"


base: local-bin
	git submodule init
	sudo apt update
	sudo apt install -y --show-progress curl wget screen net-tools git pcregrep
	sudo apt install -y git curl 
	# python, python3, pip, pip3

local-bin:
	mkdir -p ~/.local/bin
	# putting the `-` after `<<` allows you to put tabs for formatting that will be ignored
	#add_to_file ~/.profile "$(cat <<-'EOF'
	#	# set PATH so it includes user\'s private bin if it exists
	#	if [ -d "${HOME}/.local/bin" ] ; then #	    PATH="${HOME}/.local/bin:${PATH}"
	#	fi
	#EOF
	#)"


stow:
	#sudo apt -qq -y install stow
	#mkdir -p ~/.fonts
	#stow -d "${CONFIG}" -t ~ dotfiles
	stow -t ~ dotfiles
	#fc-cache -f


rbowden:
	cd "${CONFIG}"
	git remote set-url --push origin git@github.com:rbowden91/config
	cd subrepos/vimrc
	git remote set-url --push origin git@github.com:rbowden91/vimrc

#start:
#	if [ ! -d "${CONFIG}" ]; then
#	    mkdir -p "${PREFIX}"
#	    git clone https://github.com/rbowden91/config "${CONFIG}"
#	fi

remove-snap:
	sudo rm -rf /var/cache/snapd
	sudo apt autoremove --purge snapd gnome-software-plugin-snap
	rm -rf "${HOME}/snap"

rust:
	# TODO: didn't seem to work for Arch
	# <(...) is bash, not sure about other shells
	bash -c 'sh <(curl https://sh.rustup.rs -sSf) -y'
	#source ~/.cargo/env

mono:
	# takes a long time to install
	sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
	# TODO: use add_to_file
	echo "deb https://download.mono-project.com/repo/ubuntu stable-bionic main" | sudo tee /etc/apt/sources.list.d/mono-official-stable.list
	sudo apt update
	sudo apt install -y mono-complete

vimiv:
	sudo apt install -y libgexiv2-2
	DESTDIR="${HOME}" PREFIX="/.local" make -e install

vim: fzf rust local-bin mono
	# TODO
	true

chrome:
	if ! sudo apt list 2> /dev/null | grep -q 'google-chrome-stable'; then
	    wget -O "${TMPDIR}"/chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
	    sudo apt install -y --show-progress "${TMPDIR}"/chrome.deb
	fi
	# TODO: is this permanent?
	xdg-settings set default-web-browser google-chrome.desktop

dropbox: local-bin
	sh dropbox.sh

spotify:
	sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 931FF8E79F0876134EDDBDCCA87FF9DF48BF1C90
	add_to_file '/etc/apt/sources.list.d/spotify.list' 'deb http://repository.spotify.com stable non-free'
	sudo apt update
	sudo apt install -y --show-progress spotify-client

# worked on Ubuntu 20.04
teamviewer:
	if ! sudo apt list 2> /dev/null | grep -q 'teamviewer.*installed'; then
	    wget -O "${TMPDIR}"/teamviewer.deb https://download.teamviewer.com/download/linux/teamviewer_amd64.deb
	    sudo apt install -y --show-progress "${TMPDIR}"/teamviewer.deb
	fi

virtualenv:
	# virtualenv
	if [ ! -d ~/.local/bin/venv ]; then
	    sudo apt install -y --show-progress python3.6 python3-pip
	    pip3 install --user virtualenv
	    virtualenv --python=`which python3.6` ~/.local/bin/venv
	fi
	add_to_file ~/.generic_profile "alias venv='source ~/.local/bin/venv/bin/activate'"

latex:
	# latex / zathura / vimtex / etc.
	sudo apt install -y --show-progress texlive-full libsynctex-dev libgtk-3-dev \
	    libmagic-dev xdotool check intltool sqlite3 check ninja-build \
	    python3.6 python3-pip poppler-utils libpoppler-glib-dev
	pip3 install --user docutils meson
	
	
	for i in girara zathura zathura-pdf-poppler; do
	    cd "$TMPDIR"
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
	
	# TODO: what does this do?
	# https://wikimatze.de/vimtex-the-perfect-tool-for-working-with-tex-and-vim/
	cd "${TMPDIR}"
	wget http://users.phys.psu.edu/%7Ecollins/software/latexmk-jcc/latexmk-445.zip
	unzip latexmk*.zip
	sudo cp latexmk/latexmk.pl /usr/local/bin/latexmk

monitor:
	chmod 700 "${CONFIG}"/monitor.sh
	if [ ! -f /etc/udev/rules.d/98-monitor-hotplug.rules ]; then
	    echo <<-EOF |
	KERNEL=="card0", SUBSYSTEM=="drm", ACTION=="change", ENV{DISPLAY}=":0", ENV{XAUTHORITY}="${HOME}/.Xauthority", RUN+="${CONFIG}/monitor.sh"
	EOF
	    sudo tee -a /etc/udev/rules.d/98-monitor-hotplug.rules
	fi

ssh-ident:
	# ssh-ident
	sudo apt install openssh-server
	sudo dpkg-divert --divert /usr/bin/ssh.ssh-ident --rename /usr/bin/ssh
	sudo wget -O /usr/bin/ssh https://raw.githubusercontent.com/ccontavalli/ssh-ident/master/ssh-ident
	sudo chmod 755 /usr/bin/ssh
	#add_to_file ~/.generic_profile "$(cat <<-'EOF'
	#	export BINARY_SSH="/usr/bin/ssh.ssh-ident"
	#	export DIR_AGENTS='${HOME}/.ssh_agents'
	#	export SSH_DEFAULT_OPTIONS='-A'
	#EOF
	#)"

pushover:
	# pushover
	# https://mikebuss.com/2014/01/03/push-notifications-cli/
	add_to_file ~/.generic_profile "$(cat <<-'EOF'g?
	function push () {
	    curl -s -F "token=a42feki7f68hvnqnqwpu7bjwjrv5fx" \\
	        -F "user=uoo537r5jdq62sg8p545oa4vgbd3gs" \\
	        -F "title=YOUR_TITLE_HERE" \\
	        -F "message=$1" https://api.pushover.net/1/messages.json
	}
	EOF
	)"

tmux:
	sudo apt install -y tmux
#ifeq ("$(wildcard ${HOME}/.tmux/plugins/tpm)","")
	#mkdir -p ~/.tmux/plugins
	#git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
#endif

zsh:
	sudo apt -qq -y --show-progress install zsh fonts-powerline
	sh -c "$$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
	# TODO: pull from subrepos?
	#git submodule update subrepos/{zsh-syntax-highlighting,zsh-autosuggestions,powerlevel9k}
	# need to stow first
	# also, add this to .bashrc
	#add_to_file ~/.zshrc "$$(cat <<-'EOF'
	#    source "$${HOME}/.generic_profile"
	#EOF
	#)"
