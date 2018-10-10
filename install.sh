#!/usr/bin/env sh
# tested on Ubuntu 18.04

mkdir -p ~/bin
echo 'export PATH="$HOME/bin:$PATH"' >> ~/.profile
source ~/.profile

sudo apt-get update
sudo apt-get install -y curl wget

cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
~/.dropbox-dist/dropboxd
read -p "Press any key once you've logged into Dropbox... " -n1 -s
wget -O ~/bin/dropbox 'https://www.dropbox.com/download?dl=packages/dropbox.py'
chmod 700 ~/bin/dropbox
dropbox autostart y

# install TeamViewer
cd /tmp && wget https://download.teamviewer.com/download/linux/signature/TeamViewer2017.asc
sudo apt-key add TeamViewer2017.asc
sudo sh -c 'echo "deb http://linux.teamviewer.com/deb stable main" >> /etc/apt/sources.list.d/teamviewer.list'
sudo sh -c 'echo "deb http://linux.teamviewer.com/deb preview main" >> /etc/apt/sources.list.d/teamviewer.list'
sudo apt-get update

sudo apt-get install -y teamviewer chromium-browser
xdg-settings set default-web-browser chromium-browser.desktop

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
ln -s ~/'Dropbox (CS50)'/Identity/ssh/ssh_config ~/.ssh/config
cp -s ~/'Dropbox (CS50)'/Identity/ssh/id_rsa.pub ~/.ssh/id_rsa.pub
cp -s ~/'Dropbox (CS50)'/Identity/ssh/id_rsa ~/.ssh/id_rsa
chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_rsa

wget -O ~/bin/ssh-ident https://raw.githubusercontent.com/ccontavalli/ssh-ident/master/ssh-ident
chmod 700 ~/bin/ssh-ident
ln -s ~/bin/ssh-ident ~/bin/ssh

cat >> ~/.bashrc << EOF
alias db='cd $HOME/"Dropbox (CS50)"'
alias scp='BINARY_SSH=scp ~/bin/ssh-ident'
alias sftp='BINARY_SSH=scp ~/bin/ssh-ident'
EOF
