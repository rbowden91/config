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
ln -s ~/'Dropbox (CS50)'/Identity/ssh/ssh_config ~/.ssh/config
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
virtualenv --python=`which python3.6` ~/venv

cat >> ~/.bashrc << EOF
export BINARY_SSH="/usr/bin/ssh.ssh-ident"
alias db='cd $HOME/"Dropbox (CS50)"'
alias venv='source ~/venv/bin/activate'
EOF
