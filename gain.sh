#!/bin/bash

# Usage: $0 convert_suite_stderr convert_suite_dst_dir

echo "fully processed files: $(grep -Rc X\! $2 | grep :0\$ | cut -d: -f1 | sed 's@^dst[^/]\+/@@' | wc -l)"
grep -Rc X\! $2 | grep :0\$ | cut -d: -f1 | sed 's@^dst[^/]\+/@@'
echo "unprocessed expressions: $((grep -v 'creating Jim interpretor\|\[total cmds\]' $1 | grep 'X!' | sort | cut -d: -f2 | tr '\n' '+'; echo 0) | bc)"
echo

for w in "foreach" "for" "expr" "expr01" "cmd" "capable" "case" "procname"; do
    echo -n "$w "
    (grep -v 'creating Jim interpretor\|\[total cmds\]' $1 | grep 'X!' | sort | grep ${w}\" | cut -d: -f2 | tr '\n' '+'; echo 0) | bc
done | sort -nk2,2 -r | column -t

echo
echo "unprocessed cmds:"
grep -R X\!cmd $2 | cut -d\! -f2 | cut -d\" -f3 | sort | uniq -c | sort -nk1,1 -r

echo
echo "unprocessed expressions per file:"
grep -Rc X\! $2 | grep -v ':0$' | tr : ' ' | sort -nk2,2 -r | column -t

echo
echo "w/ one unprocessed instr:"
for f in $(grep -Rc X\! $2 | tr : ' ' | sort -nk2,2 -r | column -t | grep ' 1$' | cut -d' ' -f1); do
    echo "$f: $(grep X\! $f | sed 's@^.*X!@@')"
done
