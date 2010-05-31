#!/usr/bin/python

import re, sys

db = {}

def comments(paths):
    # X: silly
    for path in paths:
        for line in open(path):
            print line
            if line.startswith(';'):
                yield (path, line)

datepat = re.compile('([\d ]*200\d[\d ]*)')
for (path,line) in comments(sys.argv[1:]):
    m = datepat.match(line)
    if not m:
        continue
    print '%-30s %s' % (path, m.groups(1))
