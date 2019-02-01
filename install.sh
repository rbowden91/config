#!/usr/bin/env sh
# tested on Ubuntu 18.04

mkdir -p ~/bin
echo 'export PATH="$HOME/bin:$PATH"' >> ~/.profile
source ~/.profile

sudo apt-get update
sudo apt-get install -y curl wget screen tmux numlockx

cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
~/.dropbox-dist/dropboxd
read -p "Press any key once you've logged into Dropbox... " -n1 -s
wget -O ~/bin/dropbox 'https://www.dropbox.com/download?dl=packages/dropbox.py'
chmod 700 ~/bin/dropbox
dropbox autostart y

# spotify
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 931FF8E79F0876134EDDBDCCA87FF9DF48BF1C90
echo deb http://repository.spotify.com stable non-free | sudo tee /etc/apt/sources.list.d/spotify.list
sudo apt-get update
sudo apt-get install -y spotify-client

# TeamViewer
cd /tmp && wget https://download.teamviewer.com/download/linux/signature/TeamViewer2017.asc
sudo apt-key add TeamViewer2017.asc
sudo sh -c 'echo "deb http://linux.teamviewer.com/deb stable main" >> /etc/apt/sources.list.d/teamviewer.list'
sudo sh -c 'echo "deb http://linux.teamviewer.com/deb preview main" >> /etc/apt/sources.list.d/teamviewer.list'
sudo apt-get update
sudo apt-get install -y teamviewer

# chromium
sudo apt-get install -y chromium-browser
xdg-settings set default-web-browser chromium-browser.desktop

# TODO: hopefully files are here by now??
cd ~/Dropbox*
dropbox exclude add *
dropbox exclude remove Courses grad_school Identity
cd Courses
dropbox exclude add *
dropbox exclude remove cs50

curl https://raw.githubusercontent.com/rbowden91/vimrc/master/install.sh | sh
cd ~/.vim
git remote set-url --push origin git@github.com:rbowden91/vimrc

git config --global user.name "Rob Bowden"
git config --global user.email "rbowden91@gmail.com"
git config --global push.default simple

mkdir -p ~/.ssh
ln -s ~/'Dropbox (CS50)'/Identity/ssh/config ~/.ssh/config
cp -s ~/'Dropbox (CS50)'/Identity/ssh/id_rsa.pub ~/.ssh/id_rsa.pub
cp -s ~/'Dropbox (CS50)'/Identity/ssh/id_rsa ~/.ssh/id_rsa
chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_rsa

sudo dpkg-divert --divert /usr/bin/ssh.ssh-ident --rename /usr/bin/ssh
wget -O ~/bin/ssh-ident https://raw.githubusercontent.com/ccontavalli/ssh-ident/master/ssh-ident
sudo chmod 755 ~/bin/ssh-ident
sudo chown root.root ~/bin/ssh-ident
sudo mv ~/bin/ssh-ident /usr/bin/ssh

sudo apt-get install -y python3.6
pip3 install virtualenv
virtualenv --python=`which python3.6` ~/bin/venv

cat >> ~/.bashrc << EOF
export BINARY_SSH="/usr/bin/ssh.ssh-ident"
alias db='cd $HOME/"Dropbox (CS50)"'
alias venv='source ~/bin/venv/bin/activate'
EOF


# https://github.com/Corwind/termite-install/blob/master/termite-install.sh
curl https://raw.githubusercontent.com/Corwind/termite-install/master/termite-install.sh | sh

# i3-gaps
sudo apt-get install -y libxcb1-dev libxcb-keysyms1-dev libpango1.0-dev \
libxcb-util0-dev libxcb-icccm4-dev libyajl-dev \
libstartup-notification0-dev libxcb-randr0-dev \
libev-dev libxcb-cursor-dev libxcb-xinerama0-dev \
libxcb-xkb-dev libxkbcommon-dev libxkbcommon-x11-dev \
autoconf libxcb-xrm0 libxcb-xrm-dev automake
git clone https://www.github.com/Airblader/i3 /tmp/i3-gaps
cd /tmp/i3-gaps
autoreconf --force --install
rm -rf build/
mkdir -p build && cd build/
../configure --prefix=/usr --sysconfdir=/etc --disable-sanitizers
make
sudo make install
cd ~
rm -rf /tmp/i3-gaps

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
#cd ..
#rm -rf bar
