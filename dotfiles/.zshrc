export TERM='xterm-256color'
export LANG=en_US.UTF-8
export EDITOR='vim'
export TERMINAL='termite'
export BROWSER='google-chrome'

export ZSH="/home/rbowden/.oh-my-zsh"
ZSH_THEME="powerlevel9k/powerlevel9k"

#ZSH_TMUX_AUTOSTART=true
ZSH_TMUX_AUTOQUIT=false

HYPHEN_INSENSITIVE="true" # hyphen-insensitive completion
DISABLE_UPDATE_PROMPT="true" # update zsh without prompting
COMPLETION_WAITING_DOTS="true" # red dots while waitingn for command completion
# ENABLE_CORRECTION="true" # command auto-correction
# DISABLE_MAGIC_FUNCTIONS=true # uncommennt if pasting URLs/text is messed up

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
plugins=(
    git
    fzf
    #docker
    zsh-syntax-highlighting
    zsh-autosuggestions
    colored-man-pages
    command-not-found
    pipenv
    safe-paste
    tmux
    vi-mode
    zsh_reload
)

source $ZSH/oh-my-zsh.sh

export KEYTIMEOUT=1 # reduce delay between hitting escape and transitioning modes

hash -d qls=~/repos/qls/qls_py \
        dropbox="~/Dropbox (CS50)"

hash -d ml=~qls/qls/ml \
        db=~qls/qls/db \
        utils=~qls/qls/utils \
        stats=~qls/qls/stats \
        data=~qls/qls/data \
        api=~qls/qls/api

alias jupyter_convert='jupyter nbconvert --to python'

#[ -z $TMUX ] && export TERM=xterm-256color && exec tmux

function push () {
    curl -s -F "token=a42feki7f68hvnqnqwpu7bjwjrv5fx" \\
	-F "user=uoo537r5jdq62sg8p545oa4vgbd3gs" \\
	-F "title=YOUR_TITLE_HERE" \\
	-F "message=$1" https://api.pushover.net/1/messages.json
}

POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status root_indicator vi_mode background_jobs history time)
