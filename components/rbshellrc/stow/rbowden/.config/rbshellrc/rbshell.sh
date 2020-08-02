#https://stackoverflow.com/questions/3349105/how-to-set-current-working-directory-to-the-directory-of-the-script
#echo "$_"
#echo "${(%):-%x}"
#echo "$BASH_SOURCE"
#if [ -f "$BASH_SOURCE" ]; then
#    echo "woo"
#fi
#echo $BASH_SOURCE
#echo $@
#SCRIPTPATH="$@"
#echo $SCRIPTPATH

#run="$0"

#getscriptpath()
#{
#    f=$@
#    echo "$f 1"
#    if [ -d "$f" ]; then
#        base=""
#        dir="$f"
#    elif [ "$(basename "$run")" = "shellrc.sh" ]; then
#        base="/$(basename "$run")"
#        dir="$(dirname "$run")"
#    else
#        base="/$(basename "$f")"
#        dir="$(dirname "$f")"
#    fi
#    dir=$(cd "$dir" && /bin/pwd)
#    echo "$dir$base"
#}
##export getscriptpath
#echo $(getscriptpath)

#CWD="$(getscriptpath)"


CWD=${HOME}/.config/rbshellrc
CURSHELL="$( . "${CWD}/id_interpreter/id_interpreter" | sed 's/ .*//')"

# $1 should be one of "login" or "nonlogin"
if [ "$1" != 'login'  -a  "$1" != "nonlogin" ]; then
	TYPE="login"
else
	TYPE="$1"
fi

FILES=$(find "$CWD/parts.enabled/$TYPE" -type l \( -name "*.${CURSHELL}" -or -name "*.sh" \) -exec /bin/echo -e "{}" \; 2> /dev/null | sort)

if [ "$CURSHELL" = 'zsh' ]; then
    # if we're in zsh, convert $FILES to an array for the for loop. We use "emulate" here in order to avoid a syntax
    # error on shells that don't support this array syntax
    emulate zsh -c "FILES=( $(echo "$FILES") )"
fi

for i in $FILES; do
    FILE="$(/bin/echo $i | tr -d '[:space:]' )"
    . "$FILE"
done
