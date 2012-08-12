import os, re

def destpath(path, suffix):
    path = os.path.splitext(path)[0]
    return (
        re.sub('.+/2[0-9.]+/', '', path)
        + suffix
        )

