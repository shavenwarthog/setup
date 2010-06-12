#!/usr/bin/env python

'''
jmrip -- rip DVD, encode into single ISO
'''

import codecs, time
from subprocess import PIPE, Popen
# from nose.tools import eq_ as eq

# unicode characters:
# - http://www.fileformat.info/info/unicode/block/geometric_shapes/list.htm
# display of local fonts(!):
# - http://www.fileformat.info/info/unicode/font/fontlist.htm
# good special symbols:
# http://www.fileformat.info/info/unicode/category/So/list.htm

class DzenStatus(dict):
    CONFIG = dict(
        DZEN      = ("dzen2 -ta 1 -tw 190 -fg %(WORK_FG)s -bg %(WORK_BG)s"
                     " -p -fn '%(FONT)s'"
                     ),
        FONT	 = '-*-DejaVu Sans Mono-medium-r-normal-*-0-*',
        # FONT	= '*DejaVu Sans Mono*',
        PAUSE_FG  = "black",
        PAUSE_BG  = "green",
        PROGRESS  = "^fg(%s)^bg(%s)Cycle %d/%d: ",
        RECT      = "^r(6x6)^p(1)",
        RECT_OUTL = "^ro(6x6)^p(1)",
        SET_FG    = "^fg(%s)",
        WORK_BG   = "black",
        WORK_FG   = "yellow",
        # DOTTED_CIRCLE = u'\u25db', # X: envelope!
        DONE0 = u'\u25db', # X: envelope!
        DONE25 = u'\u25d4',
        DONE50 = u'\u25d1',     # X: doesnt work
        DONE75 = u'\u25d5',
        DONE100 = u'\u25cf',    # X: doesnt work
        DONE_OKAY = u"\u2713",  # check mark
        DONE_ERR = u"\u2717", # ballot x
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
        self.dzen.write((unicode(line)))
        self.dzen.write('\n')
        self.dzen.flush()

    def char_done(self, code):
        if type(code) is not int:
            code = {True:'_OKAY', False:'_ERR'}[code]
        return self.get('DONE%s' % code)

    def __getattr__(self, key):
        return self[key]

def test_status():
    st = DzenStatus()
    st.sendline(u'starting: %s' % st.DONE0)
    for code in (0,25,50,75,100,False,True):
        st.sendline(u'code %s - %s' % (code, st.char_done(code)))
        time.sleep(2)
    # st.sendline(u'25%% %s' % st.DONE25)
    # time.sleep(2)
    # st.sendline('50% %s' % st.DOTTED_CIRCLE)
    # time.sleep(2)
