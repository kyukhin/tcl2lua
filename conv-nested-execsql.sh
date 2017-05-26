#!/bin/bash

# Replace patterns like this:
# test:do_execsql_test(
#     "1.5",
#     [[
#       SELECT b,a,c FROM t1 ORDER BY b DESC,a,c;
#      ]], {
#        test:execsql "SELECT b,a,c FROM t1 ORDER BY +b DESC,+a,+c"
#     })
# with this:
#  test:do_execsql_test(
#      "1.5",
#      [[
#        SELECT b,a,c FROM t1 ORDER BY b DESC,a,c;
#       ]],
#      test:execsql "SELECT b,a,c FROM t1 ORDER BY +b DESC,+a,+c"
#      )

perl -e ' $a = join "", <> ;
          #          1             2            3         4                                               5
          $a =~ s/ { ( [\ \t]*\n ) (  [^\n]*  ) ( \s{4} ) ( test:execsql [\ \t]+ " [^\n]+  " [\t\ ]*\n )  ( \s*  )  } /$1$2$4$5/gx ;
          print $a ' $1
