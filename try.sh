#!/bin/bash
TARANTOOL_SRC=$1
TARANTOOL_BIN="$TARANTOOL_SRC/src/tarantool"
TARANTOOL_TEST="$TARANTOOL_SRC/test/"
OUTPUT_DIR="$TARANTOOL_TEST/sql-tap-try/"
SQL_TAP_DIR="$TARANTOOL_TEST/sql-tap/"
TMP_FILE="/tmp/tcl2lua.tmp"
if ! [ -d $OUTPUT_DIR ]; then
  mkdir $OUTPUT_DIR
  cp -r $SQL_TAP_DIR/lua $OUTPUT_DIR/
  cp -r $SQL_TAP_DIR/suite.ini $OUTPUT_DIR/
fi
if [[ $# -eq 2 ]]; then
  python uncoment_must_work.py $2 > $TMP_FILE
  $TARANTOOL_BIN tcl2.lua $TMP_FILE > $OUTPUT_DIR/$(basename $2)   
  chmod +x $OUTPUT_DIR/$(basename $2)   
fi
cd $TARANTOOL_TEST && ./test-run.py $(basename $OUTPUT_DIR) --force

