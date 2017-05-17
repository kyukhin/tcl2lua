#!/bin/bash

if [ $# -ne 3 ]; then
    echo "Usage: $0 <path to tarantool binary> <path to source dir> <path to dest dir>"
    exit 0
fi

CONVERTER="tcl2.lua"
TBIN=$1
SDIR=$2
DDIR=$3

[ -d $DDIR ] || mkdir -p $DDIR

pushd $SDIR
list=`ls *.test.lua`
popd

for i in $list ; do
    (
        echo "Converting... $i"
        $TBIN $CONVERTER $SDIR/$i > $DDIR/$i
        chmod +x $DDIR/$i
        echo "Done"
    ) &
done

wait
