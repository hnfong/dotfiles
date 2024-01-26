#!/usr/bin/python3

# Documentation:
# Pick a K lines from N lines of stdin. If K >= N, pick everything. Stdin must
# be closed by the other party, cannot use as stream. Output can be in
# arbitrary order, even if K >= N.

import sys
import random

K = int(sys.argv[1])
lines = sys.stdin.readlines()
N = len(lines)

random.shuffle(lines)

sys.stdout.write("".join(lines[0:min(K, N)]))
