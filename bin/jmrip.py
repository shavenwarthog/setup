#!/usr/bin/env python

'''
jmrip -- rip DVD, encode into single ISO
'''

import codecs, os, re, sys, time
from subprocess import PIPE, Popen
from itertools import ifilter, imap
from nose.tools import eq_ as eq

CONFIG = dict(
    videodir = os.path.expanduser('~/Videos'),
)

# http://www.fileformat.info/info/unicode/block/geometric_shapes/list.htm

class DzenStatus(dict):
    CONFIG = dict(
        DZEN      = 'dzen2 -ta 1 -tw 190 -fg %s -bg %s -p',
        PAUSE_FG  = "black",
        PAUSE_BG  = "green",
        PROGRESS  = "^fg(%s)^bg(%s)Cycle %d/%d: ",
        RECT      = "^r(6x6)^p(1)",
        RECT_OUTL = "^ro(6x6)^p(1)",
        SET_FG    = "^fg(%s)",
        WORK_BG   = "black",
        WORK_FG   = "yellow",
        DOTTED_CIRCLE = u'\x25db',
        DONE1 = u'\x25d4',
        )

    def __init__(self):
        super(DzenStatus,self).__init__(self.CONFIG)
        pipe = Popen(
            self.DZEN % (self.WORK_FG, self.WORK_BG),
            shell=True, stdin=PIPE,
            )
        self.dzen = codecs.getwriter('utf-8')(pipe)

    def sendline(self, line):
        
        self.dzen.stdin.write(line+'\n')
        self.dzen.stdin.flush()

    def __getattr__(self, key):
        return self[key]

def test_status():
    st = DzenStatus()
    st.sendline(u'beer\u25d4')
    time.sleep(5)

class DVDInfo(dict):
    def __init__(self, lines=None): # pylint: disable-msg=W0231
        if lines is None:
            lines = os.popen('dvdbackup --info 2>&1')
        self.parse(lines)

    def parse(self, lines):
        for m in ifilter(
            None,
            imap(re.compile('DVD with title (\S+)').search, lines)):
            self['title'] = m.group(1)

def rip():
    info = DVDInfo()
    if not info.get('title'):
        print >>sys.stderr, "no title found"
        sys.exit(1)

    print '%s -- ripping' % info['title']

    os.system('dvdbackup --mirror -o ~/Videos/ 2> /dev/null && eject')

    videodir = os.path.join(CONFIG['videodir'] % info['title'])
    if not os.path.isdir(videodir):
        print >>sys.stderr, '%s: DVD directory missing (%s)' % (
            sys.argv[0], videodir)
        sys.exit(1)

def make_isopath(title):
    return '~/Videos/%s.iso' % title

def convert(title, videodir, isopath):
    print '%s -- converting to ISO' % title

    isopath = os.path.expanduser(isopath)
    videodir = os.path.expanduser(videodir)
    cmd = ("genisoimage -dvd-video -o '%(isopath)s' '%(videodir)s' 2>&1 > /dev/null" % (
            locals()))
    print cmd
    stat = os.system(cmd)
    if stat:
        print >>sys.stderr, '%s: RIP okay, ISO failed (%s))' % (
            sys.argv[0], isopath)
        sys.exit(1)

def find_dirs():
    lines = os.popen('du -sh ~/Videos/*/VIDEO_TS')
    for line in lines:
        size,tsdir = line.strip().split(None,1)
        if size.endswith('G'):
            yield os.path.dirname(tsdir)

def scan_convert():
    for videodir in find_dirs():
        print videodir
        title = os.path.basename(videodir)
        isopath = make_isopath(title)
        if os.path.exists(isopath):
            print '- skipped'
        else:
            convert(title, videodir, isopath)

def main():
    # parser = optparse.OptionParser()
    # parser.add_option('', '--scan', 
    scan_convert()


if __name__=='__main__':
    main()

