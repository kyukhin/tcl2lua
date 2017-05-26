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

shift

while (( "$#" )); do
  python uncoment_must_work.py $1 > $TMP_FILE
  $TARANTOOL_BIN tcl2.lua $TMP_FILE > $OUTPUT_DIR/$(basename $1)   
  ./conv-update-test-plan.sh $OUTPUT_DIR/$(basename $1)
  chmod +x $OUTPUT_DIR/$(basename $1)   
  shift
done
echo "Lol"
cd $TARANTOOL_TEST && ./test-run.py $(basename $OUTPUT_DIR) --force

