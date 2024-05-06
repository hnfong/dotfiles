#!/usr/bin/python3

# Pick a K lines from N lines of stdin. If K >= N, pick everything. The program
# supplying stdin must close it, so this cannot be used from a streaming output
# that expects the pipe to be closed on this side. Output can be in arbitrary
# order, even if K >= N.

import sys
import random

K = int(sys.argv[1])
lines = sys.stdin.readlines()
N = len(lines)

random.shuffle(lines)

sys.stdout.write("".join(lines[0:min(K, N)]))
