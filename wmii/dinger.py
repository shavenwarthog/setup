#!/usr/bin/env python2.6

# ./dinger 'bash -c "fortune -o ; sleep 3 ; fortune -o"'

import logging, os, sys, time
from itertools import ifilter
from optparse import OptionParser

logging.basicConfig(
    stream=sys.stderr,
    # filename='/tmp/dinger.log',
    level=logging.DEBUG,
    format="%(asctime)s %(filename)s:%(lineno)d %(process)d %(message)s",
    )

# ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
from popen2 import Popen4

def runme(cmd):
    p = Popen4(cmd)
    while p.poll() == -1:
        block = p.fromchild.read()
        yield block
        time.sleep(1)
    yield p.wait()              # return code, a number

# ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


def procs_strace(pids):
    args = ' '.join( ('-p {0}'.format(pid) for pid in pids) )
    return os.popen('strace {0}'.format(args))

def proc_info(pid):
    info = {}
    for line in open('/proc/%s/status' % pid):
        key,value = line.split(':')
        info[key] = value.strip()
    cmdline_raw = open('/proc/%s/cmdline' % pid).read()
    info['cmdline'] = ' '.join(cmdline_raw.split('\0'))
    return info

def proc_missing(pid, verbose=0):
    try:
        os.kill(int(pid), 0)
        if verbose: print pid,'ok'
        return False
    except OSError:
        if verbose: print pid,'GONE'
        return True

def proc_children(parent_pid):
    return set(map(int, os.popen('pgrep -P%s' % parent_pid)))

def proc_vulture(pids):
    '''wait until a process dies, return its id'''
    while 1:
        for pid in pids:
            if proc_missing(pid):
                return pid
        try:
            time.sleep(1)
        except KeyboardInterrupt:
            return None

def make_colordb():
    path = '/etc/X11/rgb.txt'
    rows = open(path)
    rows = ifilter(lambda row: len(row)==4, 
                   (line.strip().split() for line in rows)
                   )
    return dict(
        ( (name, '#%02x%02x%02x' % (int(r),int(g),int(b)))
          for r,g,b,name in rows )
        )

WM_COLORS = dict(
    norm = '#000000 #c1c48b #81654f', # foreground background border
    focus = '#000000 #81654f #000000',
    )
STATUS_COLORS = dict(
    start = 'norm',
    okay = 'green4',
    error = 'firebrick2',
    )
COLORDB = make_colordb()
TIMEOUT = 15                    # seconds

# ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

def system(cmd):
    if 0:
        print '>>>', cmd
    st = os.system(cmd)
    if st:
        print >>sys.stderr, '** error, status=%d', st
    return st

def make_color_triple(color, border=None):
    # forground background border
    outcols = WM_COLORS.get(color,'').split()
    if not outcols:
        bg = COLORDB.get(color)
        if bg:
            outcols = WM_COLORS['norm'].split()
            outcols[1] = bg
    if border:
        outcols[-1] = COLORDB.get(border, border)
    return ' '.join(outcols)


# class StatusBar(object):
#     @classmethod
#     def Control(_, args, verb='write'): # pylint: disable=W0613
#         cmd = "/home/johnm/local/bin/wmiir %(verb)s /rbar/project" % locals()
#         pipe = subprocess.Popen(cmd, shell=True, stdin=subprocess.PIPE)
#         pipe.communicate(input=' '.join(args))
#         return pipe.returncode

#     @classmethod
#     def Display(klass, msg, color='norm', border=None):
#         return klass.Control( [make_color_triple(color, border)] + list(msg) )

#     @classmethod
#     def Create(klass):
#         return klass.Control('', verb='create')




# ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

# class Plugin(object):
#     def __init__(self, msg):
#         self.msg = msg
#         self.start()
#     def start(self):
#         pass
#     def stop(self, status):
#         pass

# def timestr(elapsed):
#     return '%.1f sec' % elapsed if elapsed < 60. else '%.1f min' % (elapsed/60.)
# def status_color(status):
#     return STATUS_COLORS['okay' if status==0 else 'error' ]

# class Elapsed(Plugin):
#     def elapsed(self):
#         return time.time() - self.start_tm
#     def start(self):
#         self.start_tm = time.time() # pylint: disable=W0201
#     def stop(self, status):
#         bar_write(
#             msg=self.message(),
#             color=status_color(status),
#             )
#     def message(self):
#         return self.msg + ['[%s]' % timestr(self.elapsed())]

# ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

def get_children(parent_pid):
    cmd_pids = set()
    for pid in proc_children(int(parent_pid)):
        cmd_pids |= proc_children(pid)
    return cmd_pids

def watch_pids(pids):
    # print 'waiting for %s' % pids
    # print 'parent: {cmdline}'.format(**proc_info(pids))
    allinfo = dict( (pid,proc_info(pid)) for pid in pids )
    # print allinfo
    print 'watching:'
    for pid in pids:
        print '- {cmdline}'.format(**allinfo[pid])
    summary = sorted( (info['cmdline'].split()[0]
                       for info in allinfo.values()) )
    bar_write(msg=summary, colors='LightGoldenrod')

    pid_completed = proc_vulture(pids)
    if not pid_completed:
        return
    cmdline = allinfo[pid_completed]['cmdline']
    print 'completed: %s' % cmdline
    bar_write(msg=[cmdline], color='DarkGoldenrod') # XXX exit status

def lookup_colors(name):
    cols = os.environ.get('WMII_%sCOLORS'%name.upper())
    if cols:
        return cols             # for 'norm' and 'focus'

def bar_write(msg, colors=None):
    cols = lookup_colors(colors)
    p = os.popen('wmiir write /rbar/project', 'w')
    if cols:
        p.write('%s '%cols)
    p.write(msg)
    p.close()

# ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

def main(args=None):
    # skip if working remotely
    if ':0' not in os.environ.get('DISPLAY',''):
        sys.exit(2)
    if args is None:
        args = sys.argv[1:]

    parser = OptionParser()
    parser.add_option("-P", dest="parent_pid")
    parser.add_option("--color", dest="color")

    (options, args) = parser.parse_args()

    if options.parent_pid:
        pids = set([int(options.parent_pid)])
        pids |= get_children(options.parent_pid)
        pids.discard(os.getpid())
        watch_pids(pids)
        return

    if not args:
        args = ['norm']
    if args[0] in set(WM_COLORS)|set(COLORDB):
        options.color = args.pop(0)
        bar_write(msg=list(args), color=options.color)
        return

    StatusBar.Create()

    cmd = list(args)
    msg = cmd
    el = Elapsed(msg)
    bar_write(msg=msg, colors=STATUS_COLORS['start'])

    # kill previous "unhighlight" process, if any
    os.system('killall dinger 2> /dev/null')

    st = None
    lastline = ' '.join(cmd)
    for block in runme(cmd):
        if type(block) is int:
            st = block
            break
        if 1:
            print block
        lines = filter(None, block.split('\n'))
        if lines:
            lastline = lines[-1]
        msg = [lastline, '... %s' % timestr(el.elapsed())]
        bar_write(msg=msg)
        time.sleep(1)

    msg = el.message()
    el.stop(status=st)

    # return to caller, but unhighlight after 15 seconds
    if os.fork():
        return                  # parent

    logging.info('child')
    try:
        time.sleep(TIMEOUT)
        bar_write(msg=msg, border=status_color(st))
    except Exception:
        logging.critical('child', exc_info=True)
        raise
    logging.info('child exit msg=%s status=%s', msg, status_color(st))
    os._exit(0)

if __name__=='__main__':
    bar_write('beer', 'norm')
