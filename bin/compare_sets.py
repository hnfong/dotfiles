#!/usr/bin/env python3

# TODO: may want to add this: https://code.activestate.com/recipes/576694/

import sys
import os
import csv

def is_cjk_cp(cp):
        return (0x3400 <= cp <= 0x4DBF) or (0x4E00 <= cp <= 0x9FFF) or (0xF900 <= cp <= 0xFAFF) or (0x20000 <= cp <= 0x2FFFF)

def cjk_only(s):
    return ''.join(c for c in s if is_cjk_cp(ord(c)))

def smart_open(path):
    if path.endswith('.gz'):
        import gzip
        return gzip.open(path, 'rt', encoding='utf-8')
    elif path.endswith('.bz2'):
        import bz2
        return bz2.open(path, 'rt', encoding='utf-8')
    elif path.endswith('.xz'):
        import lzma
        return lzma.open(path, 'rt', encoding='utf-8')
    elif path == '-':
        return sys.stdin
    else:
        return open(path, 'r', encoding='utf-8')

def file2set(file, args):
    result = set()

    file_type = None
    if '.csv' in file:
        file_type = 'csv'
    elif '.tsv' in file:
        file_type = 'tsv'

    if file_type in ['csv', 'tsv']:
        # Handle CSV, args is the column number
        with smart_open(file) as f:
            reader = csv.reader(f, delimiter='\t' if file_type == 'tsv' else ',')
            if not args.isdigit(): # Assume it's a header field name
                headers = next(reader)
                idx = headers.index(args)
            else:
                idx = int(args)

            for row in reader:
                result.add(cjk_only(row[idx]))
    else:
        # Handle plain text, args is a python expression
        func = eval(args)
        with smart_open(file) as f:
            for line in f:
                result.add(func(line))

    return result

if __name__ == '__main__':
    if len(sys.argv) < 2:
        print('Usage: compare_sets.py expression files...')
        sys.exit(1)

    expression = sys.argv[1]
    files = sys.argv[2:]
    sets = []
    for file in files:
        sets.append(file2set(file.split(":", maxsplit=1)[0], file.split(":", maxsplit=1)[1]))
    A = sets[0]
    if len(sets) > 1:
        B = sets[1]
    if len(sets) > 2:
        C = sets[2]
    if len(sets) > 3:
        D = sets[3]

    # evaluation <expression>
    output = eval(expression)
    for line in output:
        print(line)

