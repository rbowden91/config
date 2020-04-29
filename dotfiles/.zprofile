# source ~/.profile
[[ -e ~/.profile ]] && emulate sh -c 'source ~/.profile'

if command -v pyenv 1>/dev/null 2>&1; then
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)" # auto-activate virtualenvs
fi
