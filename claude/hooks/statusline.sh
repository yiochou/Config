#!/bin/bash
# Claude Code statusLine — left: user/dir/git, right: model/ctx/cost.
# Requires a Nerd Font for the icons (JetBrainsMono Nerd Font Mono).

input=$(cat)

strip_ansi() { printf '%s' "$1" | sed -E 's/\x1b\[[0-9;]*m//g'; }
visible_len() { local s; s=$(strip_ansi "$1"); printf '%s' "${#s}"; }

# ── Left: user@host dir, git branch ───────────────────────────────────────
cwd=$(printf '%s' "$input" | jq -r '.workspace.current_dir // .cwd // empty')
dir="${cwd/#$HOME/~}"
user=$(whoami)
if [ "$user" = "root" ]; then ucode=124; else ucode=166; fi

LEFT=$(printf '\033[38;5;%sm %s\033[0m' "$ucode" "$user")
if [ -n "$SSH_TTY" ]; then
    host=$(hostname -s)
    LEFT+=$(printf ' \033[38;5;124m %s\033[0m' "$host")
fi
LEFT+=$(printf ' \033[38;5;64m %s\033[0m' "$dir")

if [ -n "$cwd" ] && git -C "$cwd" --no-optional-locks rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    branch=$(git -C "$cwd" --no-optional-locks symbolic-ref --quiet --short HEAD 2>/dev/null)
    [ -z "$branch" ] && branch=$(git -C "$cwd" --no-optional-locks rev-parse --short HEAD 2>/dev/null)
    s=""
    git -C "$cwd" --no-optional-locks diff --quiet --ignore-submodules --cached 2>/dev/null || s="${s}+"
    git -C "$cwd" --no-optional-locks diff-files --quiet --ignore-submodules -- 2>/dev/null || s="${s}!"
    [ -n "$(git -C "$cwd" --no-optional-locks ls-files --others --exclude-standard 2>/dev/null)" ] && s="${s}?"
    git -C "$cwd" --no-optional-locks rev-parse --verify refs/stash >/dev/null 2>&1 && s="${s}\$"
    [ -n "$branch" ] && LEFT+=$(printf ' \033[38;5;61m %s\033[38;5;33m%s\033[0m' "$branch" "$s")
fi

# ── Right: model, context usage, cost ─────────────────────────────────────
model=$(printf '%s' "$input" | jq -r '.model.display_name // empty')
ctxpct=$(printf '%s' "$input" | jq -r '.context_window.used_percentage // empty')
cost=$(printf '%s' "$input" | jq -r '.cost.total_cost_usd // empty')

RIGHT_PARTS=()
[ -n "$model" ] && RIGHT_PARTS+=("$(printf '\033[38;5;214m %s\033[0m' "$model")")
[ -n "$ctxpct" ] && RIGHT_PARTS+=("$(printf '\033[38;5;178m %s%%\033[0m' "$(printf '%.0f' "$ctxpct")")")
[ -n "$cost" ] && RIGHT_PARTS+=("$(printf '\033[38;5;71m$%s\033[0m' "$(printf '%.2f' "$cost")")")

RIGHT=""
for part in "${RIGHT_PARTS[@]}"; do
    if [ -z "$RIGHT" ]; then
        RIGHT="$part"
    else
        RIGHT+=$(printf ' \033[38;5;238m│\033[0m %s' "$part")
    fi
done

# ── Assemble, right-aligning RIGHT to the usable width when available ─────
# .columns (from stdin JSON) is the actual usable row width — it already
# accounts for Claude Code's own padding/borders, unlike $COLUMNS which is
# the raw terminal width and overshoots past the visible area.
width=$(printf '%s' "$input" | jq -r '.columns // empty')
[[ "$width" =~ ^[0-9]+$ ]] || width="$COLUMNS"
# Safety buffer: Claude Code can pop up its own right-side hints (e.g. usage
# warnings) that eat into the row after we've already measured it.
[[ "$width" =~ ^[0-9]+$ ]] && width=$(( width - 3 ))

if [ -n "$RIGHT" ]; then
    if [[ "$width" =~ ^[0-9]+$ ]] && [ "$width" -gt 0 ]; then
        left_len=$(visible_len "$LEFT")
        right_len=$(visible_len "$RIGHT")
        gap=$(( width - left_len - right_len ))
        [ "$gap" -lt 1 ] && gap=1
        printf '%s%*s%s\n' "$LEFT" "$gap" '' "$RIGHT"
    else
        printf '%s  %s\n' "$LEFT" "$RIGHT"
    fi
else
    printf '%s\n' "$LEFT"
fi
