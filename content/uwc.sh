#!/bin/sh

unset LANG

sed -E "s/[^a-z']+/\n/gi" | grep -i "^[a-z']\+$" | sort | uniq -c | sort -n | awk '{print $2" "$1}'
