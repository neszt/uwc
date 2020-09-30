#!/usr/bin/env python

import re
import sys

counts = {}
word_re = re.compile(r"([a-z']+)", re.IGNORECASE)
for line in sys.stdin:
    for w in word_re.findall(line):
        counts[w] = counts.get(w, 0) + 1

def sorter(a, b):
    if counts[a] != counts[b]:
        return counts[a] - counts[b]

    if a < b:
        return -1
    if a > b:
        return 1

    return 0

words = sorted(counts, cmp=sorter)
for w in words:
    print w, counts[w]
