#!/bin/zsh
set -e

CONFIG_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "Installing from $CONFIG_DIR..."

# === zsh ===
ln -sf "$CONFIG_DIR/zsh/.zshrc" ~/.zshrc
ln -sf "$CONFIG_DIR/zsh/.zprofile" ~/.zprofile
ln -sf "$CONFIG_DIR/zsh/.zsh_prompt" ~/.zsh_prompt

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

# === claude ===
mkdir -p ~/.claude ~/.claude/commands
ln -sf "$CONFIG_DIR/claude/settings.json" ~/.claude/settings.json
ln -sf "$CONFIG_DIR/claude/CLAUDE.md" ~/.claude/CLAUDE.md
for f in "$CONFIG_DIR/.claude/commands/"*.md; do
    [ -f "$f" ] && ln -sf "$f" ~/.claude/commands/"$(basename "$f")"
done

# === cli tools ===
command -v node    &>/dev/null || brew install node
command -v zoxide  &>/dev/null || brew install zoxide

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
    "Zed:https://zed.dev"
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
echo "── Dia extensions ──"
DIA_EXT_DIR=~/Library/Application\ Support/dia/User\ Data/Default/Extensions
DIA_EXTENSIONS=(
    "1Password Nightly – Password Manager:gejiddohjgogedgjnonbofjigllpkmbf"
    "Ad Blocker: Stands AdBlocker:lgblnfidahcdcjddiepkckcfdhpknnjh"
    "Checker Plus for Gmail™:oeopbcgkkoapgobdbedcemjljbihmemj"
    "Checker Plus for Google Calendar™:hkhggnncdpfibdhinjiegagmopldibha"
    "ScTranslator - Translator, Page Translator, Dictionary:icfnljfpacimpcbpammmbclmhenimhfc"
)
for entry in "${DIA_EXTENSIONS[@]}"; do
    name="${entry%:*}"
    id="${entry##*:}"
    if [ -d "$DIA_EXT_DIR/$id" ]; then
        echo "  ✓ $name"
    else
        echo "  ✗ $name → https://chromewebstore.google.com/detail/$id"
    fi
done

echo ""
echo "Done!"
