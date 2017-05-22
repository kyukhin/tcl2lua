#!/bin/bash

echo "  There're excluded files: either not related to tSQL functionality or "
echo "    which were already converted, reviewed and pushed to Tarantool."
echo
echo "    List stored here: tests-ignored.txt"

if [ $# -ne 3 ]; then
    echo "Usage: $0 <path to tarantool binary> <path to source dir> <path to dest dir>"
    exit 0
fi

CONVERTER="tcl2.lua"
EXCLUDE_LIST_FN="$PWD/tests-ignored.txt"
TBIN=$1
SDIR=$2
DDIR=$3

[ -d $DDIR ] || mkdir -p $DDIR

# Remove comments
EXCLUDE_LIST=$(cat $EXCLUDE_LIST_FN |perl -pe "s/#.*$//; /^$/d")

for i in `find $SDIR -name "*.test.lua" $(printf "! -name %s " $(cat $EXCLUDE_LIST_FN))` ; do
# for i in `find $SDIR -name "*.test.lua"` ; do
    (
	n=$(basename $i)
        echo "Converting... $n"
        $TBIN $CONVERTER $i > $DDIR/$n
        chmod +x $DDIR/$n
        echo "Done"
    ) &
done

wait
