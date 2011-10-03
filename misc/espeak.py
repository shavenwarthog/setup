#!/usr/bin/env python

'''
espeak.py -- demo each of the English espeak voices
'''

import os, re, time
from itertools import ifilter, imap

# Pty Language Age/Gender VoiceName       File        Other Langs
#  5  en             M  default           default     

pat = re.compile('\s* \d+ \s+ (en\S*) \s+ \S \s+ (\S+)',re.VERBOSE)
for m in ifilter(None, imap(pat.match, os.popen('espeak --voices=en'))):
    lang,voice = m.groups()
    if '-' in lang:
        continue
    print voice
    os.system('espeak -v {0} "{0}... beer is good food" 2>/dev/null >/dev/null'.format(
            voice))
    time.sleep(3)

