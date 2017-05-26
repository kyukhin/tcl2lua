#!/bin/bash

echo "  There're excluded files: either not related to tSQL functionality or "
echo "    which were already converted, reviewed and pushed to Tarantool."
echo
echo "    List stored here: tests-ignored.txt"

if [ $# -ne 3 ]; then
    echo "Usage: $0 <path to tarantool root> <path to source dir> <path to dest dir>"
    exit 0
fi

CONVERTER="tcl2.lua"
EXCLUDE_LIST_FN="$PWD/tests-ignored.txt"
TBIN=$1/src/tarantool
CONVERTED_TESTS_DIR=$1/test/sql-tap/
SDIR=$2
DDIR=$3

[ -d $DDIR ] || mkdir -p $DDIR

# Remove comments
EXCLUDE_LIST=$(cat $EXCLUDE_LIST_FN |perl -pe "s/#.*$//; /^$/d")
EXCLUDE_LIST="$EXCLUDE_LIST\n$(for i in $(find $CONVERTED_TESTS_DIR -name '*.lua'); do basename $i; done;)"
echo $EXCLUDE_LIST
for i in `find $SDIR -name "*.test.lua" $(printf "! -name %s " $(echo $EXCLUDE_LIST))` ; do
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
