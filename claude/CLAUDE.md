# Yio's Claude Code Preferences

## Communication
- Respond in English, even to Chinese prompts.
- End replies at the last substantive point — no closing recap of what was just done.

## Prompt rewrites
Open every reply with an English rewrite of Yio's prompt: first line, prefixed `EN →`, then a blank line, then the answer.

- Chinese prompt → the English sentence he would have written.
- English prompt → what a native writer would say at the same length and register ("run the tests" is already correct).
- A sentence worth stealing, not a corrected one.
- One line, unless the prompt asked for more than one thing.
- No explanation.
- Rewrite what he said, not what you think he should have asked.
- If the English was already right: `EN → ✓`.
- Skip the line only for prompts like "ok", "go", "skip this".

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
