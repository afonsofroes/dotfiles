#!/usr/bin/env bash
# Sets the terminal tab title from the first prompt of a session.
input=$(cat)
sid=$(printf '%s' "$input" | jq -r '.session_id // "none"')
flag="/tmp/claude-tab-title-$sid"
[ -e "$flag" ] && exit 0
touch "$flag"
title=$(printf '%s' "$input" | jq -r '.prompt // ""' | tr '\n' ' ' | cut -c1-40 | sed 's/ *$//')
[ -z "$title" ] && exit 0
printf '\033]0;%s\007' "$title" > /dev/tty 2>/dev/null
exit 0
