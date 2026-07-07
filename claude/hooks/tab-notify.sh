#!/bin/sh
# Mark/clear this Claude Code session's terminal tab title.
#   tab-notify.sh mark   -> "🟢 <project>"  (Claude is waiting for input)
#   tab-notify.sh clear  -> "<project>"     (user is back)
#
# Hooks run without a controlling tty, so walk up the parent chain to the
# Claude Code process and write the escape sequence to its terminal device.

action="$1"

pid=$$
tty_name=""
while [ -n "$pid" ] && [ "$pid" -gt 1 ]; do
    pid=$(ps -o ppid= -p "$pid" | tr -d ' ')
    [ -z "$pid" ] && break
    t=$(ps -o tty= -p "$pid" | tr -d ' ')
    if [ -n "$t" ] && [ "$t" != "??" ]; then
        tty_name="$t"
        break
    fi
done
# Headless session (daemon, CI, app-spawned): no tab to mark
[ -z "$tty_name" ] && exit 0

cwd=$(jq -r '.cwd // empty' 2>/dev/null)
name=$(basename "${cwd:-$PWD}")

case "$action" in
    mark)  printf '\033]0;🟢 %s\007' "$name" > "/dev/$tty_name" 2>/dev/null ;;
    clear) printf '\033]0;%s\007' "$name" > "/dev/$tty_name" 2>/dev/null ;;
esac
