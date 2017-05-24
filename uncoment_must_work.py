import sys
import re
in_must_work = False
f = open(sys.argv[1], "r")
re.DOTALL = True
for line in f.readlines():
  if in_must_work:
    if re.match("^\s*$", line) or re.match("^\s*#.*", line):
      print line.replace("#", "  ", 1),
    else:
      print '}'
      print line,
      in_must_work = False
    continue
  print line,
  if re.match('^# MUST_WORK', line):
    print 'if {0>0} {'
    in_must_work = True

