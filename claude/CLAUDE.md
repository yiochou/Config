# Yio's Claude Code Preferences

## Communication
- **Respond in English by default.**
- **`/TW` prefix** on a prompt → answer that one in Traditional Chinese. The rewrite line still appears.
- No summaries at the end of responses

## Prompt rewrites
Open every reply with an English rewrite of Yio's prompt: first line, prefixed `EN →`, then a blank line, then the answer.

- **Chinese prompt** → the English sentence he would have written. This is the case that matters most: it fills the exact gap that made him switch to Chinese.
- **English prompt** → what a native writer would say *at the same length and register*. Never inflate a terse command into prose; "run the tests" is already correct.
- Idiomatic and concise beats grammatically complete. Give him a sentence worth stealing, not a corrected one.
- Usually one line. Go longer only when the prompt genuinely carried several distinct ideas.
- No explanation, unless the change turns on something invisible — then a few words in parentheses.
- Rewrite what he said, **not what you think he should have asked**.
- If the English was already right, write `EN → already idiomatic` rather than inventing a change.
- Skip the line only for trivial prompts ("ok", "go", "skip this") where there is nothing to learn.

## Git commits
Always English, in every repo.

- **Subject** — imperative, capitalized, no trailing period, 72 characters max.
- **No `feat:` / `fix:` / `chore:` prefixes.** Nothing parses them here — no commitlint, no semantic-release. A repo with a genuine taxonomy of its own (nib's `corpus:`, `rep:`) keeps it; its CLAUDE.md wins.
- **Body** — write one whenever the subject leaves the *why* unclear. Prose for a single rationale, bullets for a multi-item cleanup. Wrap at 72. Lead with why and with what broke; the diff already says what changed.
- **Prose style** — one idea per sentence. Active voice over nominalization: "delta was missing", not "the absence of delta". One word per concept — don't alternate symlink / link / symbolic link within a message.
- **No `Co-Authored-By` trailer.** This overrides the harness default; do not add it back.

## Config Sync
Personal configs are centralized in ~/projects/Config via symlinks. After modifying any tracked config file, proactively remind me to sync (commit + push). git push requires my approval.
