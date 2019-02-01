#!/usr/bin/env sh

# useradd -G wheel -s /bin/bash rbowden
# passwd rbowden
# fix visudo

echo 'export PATH="$HOME/bin:$PATH"' >> ~/.profile
source ~/.profile

sudo pacman -Syu --noconfirm curl wget screen tmux numlockx git python2 python3 python-pip openssh net-tools
# qt5 needed for teamviewer
sudo pacman -Syu --noconfirm dialog wpa_supplicant openssl xorg xorg-xinit xorg-server i3-gaps qt5-x11extras qt5-webkit qt5-quickcontrols
sudo pacman -Syu --noconfirm --overwrite *xterm-termite termite chromium

# for now, these seem to be required for teamviewer
sudo pacman -Syu lightdm lightdm-gtk-greeter

git clone http://aur.archlinux.org/python36.git
cd python36
makepkg -Acs
sudo pacman -U --noconfirm python36*.pkg.tar.xz
cd ..
rm -rf python36
sudo pip3 install virtualenv
virtualenv --python=`which python3.6` ~/bin/venv

mkdir -p ~/bin
cat >> ~/.bashrc << EOF
export PATH="$HOME/bin:$PATH"
export BINARY_SSH="/usr/bin/ssh.ssh-ident"
alias db='cd $HOME/"Dropbox (CS50)"'
alias venv='source ~/bin/venv/bin/activate'
EOF
source ~/.bashrc

cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | sudo tar xzf -
wget -O ~/bin/dropbox 'https://www.dropbox.com/download?dl=packages/dropbox.py'
chmod 700 ~/bin/dropbox
dropbox start -i
read -p "Press any key once you've logged into Dropbox... " -n1 -s
dropbox autostart y

git config --global user.name "Rob Bowden"
git config --global user.email "rbowden91@gmail.com"
git config --global push.default simple

mkdir -p ~/.ssh
ln -s ~/'Dropbox (CS50)'/Identity/ssh/config ~/.ssh/config
ln -s ~/'Dropbox (CS50)'/Identity/ssh/id_rsa.pub ~/.ssh/id_rsa.pub
ln -s ~/'Dropbox (CS50)'/Identity/ssh/id_rsa ~/.ssh/id_rsa

curl https://raw.githubusercontent.com/rbowden91/vimrc/master/install.sh | sh
cd ~/.vim
git remote set-url --push origin git@github.com:rbowden91/vimrc

sudo mv /usr/bin/ssh /usr/bin/ssh.ssh-ident
wget -O ~/bin/ssh-ident https://raw.githubusercontent.com/ccontavalli/ssh-ident/master/ssh-ident
sudo chmod 755 ~/bin/ssh-ident
sudo chown root.root ~/bin/ssh-ident
sudo mv ~/bin/ssh-ident /usr/bin/ssh

dropbox exclude add ~/"Dropbox (CS50)"/*
dropbox exclude remove ~/"Dropbox (CS50)"/grad_school ~/"Dropbox (CS50)"/Identity
sleep 3
chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_rsa

# spotify, teamviewer



# to keep screen on, this goes in .xinit
# xset s off
# xset -dpms
