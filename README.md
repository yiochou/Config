# Config

Personal dotfiles managed with symlinks.

## Structure

```
zsh/            .zshrc, .zprofile, .zsh_prompt
git/            .gitconfig
ghostty/        Ghostty terminal config
claude/         Claude Code settings.json, CLAUDE.md, hooks, sounds, skills
help/           Yio Command Center topics
h               help system entry point
install.sh      symlinks everything into place
```

## Install

```bash
git clone git@github.com:yiochou/Config.git ~/projects/Config
cd ~/projects/Config
./install.sh
```

All configs are symlinked to their expected locations. Editing either side updates the same file.

`install.sh` also installs the CLI tools the configs depend on (node, zoxide, jq, gh,
git-delta) and prints a checklist of GUI apps and Zen extensions to install by
hand.

## What's Included

- **zsh** — aliases, prompt with git status, zoxide, OSC 7 for split inherit
- **Git** — aliases (lg, co, br, st), delta pager, zdiff3 conflict style
- **Ghostty** — macOS option-as-alt, clipboard, Shift+Enter as CSI-u, native splits
- **Claude Code** — permissions, plugins, hooks, two-column statusLine, `config-sync` skill
- **Yio Command Center** — `h` command for quick reference (`h aliases`, `h ghostty`, `h afplay`)
