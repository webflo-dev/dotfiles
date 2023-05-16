import subprocess

def read_xresources(prefix):
    props = {}
    x = subprocess.run(["xrdb", "-query"], stdout=subprocess.PIPE)
    lines = x.stdout.decode().split("\n")
    for line in filter(lambda l: l.startswith(prefix), lines):
        prop, _, value = line.partition(":\t")
        props[prop[len(prefix + ".")::]] = value
    return props

colors = read_xresources("*")


# import os
# def xresources():
#     props = {}
#     prefix = "*."
#     file = os.path.expanduser("~/.config/X11/xresources")
#     with open(file) as X:
#         lines = X.readlines()
#         for line in filter(lambda l: l.startswith(prefix), lines):
#             values = line.splitlines()[0].split(":")
#             props[values[0][len(prefix)::]] = values[1].strip()
#     return props

# colors = xresources()
