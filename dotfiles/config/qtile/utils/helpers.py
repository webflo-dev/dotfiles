from os.path import expanduser
from re import search

def dpi(value):
    Xresources = expanduser("~/.Xresources")
    with open(Xresources) as X:
        xrdb = X.readlines()

    dpi = 96
    for line in xrdb:
        if search('dpi', line):
            dpi = line.split(':')[1].strip()

    return int(value * int(dpi) / 96)