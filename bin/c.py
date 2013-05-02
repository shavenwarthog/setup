#!/usr/bin/env python

'''
c -- given commit message and "git flow", tag with Jira story ID
'''

import os, re, sys

def main(argv):
    branch_pat = re.compile('\*\sfeature/ent(\d+)')

    match = filter(None, map(branch_pat.match, 
                             os.popen('git branch').readlines()))
    branch = None
    msg = ' '.join(argv)        # pylint: disable=W0612
    if match:
        branch = 'ENT-{0}'.format(match[0].group(1))
        msg += ' - {branch}'.format(**locals())

    if not argv:
        print branch
        return

    cmd = """git commit -am '{msg}'""".format(**locals())
    sys.exit( os.system(cmd) )



if __name__=='__main__':
    main(sys.argv[1:])

