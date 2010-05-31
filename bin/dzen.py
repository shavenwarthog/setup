#!/usr/bin/env python

'''
jmrip -- rip DVD, encode into single ISO
'''

import codecs, sys, time
from subprocess import PIPE, Popen
from nose.tools import eq_ as eq

# http://www.fileformat.info/info/unicode/block/geometric_shapes/list.htm

class DzenStatus(dict):
    CONFIG = dict(
        DZEN      = ("dzen2 -ta 1 -tw 190 -fg %(WORK_FG)s -bg %(WORK_BG)s"
                     " -p -fn '%(FONT)s'"
                     ),
        FONT	 = '-*-DejaVu Sans Mono-medium-r-normal-*',
        PAUSE_FG  = "black",
        PAUSE_BG  = "green",
        PROGRESS  = "^fg(%s)^bg(%s)Cycle %d/%d: ",
        RECT      = "^r(6x6)^p(1)",
        RECT_OUTL = "^ro(6x6)^p(1)",
        SET_FG    = "^fg(%s)",
        WORK_BG   = "black",
        WORK_FG   = "yellow",
        # DOTTED_CIRCLE = u'\u25db', # X: envelope!
        DONE0 = '-',
        DONE25 = u'\u25d4',
        )

    def __init__(self):
        super(DzenStatus,self).__init__(self.CONFIG)
        self.pipe = Popen(
            self.DZEN % self,
            shell=True, stdin=PIPE,
            )
        self.dzen = codecs.getwriter('utf-8')(self.pipe.stdin)

    def sendline(self, line):
        print u'dzen: %s' % line
        self.dzen.write(line+'\n')
        self.dzen.flush()

    def __getattr__(self, key):
        return self[key]

def test_status():
    st = DzenStatus()
    st.sendline(u'starting: %s' % st.DONE0)
    time.sleep(2)
    st.sendline(u'25%% %s' % st.DONE25)
    time.sleep(2)
    # st.sendline('50% %s' % st.DOTTED_CIRCLE)
    # time.sleep(2)
