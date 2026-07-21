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

## Config Sync
Personal configs are centralized in ~/Projects/Config via symlinks. After modifying any tracked config file, proactively remind me to sync (commit + push). git push requires my approval.
