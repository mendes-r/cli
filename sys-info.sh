#!/bin/bash

# Source: The Linux Command Line; Shotts, William
# Program to output a system information page

PROGNAME="$(basename "$0")"
TITLE="System Information Report for $HOSTNAME"
CURRENT_TIME="$(date -u "+%Y-%m-%d %H:%M:%S GMT")"
TIMESTAMP="Generated $CURRENT_TIME, by $USER"

report_uptime () {
	cat <<- _EOF_
		<h2>System Uptime</h2>
		<pre>$(uptime)</pre>
		_EOF_
	return
}

report_disk_space () {
	cat <<- _EOF_
		<h2>Disk Space Utilization</h2>
		<pre>$(df -h)</pre>
		_EOF_
	return
}

report_home_space () {
	if [[ "$(id -u)" -eq 0 ]]; then
		if [[ "$OSTYPE" == "darwin"* ]]; then #MacOS
			cat <<- _EOF_
				<h2>Home Space Utilization (All Users MacOS)</h2>
				<pre>$(du -sh /Users/*)</pre>
				_EOF_
		else
			cat <<- _EOF_
				<h2>Home Space Utilization (All Users)</h2>
				<pre>$(du -sh /home/*)</pre>
				_EOF_
		fi
	else
		cat <<- _EOF_
			<h2>Home Space Utilization ($USER)</h2>
			<pre>$(du -sh $HOME)</pre>
			_EOF_
	fi
	return
}

usage () {
	echo "$PROGNAME: usage: $PROGNAME [-f file | -i]"
	return
}

write_html_page () {
	cat <<- _EOF_
	<hmtl>
		<head>
			<title>$TITLE</title>
		</head>
		<body>
			<h1>$TITLE</h1>
			<p>$TIMESTAMP</p>
			$(report_uptime)
			$(report_disk_space)
			$(report_home_space)
		</body>
	</html>
	_EOF_
}

# process command line options

interactive=
filename=

while [[ -n "$1" ]]; do
	case "$1" in
		-f | --file)		 shift
							filename="$1"
							;;
		-i | --interactive) interactive=1
							;;
		-h | --help			usage
							exit
							;;
		*)					usage >&2
							exit 1
							;;
	esac
	shift
done

# interactive mode

if [[ -n "$interactive" ]]; then
	while true; do
		read -p "Enter name of output file: " filename
		if [[ -e "$filename" ]]; then	
			read -p "$filename exists. Overwrite? [y/n/q] >"
			case "$REPLY" in
				Y|y)	break
						;;
				Q|q) 	echo "Program terminated."
						exit
						;;
				*)		continue
						;;
			esac
		elif [[ -z "$filename" ]]; then
			continue
		else
			break
		fi
	done
fi

# output html page

if [[ -n "$filename" ]]; then
	if touch "$filename" && [[ -f "$filename" ]]; then
		write_html_page > "$filename"
	else
		echo "#PROGNAME: Cannit write file '$filename'" >&2
		exit 1
	fi
else
	write_html_page
fi
