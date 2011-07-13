#!/usr/bin/env python

'''
goodskype.py -- pop up message when someone mentions me in Skype
'''

# http://stackp.online.fr/?p=40
# http://www.pygtk.org/docs/pygtk/gtk-stock-items.html
#
# test with:
# 	./goodskype.py -eChatIncoming '-nEcho Test' -mExample@johnm -uecho123



# ("-e", "--event", dest="type", help="type of SKYPE_EVENT")
# ("-n", "--sname", dest="sname", help="display-name of contact")
# ("-u", "--skype", dest="sskype", help="skype-username of contact")
# ("-m", "--smessage", dest="smessage", help="message body", metavar="FILE")
# ("-p", "--path", dest="fpath", help="path to file")
# ("-s", "--size", dest="fsize", help="incoming file size")
# ("-f", "--filename", dest="fname", help="file name", metavar="FILE")

import logging, sys
try:
    import pynotify
except ImportError:
    print >>sys.stderr, "apt-get install python-notify"
    sys.exit(1)

if not pynotify.init("Skype Notification"):
    print >>sys.stderr, "init failed" 
    sys.exit(1)

ICON = "/usr/share/icons/skype.png" 
ICON = '/usr/share/skype/avatars/Skypers of the Caribbean.png' # mustache!
# icon = 'dialog-warning'
ALERT_WORDS = ('@all', '@john', '@johnm', '@backend')

logging.basicConfig(
    filename='/tmp/goodskype.log',
    level=logging.INFO,
    )

try:

    # parse "-eSkypeLogin" => {'e': 'SkypeLogin'}
    # ignore args not passed in
    msg = dict( (
            (arg[1], arg[2:])
            for arg in sys.argv[1:]
            if len(arg) > 2 and arg[2] != '%'
            ) )
    logging.debug('message = %r', msg)

    def important(message, alert_words):
        text = message.get('m','')
        return any( (n in text for n in alert_words) )

    if msg.get('e') != 'ChatIncoming' or not important(msg, ALERT_WORDS):
        logging.debug('(not incoming/important)')
        sys.exit(0)

    # {'m': 'afk ~ 15m', 'e': 'ChatIncoming', 'u': 'elms76', 'n': 'Elmer Z @elmer'}

    title = msg.get('n') or '?name'
    text  = msg.get('m') or '?msg'
    notification = pynotify.Notification(title, text, ICON)
    # notification.set_timeout(pynotify.EXPIRES_NEVER)
    notification.show()

except Exception:
    logging.exception('uhoh')
    
