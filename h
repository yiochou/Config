#!/bin/bash
# 統一 help 系統
# 用法: h [topic]
# help topics 放在 ~/.local/share/help/ 目錄下

HELP_DIR="$HOME/.local/share/help"

if [ -z "$1" ]; then
    echo "╔═══════════════════════════════════════════════╗"
    echo "║  Yio Command Center                           ║"
    echo "╠═══════════════════════════════════════════════╣"
    echo "║  用法: h <topic>                              ║"
    echo "╚═══════════════════════════════════════════════╝"
    echo ""
    echo "可用的 topics:"
    echo ""
    for f in "$HELP_DIR"/*; do
        [ -f "$f" ] || continue
        name=$(basename "$f")
        desc=$(head -1 "$f" | sed 's/^# *//')
        printf "  %-14s %s\n" "$name" "$desc"
    done
    echo ""
    echo "新增 topic:  在 ~/.local/share/help/ 建立檔案即可"
    exit 0
fi

TOPIC_FILE="$HELP_DIR/$1"

if [ -f "$TOPIC_FILE" ]; then
    cat "$TOPIC_FILE"
else
    echo "找不到 topic: $1"
    echo ""
    echo "可用的 topics:"
    for f in "$HELP_DIR"/*; do
        [ -f "$f" ] || continue
        printf "  %s\n" "$(basename "$f")"
    done
    exit 1
fi
