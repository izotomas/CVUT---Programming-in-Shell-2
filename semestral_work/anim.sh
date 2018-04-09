#!/bin/bash

# Create animation of measured values in time
DEBUG=0
VERBOSE=0

debug() { ((DEBUG)) && echo "$0:[debug]: $@" >&2; }
verbose() { ((VERBOSE)) && echo "$0:[info]: $@" >&2; }
err() { echo "$0[error]: $@" >&2; }
help() { echo "
Usage: 	$0 [-v] datafile...
	$0 -h

	-v ... verbose
	-h ... this help
"; }

# process options
while getopts vh opt
do
	case $opt in
		v) ((VERBOSE++));;
		h) help; exit 0;;
		\?) help >&2; exit 1;;
	esac
done
shift $((OPTIND - 1))

tmp=$( mktemp -d ) || exit 2
debug "Temporary directory: $tmp"
trap 'rm -r "$tmp"' EXIT # cleanup after exit

# Process file by file (arguments)
for datafile
do

	[ $# -eq 1 ] || err "At least one argument expected"
	datafile=$1
	[ -f "$datafile" ] || err "Datafile '$1' is not a file"
	[ -r "$datafile" ] || err "Datafile '$1' is not readable"
	[ -s "$datafile" ] || err "Datafile '$1' is empty"


	# No. records
	records=$(wc -l < data.orig)
	digits=${#records}
	range=$( sort -n data.orig | sed -n '1h;${H;g;s/\n/:/;p}' )

	# Loop every frame
	printf "$0[info]: Frames done:     "
	for ((i=1;i<records;i++))
	do
		#((100*i/records % 10)) && verbose "$((100*i/records))% done" # percentage
		((VERBOSE)) && printf '\b\b\b\b%3d%%' $((100*i/records))
		# 1. Create one frame of animation (one image)

		# 1.1. Prepare data for one frame
		head -n $i "$datafile" > data

		# 1.2 Create image
		gnuplot <<-GNUPLOT
			set terminal png
			set output "$( printf "$tmp/%0${digits}d.png" $i )"
			plot [0:$records][$range] 'data' with lines
			GNUPLOT

		done
		# 2. Join frames into video file
		case $VERBOSE in
			0|1) ffmpeg -y -i "$tmp/%0${digits}d.png" anim.mp4 2>/dev/null;;
			*) ffmpeg -y -i "$tmp/%0${digits}d.png" anim.mp4;;
		esac
done
