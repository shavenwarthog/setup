import os, time

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
