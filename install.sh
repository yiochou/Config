#!/bin/zsh
set -e

CONFIG_DIR="$(cd "$(dirname "$0")" && pwd)"

# Ensure brew is in PATH (not loaded in non-login zsh shells)
[[ -x /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"
[[ -x /usr/local/bin/brew ]] && eval "$(/usr/local/bin/brew shellenv)"

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
mkdir -p ~/.claude ~/.claude/commands ~/.claude/hooks
ln -sf "$CONFIG_DIR/claude/settings.json" ~/.claude/settings.json
ln -sf "$CONFIG_DIR/claude/CLAUDE.md" ~/.claude/CLAUDE.md
for f in "$CONFIG_DIR/claude/hooks/"*(N); do
    ln -sf "$f" ~/.claude/hooks/"$(basename "$f")"
done
for f in "$CONFIG_DIR/.claude/commands/"*.md(N); do
    ln -sf "$f" ~/.claude/commands/"$(basename "$f")"
done

# === cli tools ===
command -v node    &>/dev/null || brew install node
command -v zoxide  &>/dev/null || brew install zoxide

# Zed CLI (app itself is in the manual apps checklist)
[ -d /Applications/Zed.app ] && ln -sf /Applications/Zed.app/Contents/MacOS/cli ~/.local/bin/zed

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
echo "── Zen extensions ──"
ZEN_EXT_DIR=$(python3 -c "
import configparser, os
ini = os.path.expanduser('~/Library/Application Support/zen/profiles.ini')
if not os.path.exists(ini): exit()
c = configparser.ConfigParser()
c.read(ini)
# Active profile is in [Install...] section's Default key
for s in c.sections():
    if s.startswith('Install'):
        path = c.get(s, 'Default', fallback='')
        if path:
            print(os.path.expanduser(f'~/Library/Application Support/zen/{path}/extensions'))
            break
" 2>/dev/null)
ZEN_EXTENSIONS=(
    "1Password – Password Manager|{d634138d-c276-4fc8-924b-40a0ea21d284}|1password-x-password-manager"
    "AdBlocker Ultimate|adblockultimate@adblockultimate.net|adblocker-ultimate"
    "Checker Plus for Gmail|checkerplusforgmail@jasonsavard.com|checker-plus-gmail"
    "Checker Plus for Google Calendar|checkerplusforgooglecalendar@jasonsavard.com|checker-plus-for-calendar"
    "Dark Reader|addon@darkreader.org|darkreader"
    "ScTranslator|{afebda95-fffb-45fb-b793-07b5ba8571c5}|sctranslator"
    "Search by Image|{2e5ff8c8-32fe-46d0-9fc8-6b8986621f3c}|search-by-image"
    "Stylebot|{52bda3fd-dc48-4b3d-a7b9-58af57879f1e}|stylebot"
)
if [ -z "$ZEN_EXT_DIR" ] || [ ! -d "$ZEN_EXT_DIR" ]; then
    echo "  (Zen not installed)"
else
    for entry in "${ZEN_EXTENSIONS[@]}"; do
        IFS='|' read -r name id slug <<< "$entry"
        if [ -f "$ZEN_EXT_DIR/$id.xpi" ]; then
            echo "  ✓ $name"
        else
            echo "  ✗ $name → https://addons.mozilla.org/firefox/addon/$slug/"
        fi
    done
fi

echo ""
echo "Done!"
