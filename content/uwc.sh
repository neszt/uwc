#!/bin/sh

unset LANG

tr " " "\n" | grep -i "^[a-z']\+$" | sort | uniq -c | sort -n | awk '{print $2" "$1}'
