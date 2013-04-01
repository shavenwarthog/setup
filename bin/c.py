#!/usr/bin/env python

'''
c -- given commit message, tag with Jira story ID
'''

import os, re, sys

def main(argv):
    branch_pat = re.compile('\*\sfeature/ent(\d+)')

    match = filter(None, map(branch_pat.match, 
                             os.popen('git branch').readlines()))
    if not match:
        sys.exit('ENT Feature branch not found')

    branch = 'ENT-{0}'.format(match[0].group(1))

    if not argv:
        print branch
        return

    msg = ' '.join(argv)
    print branch,msg
    cmd = """git commit -am '{msg} - {branch}'""".format(**locals())
    if 0:
        print cmd
    sys.exit( os.system(cmd) )



if __name__=='__main__':
    main(sys.argv[1:])

