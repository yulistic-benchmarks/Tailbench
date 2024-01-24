#!/bin/bash
# set -vxe

printUsage() {
    echo "Usage: $(basename $0) <lats.bin>"
    echo "Run this script in the 'tailbench' directory."
    echo "Ex) utilities/get_results.sh results/lats.bin"
}

if [ -z $1 ]; then
    printUsage
fi

filepath=$1
dirname=$(dirname $1)
filename=$(basename $1)
outname="${filename%.*}"

echo "type,mean,p95,p99,max" >"${dirname}/${outname}.csv"
python3 utilities/parselats.py "$filepath" |
    while read -r line; do
        echo "$line"
        echo "$line" |
            tr -d "|" |
            tr -d ":" |
            sed -r 's/(ms|mean|p95|p99|max)//g' |
            xargs |
            sed -r 's/ /,/g' >>"${dirname}/${outname}.csv"
    done

mv svcCDF.png "${dirname}/${outname}_svcCDF.png"
mv sjrnCDF.png "${dirname}/${outname}_sjrnCDF.png"
mv lats.txt "${dirname}/${outname}_lat.txt"

echo "--- csv format ---"
cat "${dirname}/${outname}.csv"
