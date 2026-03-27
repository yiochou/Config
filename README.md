# Config

Personal dotfiles managed with symlinks.

## Structure

```
bash/           .bashrc, .bash_profile, .bash_prompt
git/            .gitconfig
tmux/           .tmux.conf (Ghostty + Claude Code optimized)
ghostty/        Ghostty terminal config
claude/         Claude Code settings.json + CLAUDE.md
help/           Yio Command Center topics
h               help system entry point
```

## Install

```bash
git clone git@github.com:yiochou/Config.git ~/Projects/Config
cd ~/Projects/Config
./install.sh
```

All configs are symlinked to their expected locations. Editing either side updates the same file.

## What's Included

- **Bash** — aliases, prompt with git status
- **Git** — aliases (lg, co, br, st)
- **tmux** — Ctrl+A prefix, vim navigation, Claude Code passthrough, TPM + resurrect
- **Ghostty** — macOS option-as-alt, clipboard, Shift+Enter fix for tmux
- **Claude Code** — permissions, plugins, behavioral preferences
- **Yio Command Center** — `h` command for quick reference (`h tmux`, `h ghostty`, `h aliases`)
