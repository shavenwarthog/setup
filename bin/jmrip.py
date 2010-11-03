#!/usr/bin/env python

'''
jmrip -- rip DVD, encode into single ISO

aka:
  dvdbackup -o ~/Videos/ --mirror && eject ; title=`/bin/ls -1td [A-Z]* | head -1` \
  ; mkisofs -dvd-video -o "$title.iso" "$title" && mv "$title" outgoing/

'''

import codecs, os, re, sys, time
from subprocess import PIPE, Popen
from itertools import ifilter, imap
from nose.tools import eq_ as eq

CONFIG = dict(
    videodir = os.path.expanduser('~/Videos'),
)


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

def status(msg):
    print msg


def rip(info):
    if not info.get('title'):
        print >>sys.stderr, "no title found"
        sys.exit(1)

    status('%s -- ripping' % info['title'])

    os.system('dvdbackup --mirror -o {videodir}/ 2> /dev/null && eject'.format(**CONFIG))

def rip_check(info):
    try:
        videodir = os.path.join(CONFIG['videodir'], info['title'])
    except KeyError:
        print >>sys.stderr, '%s: no title' % sys.argv[0]
        sys.exit(1)
        
    if not os.path.isdir(videodir):
        print >>sys.stderr, '%s: DVD directory missing (%s)' % (
            sys.argv[0], videodir)
        sys.exit(1)

def make_isopath(title):
    return '~/Videos/%s.iso' % title

def convert(title, videodir, isopath):
    status('%s -- converting to ISO' % title)

    isopath = os.path.expanduser(isopath)
    videodir = os.path.expanduser(videodir)
    cmd = ("genisoimage -dvd-video -o '%(isopath)s' '%(videodir)s' 2>&1" % (
            locals()))
    status(cmd)
    stat = os.system(cmd)
    if stat:
        print >>sys.stderr, '%s: RIP okay, ISO failed (%s))' % (
            sys.argv[0], isopath)
        sys.exit(1)

def find_dirs():
    lines = os.popen('du -sh {videodir}/*/VIDEO_TS'.format(**CONFIG))
    for line in lines:
        size,tsdir = line.strip().split(None,1)
        if size.endswith('G'):
            yield os.path.dirname(tsdir)

def scan_convert():
    "Pack each DVD directory (with VIDEO_TS) into an ISO"
    for videodir in find_dirs():
        status(videodir)
        title = os.path.basename(videodir)
        isopath = make_isopath(title)
        if os.path.exists(isopath):
            status('- skipped')
        else:
            convert(title, videodir, isopath)

def main():
    # parser = optparse.OptionParser()
    # parser.add_option('', '--scan', 
    if 01:
        info = DVDInfo()
        rip(info)
        rip_check(info)
    if 1:
        scan_convert()


if __name__=='__main__':
    main()

