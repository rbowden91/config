#!/usr/bin/env bash
# tested on Ubuntu 18.04, 20.04
# developed in but not re-run in mojave 1/30/2019

# Dependencies:
# build-essential, cmake, python3-dev: YouCompleteMe (https://github.com/Valloric/YouCompleteMe)
# nodejs, npm: YouCompleteMe JavaScript/TypeScript support
# clang, clang-tidy: YouCompleteMe C family support
# golang-go: YouCompleteMe Go support
# mono-complete (alternatively, just mono-devel): YouCompleteMe C# support
# openjdk-8-jre: YouCompleteMe Java support
# ack: ack.vim (https://github.com/mileszs/ack.vim)
# codequery: vim-codequery (https://github.com/devjoe/vim-codequery)

# mono takes a long time to install
# add PPA for Mono
# TODO: make this idempotent
#sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
# TODO: focal still used bionic?
#echo "deb https://download.mono-project.com/repo/ubuntu stable-$CODENAME main" | sudo tee /etc/apt/sources.list.d/mono-official-stable.list
sudo apt-get update
if [[ "$CODENAME" == "focal" ]]; then
    sudo apt install -y \
            curl \
            build-essential \
            clang \
            clang-tidy \
            python2.7 \
            python3 \
            python3-pip \
            ruby \
            ruby-dev \
            python3-dev \
            python-dev  \
            git \
            libncurses5-dev \
            libgtk2.0-dev \
            libatk1.0-dev \
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
elif [[ "$CODENAME" == "bionic" ]]; then

    sudo apt install -y \
            curl \
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
else
        # Unknown.
        echo "Unknown Ubuntu distro!"
	exit
fi
