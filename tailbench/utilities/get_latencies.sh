#!/bin/bash
# Input file: lats.txt generated after running benchmark.
# Ex)
#
#   QueueTimes | ServiceTimes | SojournTimes
#
#        0.079 |        0.608 |        0.687
#        0.106 |        0.414 |        0.520
#        0.079 |        0.928 |        1.007
#        0.078 |        0.944 |        1.022
#        0.134 |        0.362 |        0.496
#	 ...
#
# Output file only includes latencies. One latency in each line.
printUsage() {
	echo "Usage: $0 <input file>"
	exit 2
}

if [ -z "$1" ]; then
	printUsage
fi

while getopts "?h" opt; do
	case $opt in
	h | ?)
		printUsage
		;;
	esac
done

parseInputFile() {
	input="$1"
	dir=$(dirname "$input")
	filename=$(basename "$input")
	outfile_name="$dir/${filename%.*}_sjrnLat.txt"

	echo "Output file: $outfile_name"

	line_cnt=0

	# IFS= : preserves leading/trailing white space.
	# -r   : prevents backspace escapes.
	while IFS= read -r line; do
		# Ignore first two lines.
		if ((line_cnt < 2)); then
			((line_cnt = line_cnt + 1))
			continue
		fi
		echo "$line" | xargs | tr -d "|" | xargs | cut -d " " -f 3 >>"$outfile_name"
		((line_cnt = line_cnt + 1))
	done <"$input"

	echo "Total latency count: $line_cnt"
}

if [[ "${BASH_SOURCE[0]}" = "${0}" ]]; then
	# Not sourced.
	parseInputFile "$1"
	exit
fi
