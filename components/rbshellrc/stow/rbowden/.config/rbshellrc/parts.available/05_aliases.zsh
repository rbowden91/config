hash -d config=~/.config
hash -d rbconfig=~config/rbconfig/components
hash -d rbshellrc=~rbconfig/rbshellrc/stow/rbowden/.config/rbshellrc
hash -d rbshell=~config/rbshellrc

hash -d iroh=/mnt/iroh/share/homes/rbowden
hash -d qdb=~/QLS\ Advisors\ Dropbox
hash -d repos=~/repos

alias jupyter_convert='jupyter nbconvert --to python'
alias vi='vim'

alias cpcat='xclip -sel c'
alias pdropbox="docker exec -it dropbox dropbox"
alias pdropbox-start="docker run -d --restart=always --name=dropbox -v /home/rbowden/Dropbox:/dbox/Dropbox -v /home/rbowden/.pdropbox:/dbox/.dropbox -e DBOX_UID=1000 -e DBOX_GID=100 janeczku/dropbox"

alias pgpd="xclip -o | gpg -o - --batch --passphrase-file ~/pgp/passphrase.pgp --pinentry-mode loopback --decrypt | tail -n 1 | cut -d' ' -f3 | xclip -selection clipboard"
alias pgpd2="xclip -o | gpg -o - --batch --passphrase-file ~/pgp/passphrase.pgp --pinentry-mode loopback --decrypt | tail -n 1 | cut -d' ' -f3"
alias meva="sshfs eva:'/home/rbowden/docker/code/qls' /mnt/eva/"
alias miroh="sshfs -p2230 rbowden@vps.rbowden.com:'/home/rbowden/docker/code/qls' /mnt/iroh/"
