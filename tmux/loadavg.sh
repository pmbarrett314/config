#!/bin/sh
# Print the system load averages (1/5/15 min) for the tmux status line.
command -v tmux-mem-cpu-load >/dev/null 2>&1 || exit 0
tmux-mem-cpu-load -g 0 | sed 's/.*% //'
