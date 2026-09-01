# Yio's Claude Code Preferences

Response style and the `EN →` prompt rewrite live in the Yio output
style, not here — see `~/.claude/output-styles/yio.md`. Subagents never see
that style, so anything a subagent must obey belongs in this file.

## Proposing a change

Before you change a file, tell Yio four things:

1. Your reading of the request, in one sentence.
2. The file.
3. The change.
4. The reason for the change.

Then wait for his answer. He can answer as soon as he sees these four
things.

## Code
YAGNI. Every exported name has a caller outside its own file and outside its own test. A test is not a caller. When the last caller goes, the code goes with it. Git keeps it for the day something needs it.

## Dates
Use the `date` command to verify each date and weekday that you write. Do not calculate them from memory.

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
