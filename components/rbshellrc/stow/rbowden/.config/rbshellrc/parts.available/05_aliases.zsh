hash -d config=~/.config
hash -d rbconfig=~config/rbconfig/components
hash -d rbshellrc=~rbconfig/rbshellrc/stow/rbowden/.config/rbshellrc
hash -d rbshell=~config/rbshellrc

hash -d iroh=/mnt/iroh/share/homes/rbowden

hash -d qdb=~/QLS\ Advisors\ Dropbox

hash -d qls=~/qls
hash -d repos=~/repos
hash -d db=~qls/db \
        utils=~qls/utils \
        ml=~qls/ml \
        stats=~qls/stats \

alias jupyter_convert='jupyter nbconvert --to python'
alias vi='vim'

alias cpcat='xclip -sel c'
alias pdropbox="docker exec -it dropbox dropbox"
alias pdropbox-start="docker run -d --restart=always --name=dropbox -v /home/rbowden/Dropbox:/dbox/Dropbox -v /home/rbowden/.pdropbox:/dbox/.dropbox -e DBOX_UID=1000 -e DBOX_GID=100 janeczku/dropbox"

