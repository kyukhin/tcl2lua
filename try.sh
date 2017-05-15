#!/bin/bash
TARANTOOL_SRC=$1
TARANTOOL_BIN="$TARANTOOL_SRC/src/tarantool"
TARANTOOL_TEST="$TARANTOOL_SRC/test/"
OUTPUT_DIR="$TARANTOOL_TEST/sql-tap-try/"
SQL_TAP_DIR="$TARANTOOL_TEST/sql-tap/"
if ! [ -d $OUTPUT_DIR ]; then
  mkdir $OUTPUT_DIR
  cp -r $SQL_TAP_DIR/lua $OUTPUT_DIR/
  cp -r $SQL_TAP_DIR/suite.ini $OUTPUT_DIR/
fi
$TARANTOOL_BIN tcl2.lua $2 > $OUTPUT_DIR/$(basename $2)   
chmod +x $OUTPUT_DIR/$(basename $2)   
cd $TARANTOOL_TEST && ./test-run.py $(basename $OUTPUT_DIR) --force

