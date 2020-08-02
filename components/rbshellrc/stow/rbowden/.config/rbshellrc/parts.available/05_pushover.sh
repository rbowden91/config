pushover() {
    curl -s -F "token=a42feki7f68hvnqnqwpu7bjwjrv5fx" \\
	-F "user=uoo537r5jdq62sg8p545oa4vgbd3gs" \\
	-F "title=YOUR_TITLE_HERE" \\
	-F "message=$1" https://api.pushover.net/1/messages.json
}
export pushover
