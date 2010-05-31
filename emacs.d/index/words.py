#!/usr/bin/env python


import pickle
from operator import itemgetter
from mkindex import Wordcount

db = pickle.load(open('index.pck','rb'))

allwords = Wordcount()
for page in db.itervalues():
    map(allwords.add, page['words'])

for (word,count) in sorted(
    allwords.iteritems(), key=itemgetter(1), reverse=True)[:100]:
    print '%4d %s' % (count,word)

