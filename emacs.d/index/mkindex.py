#!/usr/bin/python

'''
mkindex.py -- collect metadata from Emacs packages
'''
import fileinput, glob, os, re, sys
from collections import defaultdict
from itertools import imap


class Wordcount(dict):
    def __missing__(self,key):
        self[key] = 0
        return self[key]

    def add(self, word, num=1):
        self[word] += num

class Page(dict):
    def __init__(self, **kwargs):
        super(Page,self).__init__(kwargs)
        self['words'] = Wordcount()

    def addWords(self, words):
        ADD = self['words'].add
        [ ADD(w) for w in words ]
        # self.setdefault('words',set()).update(words)

    def addDate(self, dt):
        self.setdefault('_dates',set()).add(dt)
    def fixup(self):
        # self['name'] = self.MakeName(self['path'])
        dateset = self.get('_dates')
        if not dateset:
            return
        self['date'] = sorted(dateset)[-1] # most recent

    @classmethod
    def MakeName(klass, path):
        return os.path.splitext(os.path.basename(path))[0]


def makepage(name, lines):
    wordsplit = re.compile('[^a-zA-Z-/]') # XX sort of
    datepat = re.compile('(200\d[\d-]*)')
    keyvalpat = re.compile('([A-Z]\S+):\s+(.+)')
    page = Page(name=name)
    page['numlines'] = len(lines)

    def parseline(line):
        if not line.startswith(';'):
            line = re.sub(';.*', '', line)
            page.addWords( wordsplit.split(line) )
            return
        if not page.has_key('title') and ' --- ' in line:
            page['title'] = line.strip()

        # key/value in header, Example: "Author: woo"
        m = keyvalpat.search(line)
        if m:
            page[m.group(1)] = m.group(2)
        m = datepat.search(line)
        if m:
            page.addDate(m.group(1))

    map(parseline, lines)
    page.fixup()
    return page


def main():
    paths = sys.argv[1:] or glob.glob('../emacswikipages/*.el')
    # paths = [paths[0]]

    import string

    db = {}
    for path in paths:
        name = Page.MakeName(path)
        print path
        db[name] = page = makepage(name, open(path).readlines())

        print '%-30s %-11s %4d %s' % (
            page['name'], page.get('date'), 
            page['numlines'], page.get('title',''))
        if 0:
            print '\t', ' '.join( ['%s=%s' % (key,val) 
                                   for key,val in sorted(page.items()) 
                                   if key[0] in string.uppercase] )

    if 01:
        import pickle
        # flatten, removing classes
        db = dict( ((key,dict(value)) for (key,value) in db.iteritems()) )
        for page in bdb.itervalues():
            page['words'] = dict(page['words'])
        pickle.dump(db, open('index.pck','wb'), pickle.HIGHEST_PROTOCOL)
