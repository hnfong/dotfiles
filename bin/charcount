#!/usr/bin/env python3

# XXX: Python compiled with UCS-2 support instead of UTF-32 will return wrong
# lengths for the cases you'd expect them to be wrong.
import sys
if len(sys.argv) < 2:
    print("Reading character count in stdin")
    ff = "/dev/stdin"
else:
    ff = sys.argv[1]

print(len(open(ff, "rb").read().decode("utf-8")))
