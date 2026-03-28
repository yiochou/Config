#!/bin/bash
set -e

CONFIG_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "Installing from $CONFIG_DIR..."

# === bash ===
ln -sf "$CONFIG_DIR/bash/.bashrc" ~/.bashrc
ln -sf "$CONFIG_DIR/bash/.bash_profile" ~/.bash_profile
ln -sf "$CONFIG_DIR/bash/.bash_prompt" ~/.bash_prompt

# === git ===
ln -sf "$CONFIG_DIR/git/.gitconfig" ~/.gitconfig

# === ghostty ===
mkdir -p ~/.config/ghostty
ln -sf "$CONFIG_DIR/ghostty/config" ~/.config/ghostty/config

# === lazygit ===
if [ "$(uname)" = "Darwin" ]; then
    LAZYGIT_DIR=~/Library/Application\ Support/lazygit
else
    LAZYGIT_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/lazygit"
fi
mkdir -p "$LAZYGIT_DIR"
ln -sf "$CONFIG_DIR/lazygit/config.yml" "$LAZYGIT_DIR/config.yml"

# === yazi ===
mkdir -p ~/.config/yazi
ln -sf "$CONFIG_DIR/yazi/yazi.toml" ~/.config/yazi/yazi.toml
ln -sf "$CONFIG_DIR/yazi/keymap.toml" ~/.config/yazi/keymap.toml

# === claude ===
mkdir -p ~/.claude
ln -sf "$CONFIG_DIR/claude/settings.json" ~/.claude/settings.json
ln -sf "$CONFIG_DIR/claude/CLAUDE.md" ~/.claude/CLAUDE.md

# === help system (Yio Command Center) ===
mkdir -p ~/.local/bin ~/.local/share/help
ln -sf "$CONFIG_DIR/h" ~/.local/bin/h
chmod +x ~/.local/bin/h
for f in "$CONFIG_DIR"/help/*; do
    ln -sf "$f" ~/.local/share/help/"$(basename "$f")"
done

# === apps checklist ===
echo ""
echo "── Apps to install manually ──"
APPS=(
    "Ghostty:https://ghostty.org"
    "Raycast:https://raycast.com"
    "TablePlus:https://tableplus.com"
    "OrbStack:https://orbstack.dev"
)
for entry in "${APPS[@]}"; do
    name="${entry%%:*}"
    url="${entry#*:}"
    if [ -d "/Applications/${name}.app" ]; then
        echo "  ✓ $name"
    else
        echo "  ✗ $name → $url"
    fi
done

echo ""
echo "Done!"
