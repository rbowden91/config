#.ONESHELL:

#sudo apt-get install software-properties-common
#sudo add-apt-repository ppa:x2go/stable
#sudo apt-get update
#sudo apt-get install x2goserver x2goserver-xsession xbacklight redshift redshift-gtk

# https://askubuntu.com/questions/51445/how-do-i-calibrate-a-touchscreen-on-a-dual-monitor-system
#pip3 install pywal

PREFIX:=${HOME}/repos/
CONFIGNAME:=rbconfig
CONFIG:=${PREFIX}${CONFIGNAME}

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



define add_to_file
    local file="$1"
    # replace any special regex characters with '.' (so they're always matched). Not perfect, but good enough.
    local input="$2"
    local search="$(echo "${input}" | tr '|[]^.$$()' '.')"
    touch "${file}"
    if ! pcregrep -Mq "${search}" "${file}"; then
	# use the below instead of `echo "${input}" >> "${file}"`
    	# because some files need root permission to be modified
	echo "${input}" | sudo tee -a "${file}"
    fi
endef
export add_to_file

rbowden:
	cd "${CONFIG}"
	git remote set-url --push origin git@github.com:rbowden91/config
	cd subrepos/vimrc
	git remote set-url --push origin git@github.com:rbowden91/vimrc

start:
	if [ ! -d "${CONFIG}" ]; then
	    mkdir -p "${PREFIX}"
	    git clone https://github.com/rbowden91/config "${CONFIG}"
	fi

remove-snap:
	sudo rm -rf /var/cache/snapd
	sudo apt autoremove --purge snapd gnome-software-plugin-snap
	rm -rf "${HOME}/snap"

default:
	sudo apt update
	sudo apt install -y --show-progress curl wget screen net-tools git pcregrep

git:
	sudo apt install -y git

rust:
	# TODO: didn't seem to work for Arch
	curl https://sh.rustup.rs -sSf > /tmp/rust.sh
	sh /tmp/rust.sh -y
	source ~/.cargo/env
	rm -f /tmp/rust.sh

mono:
	# takes a long time to install
	sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
	echo "deb https://download.mono-project.com/repo/ubuntu stable-bionic main" | sudo tee /etc/apt/sources.list.d/mono-official-stable.list
	sudo apt update
	sudo apt install -y mono-complete

vimiv:
	sudo apt install -y libgexiv2-2
	DESTDIR="${HOME}" PREFIX="/.local" make -e install

vim: fzf rust local-bin mono
	# Dependencies:
	# build-essential, cmake, python3-dev: YouCompleteMe (https://github.com/Valloric/YouCompleteMe)
	# nodejs, npm: YouCompleteMe JavaScript/TypeScript support
	# clang, clang-tidy: YouCompleteMe C family support
	# golang-go: YouCompleteMe Go support
	# mono-complete (alternatively, just mono-devel): YouCompleteMe C# support
	# openjdk-8-jre: YouCompleteMe Java support
	# ack: ack.vim (https://github.com/mileszs/ack.vim)
	# codequery: vim-codequery (https://github.com/devjoe/vim-codequery)
	if [[ "${OS}" == "Darwin" ]]; then
	    # Mac OSX
	    # xcode cli tools need to be installed, as does brew
	
	    # brew install python3 needs this to exist
	    sudo mkdir -p /usr/local/Frameworks
	    sudo chown rbowden /usr/local/Frameworks
	
	    # couldn't find clang-tidy, *-dev, openjdk-8-jre
	    brew install ack python2 python3 nodejs ruby cmake ctags codequery golang mono
	
	    curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
	    python3 get-pip.py
	    rm get-pip.py
	    PIPPATH=$(find /usr/local/Cellar/python/*/Frameworks/Python.framework/Versions/* -name bin)
	    PIPPATH="${PIPPATH}/pip"
	
	    sudo ln -s ${PIPPATH} /usr/local/bin/pip3
	
	elif [[ "${OS}" == "Ubuntu" ]]; then
	    sudo apt-get install -y \
		    build-essential \
		    clang \
		    clang-tidy \
		    python2.7 \
		    python-pip \
		    python3 \
		    python3-pip \
		    ruby \
		    ruby-dev \
		    python3-dev \
		    python-dev  \
		    git \
		    libncurses5-dev \
		    libgnome2-dev \
		    libgtk2.0-dev \
		    libatk1.0-dev \
		    libgnomeui-dev \
		    libbonoboui2-dev \
		    libcairo2-dev \
		    libx11-dev \
		    libxpm-dev \
		    libxt-dev \
		    nodejs \
		    npm \
		    cmake \
		    exuberant-ctags \
		    ack \
		    codequery \
		    golang-go \
		    mono-complete \
		    openjdk-8-jre
	fi
	elif [[ "${OS}" == "Arch Linux" ]]; then
	    # couldn't find openjdk-8-jre, clang-tidy
	    sudo pacman -S --noconfirm ack python2 python3 nodejs ruby cmake ctags mono
	
	    # for codequery
	    sudo pacman -S qt5-tools
	    git clone https://aur.archlinux.org/codequery.git
	    cd codequery
	    makepkg -Acsy
	    cd ..
	    rm -rf codequery
	else
	        # Unknown.
		exit
	fi
	
	pip install pycscope
	sudo gem install starscope
	sudo npm install -g typescript
	cd "${CONFIG}/subrepos/vim"
	./configure --prefix="${HOME}/.local/bin" \
	    --enable-gui=yes \
	    --disable-nls \
	    --enable-multibyte \
	    --with-tlib=ncurses \
	    --enable-pythoninterp \
	    --enable-python3interp \
	    --enable-rubyinterp \
	    --enable-cscope \
	    --with-features=huge
	make
	make install
	add_to_file ~/.generic_profile "$(cat <<-'EOF'
		export EDITOR='vim'
	EOF
	)"
	ln -s "${CONFIG}/subrepos/vimrc" "${HOME}/.vim"
	ln -s "${HOME}/.vim/.vimrc" "${HOME}/.vimrc"
	# finish YouCompleteMe installation
	cd "${HOME}/.vim/bundle/YouCompleteMe"
	# TODO: osx and arch don't have java-completer
	./install.py --cs-completer --go-completer --rust-completer --java-completer --clang-completer

local-bin:
	mkdir -p ~/.local/bin
	# putting the `-` after `<<` allows you to put tabs for formatting that will be ignored
	# putting `'` around `EOF` makes it so variables aren't interpolated
	#add_to_file ~/.profile "$(cat <<-'EOF'
	#	# set PATH so it includes user private bin if it exists
	#	if [ -d "${HOME}/.local/bin" ] ; then
	#	    PATH="${HOME}/.local/bin:${PATH}"
	#	fi
	#EOF
	#)"
	add_to_file ~/.profile "$(cat <<-'EOF'
		# set PATH so it includes user\'s private bin if it exists
		if [ -d "${HOME}/.local/bin" ] ; then
		    PATH="${HOME}/.local/bin:${PATH}"
		fi
	EOF
	)"

chrome:
	if ! sudo apt list 2> /dev/null | grep -q 'google-chrome-stable'; then
	    wget -O "${TMPDIR}"/chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
	    sudo apt install -y --show-progress "${TMPDIR}"/chrome.deb
	fi
	xdg-settings set default-web-browser google-chrome.desktop

dropbox:
	sudo apt install -y --show-progress python3-gpg
	if [ ! -d ~/.dropbox-dist ]; then
	    cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
	fi
	if [ ! -f ~/.local/bin/dropbox ]; then
	    wget -O ~/.local/bin/dropbox 'https://www.dropbox.com/download?dl=packages/dropbox.py'
	    chmod 700 ~/.local/bin/dropbox
	fi
	
	if [ ! $(dropbox running) ]; then
	    sudo pkill -9 dropbox
	    dropbox start &> /dev/null
	fi
	chmod 664 ${CONFIG}/dropbox.service
	sudo ln ${CONFIG}/config/dropbox.service /etc/systemd/system/
	sudo systemctl enable dropbox.service
	ln -s ~/'Dropbox (CS50)'/rob/identity/ssh ~/.ssh
	ln -s ~/'Dropbox (CS50)'/rob/wallpapers ~/.wallpapers
	add_to_file ~/.generic_profile "alias db='cd \${HOME}/\"Dropbox (CS50)\"'"
	
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
	
	while ! wait_for_login; do
	    sleep 3
	done
	# TODO: do the directories have to exist first??
	cd "~/Dropbox (CS50)/"
	dropbox exclude add Apps nick Screenshots shared rob/selective

spotify:
	sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 931FF8E79F0876134EDDBDCCA87FF9DF48BF1C90
	add_to_file '/etc/apt/sources.list.d/spotify.list' 'deb http://repository.spotify.com stable non-free'
	sudo apt update
	sudo apt install -y --show-progress spotify-client

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
	add_to_file ~/.generic_profile "$(cat <<-'EOF'
		export BINARY_SSH="/usr/bin/ssh.ssh-ident"
		export DIR_AGENTS='${HOME}/.ssh_agents'
		export SSH_DEFAULT_OPTIONS='-A'
	EOF
	)"

pushover:
	# pushover
	# https://mikebuss.com/2014/01/03/push-notifications-cli/
	add_to_file ~/.generic_profile "$(cat <<-'EOF'
	function push () {
	    curl -s -F "token=a42feki7f68hvnqnqwpu7bjwjrv5fx" \\
	        -F "user=uoo537r5jdq62sg8p545oa4vgbd3gs" \\
	        -F "title=YOUR_TITLE_HERE" \\
	        -F "message=$1" https://api.pushover.net/1/messages.json
	}
	EOF
	)"

vte-ng:
	# install vte-ng (for termite)
	sudo apt install -y --show-progress git g++ libgtk-3-dev gtk-doc-tools gnutls-bin valac intltool libpcre2-dev libglib3.0-cil-dev libgnutls28-dev libgirepository1.0-dev libxml2-utils gperf
	cd "${TMPDIR}"
	git clone https://github.com/thestinger/vte-ng.git
	export LIBRARY_PATH="/usr/include/gtk-3.0:${LIBRARY_PATH}"
	cd vte-ng
	./autogen.sh
	make && sudo make install

termite: vte-ng
	# install termite
	cd "${TMPDIR}"
	git clone --recursive https://github.com/thestinger/termite.git
	cd termite
	make
	sudo make install
	sudo ldconfig
	sudo mkdir -p /lib/terminfo/x
	sudo ln -s /usr/local/share/terminfo/x/xterm-termite /lib/terminfo/x/xterm-termite
	sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator /usr/local/bin/termite 60
	add_to_file ~/.generic_profile $(cat <<-'EOF'
		export TERMINAL='termite'
	EOF
	)

i3-lock:
	# https://github.com/PandorasFox/i3lock-color
	sudo apt install -y --show-progress pkg-config libxcb1 libxcb-util1 libpam0g-dev libcairo2-dev \
	    libfontconfig1-dev libxcb-composite0 libxcb-composite0-dev libxcb-xinerama0 libxcb-randr0 \
	    libev4 libx11-xcb-dev libxkbcommon0 libxkbcommon-x11-0 libjpeg-turbo8 libjpeg8-dev libjpeg-turbo8-dev
	cd "${CONFIG}/subrepos/i3lock-color"
	autoreconf -i
	./configure
	make
	sudo make install

betterlockscreen: i3-lock
	# https://github.com/pavanjadhaw/betterlockscreen
	#sudo apt install -y imagemagick x11-xserver-utils bc feh
	#betterlockscreen -u ${HOME}/.wallpapers/XXX/xx.jpg
	sudo apt install -y ffmpeg


i3-gaps:
	# i3-gaps
	sudo apt install -y --show-progress libxcb1-dev libxcb-keysyms1-dev \
	    libpango1.0-dev libxcb-util0-dev libxcb-icccm4-dev libyajl-dev \
	    libstartup-notification0-dev libxcb-randr0-dev libev-dev libxcb-cursor-dev \
	    libxcb-xinerama0-dev libxcb-xkb-dev libxkbcommon-dev libxkbcommon-x11-dev \
	    autoconf xutils-dev libtool automake libxcb-xrm-dev
	git clone https://www.github.com/Airblader/i3 "${TMPDIR}"/i3-gaps
	cd "${TMPDIR}"/i3-gaps
	autoreconf --force --install
	rm -rf build/
	mkdir -p build && cd build/
	../configure --prefix=/usr --sysconfdir=/etc --disable-sanitizers
	make
	sudo make install
	# various tools for i3
	sudo apt -y install pavucontrol xclip alsamixergui dunst compton conky suckless-tools ranger feh pulseaudio-utils xprop mpd mpc rofi
	pip install i3-py
	sudo dpkg-divert --divert /usr/bin/dmenu.rbconfnig --rename /usr/bin/dmenu
	sudo ln -s /usr/bin/rofi /usr/bin/dmenu
	# https://github.com/hastinbe/i3-volume
	#git clone https://github.com/hastinbe/i3-volume.git dotfiles/.config/i3/

lemonbar:
	# TODO XXX
	sudo apt install fonts-font-awesome
	sudo rm /etc/fonts/conf.d/70-no-bitmaps.conf
	git clone https://github.com/krypt-n/bar.git "${TMPDIR}"/bar
	cd "${TMPDIR}"/bar
	make
	sudo make install

dotfiles:
	sudo apt -qq -y install stow
	mkdir -p ~/.fonts
	stow -d "${CONFIG}" -t ~ dotfiles
	fc-cache -f

#fzf:
#ifeq ("$(wildcard ${HOME}/.fzf)","")
#	git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
#	~/.fzf/install --key-bindings --completion --update-rc
#endif

tmux:
ifeq ("$(wildcard ${HOME}/.tmux/plugins/tpm)","")
	mkdir -p ~/.tmux/plugins
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
endif

zsh:
	#sudo apt -qq install zsh fonts-powerline
	#sh -c "$$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
	# TODO: pull from subrepos?
	ln -s "${CONFIG}/subrepos/zsh-syntax-highlighting" "${HOME}/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
	ln -s "${CONFIG}/subrepos/zsh-autosuggestions" "${HOME}/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
	ln -s "${CONFIG}/subrepos/powerlevel9k" "${HOME}/.oh-my-zsh/custom/themes/powerlevel9k"
	# need to stow first
	# also, add this to .bashrc
	#add_to_file ~/.zshrc "$$(cat <<-'EOF'
	#    source "$${HOME}/.generic_profile"
	#EOF
	#)"
