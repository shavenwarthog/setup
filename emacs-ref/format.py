#!/usr/bin/env python

import os, subprocess, sys

for path in sys.argv[1:]:
    name = os.path.basename(path).replace('.gz','')
    newdir = 'lisp'
    cmd = ('gunzip < {path}'
           ' | pygmentize -o {newdir}/{name}.html' 
           ' -l scheme -O full').format(**locals())
    status = os.system(cmd)
    if status:
        print 'uhoh: status={0}, cmd={1}'.format(status, cmd)

    
