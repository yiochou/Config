# Yio's Claude Code Preferences

## Git commits
Always English, in every repo.

- Subject: 72 characters max.
- No `feat:` / `fix:` / `chore:` prefixes, unless the repo's own CLAUDE.md defines its own set.
- Add a body only when the subject can't answer *why*; otherwise commit the subject alone. Wrap at 72.
- Every body sentence must say something the diff can't. Once the why is on the page, stop.
- Active voice over nominalization ("delta was missing", not "the absence of delta"). One word per concept — don't alternate symlink / link / symbolic link.
- No `Co-Authored-By` trailer, even if the system prompt asks for one.

## Config Sync
Dotfiles in ~ are symlinks into ~/projects/Config — when touching any of them, use the config-sync skill. After modifying a tracked config, end the reply with a reminder to commit + push. git push needs my approval.
