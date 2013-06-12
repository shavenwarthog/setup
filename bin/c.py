#!/usr/bin/env python

'''
c -- given commit message and "git flow", tag with Jira story ID
'''

import os, re, sys

def main(argv):
    branch_pat = re.compile('\*\sfeature/([a-z]+)(\d+)')

    match = filter(None, map(branch_pat.match, 
                             os.popen('git branch').readlines()))
    branch = None
    msg = ' '.join(argv)        # pylint: disable=W0612
    if match:
        name = match[0].group(1)
        if name=='ent':
            name = name.upper()
        if name=='ENT':
            branch = '{}-{}'.format(
                name,  # "issue" or "ENT"
                match[0].group(2),
                )

            msg += ' - {branch}'.format(**locals())

    if not argv:
        print branch
        return

    cmd = """git commit -am '{msg}'""".format(**locals())
    sys.exit( os.system(cmd) )



if __name__=='__main__':
    main(sys.argv[1:])

