def __py_complete_sort(x,y):
    if len(x) < len(y):
      return -1
    elif len(y) < len(x):
      return 1
    else:
      if x < y:
        return -1
      elif y < x:
        return 1
      else:
        return 0
def __py_completions(str, domains):
    r = []
    for list in domains:
        if not list is None:
            for e in list:
                if e.startswith(str) and not e in r:
                    r.append(e)
    r.sort(__py_complete_sort)
    return r

def __py_complete_string(str, file, globals, locals):
    from os.path import basename, dirname
    from keyword import kwlist
    r = []

    # find elements in module namespace
    if file and file.endswith('.py'):
        try:
            module = basename(file)[:-3]
            if module == '__init__':
                module = basename(dirname(file))
            last_dot = str.rfind('.')
            if last_dot == -1:
                prefix = ''
                end = str
                domains = [ dir(eval(module, globals, locals)) ]
            else:
                prefix = '%s.' % str[:last_dot]
                end = str[last_dot+1:]
                domains = [ dir(eval(prefix[:-1], globals, locals)) ]
            r += [ '%s%s' % (prefix, c)
                   for c in __py_completions(end, domains) ]
        except:
            import traceback
            traceback.print_exc()
            pass

    # find elements in interpreters namespace
    try:
        last_dot = str.rfind('.')
        if last_dot == -1:
            prefix = ''
            end = str
            domains = [ locals, globals, kwlist ]
        else:
            prefix = '%s.' % str[:last_dot]
            end = str[last_dot+1:]
            domains = [ dir(eval(prefix[:-1], globals, locals)) ]
        r += [ '%s%s' % (prefix, c)
               for c in __py_completions(end, domains) ]
    except:
        # no luck, that is OK
        import traceback
        traceback.print_exc() 
        pass
        
    return r


def __py_signature(f):
  import inspect
  if inspect.ismethod(f): f = f.im_func
  if not inspect.isfunction(f): return None
  (args, varargs, varkw, defaults) = inspect.getargspec(f)
  return('%s: %s'
         % (f.__name__, inspect.formatargspec(args,varargs,varkw,defaults)))
print 'py_complete loaded'
