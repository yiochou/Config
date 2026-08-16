#!/bin/bash
# Claude Code MessageDisplay hook — stamps each assistant message with the local time.
#
# Display-only: MessageDisplay swaps what the terminal draws, never the transcript
# or what the model reads, so the marker can't confuse Claude.
#
# The hook fires once per streamed chunk of a message, carrying a zero-based
# .index — stamp chunk 0 only, or every chunk gets a clock.
#
# Written by hand because the built-in showMessageTimestamps setting is ANDed
# with a server-side flag (tengu_silk_hinge) that is off for this account.
set -euo pipefail

# No jq means no stamp — never swallow the assistant's output.
command -v jq >/dev/null 2>&1 || exit 0

ts=$(date '+%H:%M:%S')

jq --arg ts "$ts" '{
  hookSpecificOutput: {
    hookEventName: "MessageDisplay",
    displayContent: (if .index == 0 then "[" + $ts + "]\n" + .delta else .delta end)
  }
}'
