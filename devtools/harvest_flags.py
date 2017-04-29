import __future__
from sys import argv
from re import findall

"""
    Harvest flag diacritics from lexc files. 

    USAGE: python harvest_flags file1.lexc file2.lexc ...
"""

flags = set()

for fn in argv[1:]:
    flags.update(findall(r'@[A-Z][.][^.@]+[.][^.@]+@', open(fn).read()))
    flags.update(findall(r'@[A-Z][.][^.@]+@', open(fn).read()))

for flag in flags:
    print(flag)

