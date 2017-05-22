#!/bin/bash

# Counts number of test:do_, updates test:plan appropriately
# Works *** INPLACE ***
if [ $# -ne 1 ]; then
    echo "Usage: $0 <path to single test>"
    exit 0
fi

N=`grep test:do_ $1 |wc -l`

perl -pe "s/test:plan\(0\)/test:plan\($N\)/" -i $1
