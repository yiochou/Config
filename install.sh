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

# === claude ===
mkdir -p ~/.claude ~/.claude/hooks ~/.claude/sounds ~/.claude/output-styles
ln -sf "$CONFIG_DIR/claude/settings.json" ~/.claude/settings.json
ln -sf "$CONFIG_DIR/claude/CLAUDE.md" ~/.claude/CLAUDE.md
# response style; selected by "outputStyle" in settings.json
for f in "$CONFIG_DIR/claude/output-styles/"*(N); do
    ln -sf "$f" ~/.claude/output-styles/"$(basename "$f")"
done
for f in "$CONFIG_DIR/claude/hooks/"*(N); do
    ln -sf "$f" ~/.claude/hooks/"$(basename "$f")"
done
# sounds referenced by the Stop / Notification hooks in settings.json
for f in "$CONFIG_DIR/claude/sounds/"*(N); do
    ln -sf "$f" ~/.claude/sounds/"$(basename "$f")"
done
# jam skill lives in the jam notes repo (see its README)
if [[ -d ~/Projects/jam/skills/jam ]]; then
    mkdir -p ~/.claude/skills
    ln -sfn ~/Projects/jam/skills/jam ~/.claude/skills/jam
fi
# skills that live in this repo
mkdir -p ~/.claude/skills
ln -sfn "$CONFIG_DIR/claude/skills/config-sync" ~/.claude/skills/config-sync

# generic skills/commands live in the skills plugin (github.com/yiochou/skills)
# NOTE: private repo — needs gh/git auth first on a fresh machine
if command -v claude &>/dev/null; then
    claude plugin marketplace add yiochou/skills 2>/dev/null || true
    claude plugin install yio@skills 2>/dev/null || true
fi

# === cli tools ===
# "command:formula" — formula name differs from the binary for delta.
CLI_TOOLS=(
    "node:node"
    "zoxide:zoxide"
    "jq:jq"          # statusline.sh + the ExitPlanMode/Notification hooks
    "delta:git-delta" # .gitconfig core.pager
)
for entry in "${CLI_TOOLS[@]}"; do
    command -v "${entry%%:*}" &>/dev/null || brew install "${entry#*:}"
done

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
    "Otty:https://otty.sh"
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
