#export TERM='xterm-256color'
export TERM='xterm-termite'
export LANG='en_US.UTF-8'
export EDITOR='vim'
export TERMINAL='termite'
export BROWSER='google-chrome'

export KEYTIMEOUT=1 # reduce delay between hitting escape and transitioning modes

# TODO: move this
export QT_QPA_PLATFORMTHEME=qt5ct

# https://wiki.archlinux.org/index.php/HiDPI
export QT_AUTO_SCREEN_SCALE_FACTOR=1
export GDK_SCALE=2
export GDK_DPI_SCALE=0.5
#export QT_SCALE_FACTOR=2
#export QT_SCALE_FACTORS=3 4 5
#export QT_FONT_DPI=96
#xrandr --output eDP1 --scale 1.25x1.25
export SSH_ADD_OPTIONS='-A'
export SSH_ADD_DEFAULT_OPTIONS=
export GIT_SSH='~/.local/bin/ssh'
