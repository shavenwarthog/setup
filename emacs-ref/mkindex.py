#!/usr/bin/env python

'''
mkindex.py -- given a list of Emacs Lisp files, show description for each
'''

import gzip, os, re, sys
import util

FEATURES = '''(vc-arch vc-mtn vc-hg vc-git vc-bzr sha1 hex-util vc-sccs vc-svn vc-cvs vc-rcs vc vc-dispatcher executable tramp-imap assoc tramp-gw tramp-gvfs zeroconf url-util url-parse url-vars mm-util mail-prsvr dbus xml tramp-fish tramp-smb tramp-cache tramp-ftp tramp-cmds tramp auth-source gnus-util netrc time-date advice advice-preload shell password-cache format-spec tramp-compat trampver make-mode gnuplot derived regexp-opt edmacro kmacro help-fns cl cl-19 python-21 python ido which-func imenu perldoc thingatpt cperl-mode easymenu compile comint ring emacs-goodies-el emacs-goodies-custom emacs-goodies-loaddefs easy-mmode tooltip ediff-hook vc-hooks lisp-float-type mwheel x-win x-dnd font-setting tool-bar dnd fontset image fringe lisp-mode register page menu-bar rfn-eshadow timer select scroll-bar mldrag mouse jit-lock font-lock syntax facemenu font-core frame cham georgian utf-8-lang misc-lang vietnamese tibetan thai tai-viet lao korean japanese hebrew greek romanian slovak czech european ethiopic indian cyrillic chinese case-table epa-hook jka-cmpr-hook help simple abbrev loaddefs button minibuffer faces cus-face files text-properties overlay md5 base64 format env code-pages mule custom widget hashtable-print-readable backquote make-network-process dbusbind system-font-setting font-render-setting gtk x-toolkit x multi-tty emacs)'''

def featurep(name):
    return re.search('\W'+name+'\W', FEATURES)


print '''
<style type="text/css">
.feature { font-weight: bold; }
</style>
'''

for path in sys.argv[1:]:
    name = re.sub('\..+$', '', os.path.basename(path))
    line = gzip.GzipFile(path).readline()
    desc = re.sub('.+---\s*', '', line)
    desc = re.sub('-\*-.+', '', desc)
    pageuri = util.destpath(path, '.html')
    link = '<a href={0}>{1}</a> {2}<br/>'.format(
        pageuri, name, desc
        )
    if featurep(name):
        print '<span class="feature">{0}</span>'.format(link)
    else:
        print link


