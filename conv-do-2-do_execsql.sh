#!/bin/bash

# Converts:
# test:do_test("whereB-4.2", function()
#     return db("eval", [[
#         SELECT x, a, y=b FROM t1, t2 WHERE y=b;
#     ]])
# end, {
#     -- <whereB-4.2>
#     1, 2, 1
#     -- </whereB-4.2>
# })
# to:
# test:do_execsql_test(
#     "whereB-4.2",
#     [[
#         SELECT x, a, y=b FROM t1, t2 WHERE y=b;
#     ]],
#     {
#     -- <whereB-4.2>
#     1, 2, 1
#     -- </whereB-4.2>
#     })

if [ $# -ne 1 ]; then
    echo "Usage: $0 <path to single test>"
    exit 0
fi

perl -pe "s/do_test\(/do_execsql_test(\n    /; \
          s/, function\(\)/,/; \
          s/return db\(\"eval\", \[\[/\[\[/; \
          s/\]\]\)/\]\],/; \
          s/end, {/    {/; \
          s/^}\)/    }\)/" $1
