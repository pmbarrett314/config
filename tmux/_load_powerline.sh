#!/bin/sh
# Source powerline's tmux config into the current session, if available.
# Robust to uv/pipx/venv installs — derives the python from the wrapper shebang.
command -v powerline-daemon >/dev/null 2>&1 || exit 0
powerline-daemon -q 2>/dev/null || exit 0
py=$(head -n 1 "$(command -v powerline-daemon)" | sed 's/^#!//')
[ -x "$py" ] || exit 0
conf=$("$py" -c 'import powerline, os; print(os.path.join(os.path.dirname(powerline.__file__), "bindings", "tmux", "powerline.conf"))' 2>/dev/null)
[ -f "$conf" ] && tmux source-file "$conf"
