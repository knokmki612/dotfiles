// OpenCode port of claude/hooks/deny-raw-deletion.sh. Denies raw deletion
// commands so removals route through the safety-deletion skill (git rm /
// git clean) and stay recoverable; deterministic backstop for the Skills rule
// in agentic-ai overview.md, which stays the primary layer.
//
// NOTE: heuristic on the raw command string — text inside quotes can
// false-positive (e.g. a commit message containing "; rm "). Acceptable for a
// deny-with-reason backstop: the agent can rephrase and retry.
import { Plugin } from "@opencode/plugin"

const BACKTICK = String.fromCharCode(96)

// Match deletion commands only in command position (start, or after ; & | $( `)
// with optional sudo/env/command/nohup/xargs and a path prefix, so `git rm`,
// `npm rm`, and option letters like `grep -rm` pass through.
const pos = String.raw`(^|[;&|]|\$\(|` + BACKTICK + String.raw`)\s*`
const pre = String.raw`((sudo|env|command|nohup|xargs)(\s+(-[^\s]+|[A-Za-z_][A-Za-z_0-9]*=[^\s]*))*\s+)*`
const path = String.raw`([^\s]*/)?`
const deletionPatterns = [
  new RegExp(pos + pre + path + String.raw`(rm|rmdir|shred|unlink)(\s|$)`, "m"),
  new RegExp(pos + pre + path + String.raw`truncate\s`, "m"),
  new RegExp(pos + pre + path + String.raw`find\s[^;&|]*(-delete|-exec\s+([^\s]*/)?rm\s)`, "m"),
]

const message =
  "Raw deletion command blocked by the deny-raw-deletion plugin: use the " +
  "safety-deletion skill — git rm for tracked paths, git clean for " +
  "untracked/ignored ones — so the removal stays recoverable. Untracked is not " +
  "an exemption. Next time, create scratch/temp files under $TMPDIR " +
  "(mktemp -d) instead of the working tree; files there need no cleanup."

export default Plugin.define({
  id: "deny-raw-deletion",
  async setup(ctx) {
    await ctx.permission.hook("evaluate", (event) => {
      if (event.action !== "shell") return
      if (!event.resources.some((resource) => deletionPatterns.some((pattern) => pattern.test(resource)))) return
      event.effect = "deny"
      event.message = message
    })
  },
})
