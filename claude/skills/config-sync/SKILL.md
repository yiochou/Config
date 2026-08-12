---
name: config-sync
description: Use when modifying dotfiles, shell config, git config, terminal config, Claude settings, or the help system — especially when about to edit a symlink target like ~/.bashrc directly
---

# Config Sync

All personal config files are managed in a single git repo and installed via symlinks. Never edit symlink targets directly — always find and edit the source file in the repo.

## Workflow

### 1. Find the Config repo

```bash
readlink ~/.bashrc
# e.g. /Users/yio/Projects/Config/bash/.bashrc → repo root is /Users/yio/Projects/Config
```

Strip the relative path after the repo root. If readlink returns nothing (symlinks not yet installed), ask the user for the Config repo path.

### 2. Understand the mapping

Read `install.sh` in the repo root to understand all symlink mappings.

### 3. Edit source files

Make all changes to files inside the repo, never to symlink targets.

### 4. If new config files are added

1. Update `install.sh` with the new symlink entry
2. Run `install.sh` to install the new symlink

### 5. Commit and push

- Commit in the Config repo directory with an English commit message
- Push requires user approval

## Help System

The Config repo includes a help system (`h` command) for quick-reference cheatsheets.

- Topics live in `help/` directory in the repo (symlinked to `~/.local/share/help/`)
- Each topic is a plain text file, first line is `# Title`
- Format example:

  ```
  # Topic Title

  ── Section Name ─────────────────────────────────────────────

    shortcut       description
    another        description
  ```

- Run `h` to list all topics, `h <topic>` to view one

**When to update help:** Whenever the user learns, configures, or asks to document a new tool, shortcut, alias, or workflow — create or update the relevant help topic. Use the existing topics as format reference.

**Adding a new help topic** also requires updating `install.sh` (same as any new config file).

## Common Mistakes

- **Editing symlink targets directly** (e.g. `~/.bashrc`, `~/.gitconfig`) — changes will be overwritten next time `install.sh` runs. Always edit the source in the repo.
- **Forgetting to update `install.sh`** when adding a new config file — the symlink won't exist on other machines.
- **Forgetting to run `install.sh`** after adding a new file — the symlink won't be active on the current machine.
