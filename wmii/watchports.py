#!/usr/bin/env python2.6

import os, re
from collections import defaultdict
from itertools import ifilter, imap

def readconf(path, keyfmt):
    db = dict()
    port_pat = re.compile('DEPLOY_(.+)_PORT.*=(\d+)')
    for m in ifilter(None, imap(port_pat.match, 
                                open(path))):
        db[keyfmt.format(m.group(1))] = int(m.group(2))
    return db

def proc_label(info):
    return '{0}/{1}'.format(info['cmd'], info['pid'])

def conn_label(info, serverport):
    plabel = format(proc_label(info))
    writer = info['ports'].index(serverport)
    temp = '?' if 'CLOSE_WAIT' in info['detail'] else ''
    if writer:
        return '<:{1}({0}){2}'.format(plabel, info['ports'][0], temp)
    return '>:{1}({0}){2}'.format(plabel, info['ports'][1], temp)

def scanports(ports):
    port_pat = re.compile(':(\d+)\D')
    conn_pat = re.compile('(\S+)\s+(\d+).+TCP\s+(.+)')
    lines = os.popen('lsof +c0 -ni 4TCP:{0}'.format(
            ','.join(imap(str, ports))))
    for m in ifilter(None, imap(conn_pat.match, lines)):
        info = dict(cmd=m.group(1), pid=int(m.group(2)),
                    detail=m.group(3))
        info['ports'] = [int(p) for p in 
                         port_pat.findall(info['detail'])]
        yield info
        

def main():
    port_db = dict()
    port_db.update( readconf('/tmp/oceania_dev.conf', 'oc_{0}') )
    port_db.update( readconf('/tmp/minitrue_dev.conf', 'min_{0}') )

    myports = set(port_db.values())
    myconn = defaultdict(list)
    for info in scanports(myports):
        for port in info['ports']:
            myconn[port].append(info)

    for name,port in sorted(port_db.iteritems()):
        print '{0} :{1}'.format(name, port)
        servers = []
        clients = []
        for info in myconn[port]:
            if 'LISTEN' in info['detail']:
                servers.append(info)
            else:
                clients.append(info)
        print '*', ' '.join(sorted(imap(proc_label, servers)))
        if clients:
            print '- ', ' '.join(sorted(
                    ( conn_label(conn, port) for conn in clients )
                    ))
main()

