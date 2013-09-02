sudo yum -y install make ruby ruby-devel vim memcached

git config --global user.name "Rob Bowden"
git config --global user.email "rbowden91@gmail.com"

mkdir ~/.vim
git clone git@github.com:rbowden91/vimrc.git ~/.vim
ln -s ~/.vim/.vimrc ~/.vimrc
vim +BundleInstall +qall
