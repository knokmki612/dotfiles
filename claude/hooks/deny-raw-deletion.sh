#!/bin/sh
# PreToolUse hook (Bash matcher): deny raw deletion commands so removals route
# through the safety-deletion skill (git rm / git clean) and stay recoverable.
# Deterministic backstop for the Skills rule in agentic-ai overview.md — the
# rule stays the primary layer; this only catches the cases where it is skipped.

# Fail open: a missing jq must not break every Bash call.
command -v jq >/dev/null 2>&1 || exit 0

cmd=$(jq -r '.tool_input.command // empty') || exit 0
[ -z "$cmd" ] && exit 0

# Match deletion commands only in command position (start, or after ; & | $( `)
# with optional sudo/env/command/nohup/xargs and a path prefix, so `git rm`,
# `npm rm`, and option letters like `grep -rm` pass through.
# NOTE: heuristic on the raw string — text inside quotes can false-positive
# (e.g. a commit message containing "; rm "). Acceptable for a deny-with-reason
# backstop: the agent can rephrase and retry.
pos='(^|[;&|]|\$\(|`)[[:space:]]*'
pre='((sudo|env|command|nohup|xargs)([[:space:]]+(-[^[:space:]]+|[A-Za-z_][A-Za-z_0-9]*=[^[:space:]]*))*[[:space:]]+)*'
path='([^[:space:]]*/)?'

if echo "$cmd" | grep -qE "${pos}${pre}${path}(rm|rmdir|shred|unlink)([[:space:]]|\$)" ||
   echo "$cmd" | grep -qE "${pos}${pre}${path}truncate[[:space:]]" ||
   echo "$cmd" | grep -qE "${pos}${pre}${path}find[[:space:]][^;&|]*(-delete|-exec[[:space:]]+([^[:space:]]*/)?rm[[:space:]])"
then
  echo "Raw deletion command blocked by ~/.claude/hooks/deny-raw-deletion.sh: use the safety-deletion skill — git rm for tracked paths, git clean for untracked/ignored ones — so the removal stays recoverable. Untracked is not an exemption. Next time, create scratch/temp files under \$TMPDIR (mktemp -d) instead of the working tree; files there need no cleanup." >&2
  exit 2
fi

exit 0
