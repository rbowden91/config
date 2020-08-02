# requires pcregrep (and not completely portable?)

add_to_file() {
    local file="$1"
    local input="$2"
    # replace any special regex characters with '.' (so they're always matched).
    # It's not perfect, but good enough.
    local search="$(echo "${input}" | tr '|[]^.$$()' '.')"
    touch "${file}"
    if ! pcregrep -Mq "${search}" "${file}"; then
	# use the below instead of `echo "${input}" >> "${file}"`
    	# because some files need root permission to be modified
	echo "${input}" | sudo tee -a "${file}"
    fi
}
export add_to_file
