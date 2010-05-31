#!/usr/bin/env python

'''
jmrip -- rip DVD, encode into single ISO
'''

import codecs, os, re, sys, time
from subprocess import PIPE, Popen
from itertools import ifilter, imap
from nose.tools import eq_ as eq

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
        self.pipe = Popen(
            self.DZEN % (self.WORK_FG, self.WORK_BG),
            shell=True, stdin=PIPE,
            )
        self.dzen = codecs.getwriter('utf-8')(self.pipe.stdin)

    def sendline(self, line):
        
        self.dzen.write(line+'\n')
        self.dzen.flush()

    def __getattr__(self, key):
        return self[key]

def test_status():
    st = DzenStatus()
    st.sendline(u'beer\u25d4')
    time.sleep(5)
