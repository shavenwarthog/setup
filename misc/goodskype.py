#!/usr/bin/env python

'''
goodskype.py -- pop up message when someone mentions me in Skype

INSTALL:
Skype / Options; Notifications; Advanced View
enable Execute on Any Event, following in one line:
	<PATH>/goodskype.py  -e"%type" -n"%sname" -f"%fname"
	-p"%fpath" -m"%smessage" -s%fsize -u%sskype
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

import ConfigParser, logging, re, StringIO, sys
from optparse import OptionParser
try:
    import pynotify
except ImportError:
    print >>sys.stderr, "apt-get install python-notify"
    sys.exit(1)

if not pynotify.init("Skype Notification"):
    print >>sys.stderr, "init failed" 
    sys.exit(1)


CONFIG = '''
[default]
icon: /usr/share/icons/skype.png
# mustache!
icon: /usr/share/skype/avatars/Skypers of the Caribbean.png
# icon = 'dialog-warning'
alert_words: @john @johnm @cali
alert_users: goz
'''

# ::::::::::::::::::::::::::::::::::::::::::::::::::


def parseconfig(configstr):
    par = ConfigParser.SafeConfigParser()
    par.readfp( StringIO.StringIO(configstr) )
    return dict(par.items('default'))


def splitwords(line):
    return filter(None, re.split('[^a-zA-Z0-9_@]', line))


def parse_skypeargs(args):
    # parse "-eSkypeLogin" => {'e': 'SkypeLogin'}
    # ignore args not passed in
    return dict( (
            (arg[1], arg[2:])
            for arg in args
            if len(arg) > 2 and arg[2] != '%'
            ) )


def notify(conf, args):
    msg = parse_skypeargs(args)
    alerts = conf['alert_words'].split()
    users = conf['alert_users'].split()
    logging.debug('message=%r', msg)

    if msg.get('e') != 'ChatIncoming':
        logging.debug('(not incoming)')
        sys.exit(0)

    def important(message, alert_words):
        text = splitwords( message.get('m','').lower() )
        return any( (n in text for n in alert_words) )

    if not (
        msg.get('u') in users
        or important(msg, alerts)
        ):
        logging.debug('(not important)')
        sys.exit(0)

    # example message:
    # 	{'m': 'afk ~ 15m', 'e': 'ChatIncoming', 'u': 'elms7',
    # 	'n': 'Elmer Z @elmer'}

    title = msg.get('n') or '?name'
    text  = msg.get('m') or '?msg'
    notification = pynotify.Notification(title, text, conf.get('icon'))
    notification.show()


def main():
    parser = OptionParser()
     # parser.add_option('-v', '--verbose', dest='verbose', default=True,
     #                   help='extra logging to /tmp/goodskype.log')

    logging.basicConfig(
        filename='/tmp/goodskype.log',
        level=logging.DEBUG#  if opts.verbose else logging.INFO,
        )

    try:
        # opts,_ = parser.parse_args()
        notify( parseconfig(CONFIG), sys.argv[1:] )
    except Exception:
        logging.exception('uhoh')
        sys.exit(1)


if __name__=='__main__':
    main()

