#!/bin/sh
# PreToolUse hook (Bash matcher): deny commands that delete or destroy state
# outside the git working tree — an HTTP DELETE, or a delete/destroy subcommand
# of a cloud/SaaS CLI. Deterministic backstop for the Verification and Remote
# Resources rule in agentic-ai overview.md — the rule stays the primary layer.
# NOTE: this hook takes no exceptions. A wanted remote deletion is run by the
# user, not the agent; the classifier's soft_deny handles user-named cases,
# but a resource that predates the session is not recoverable by git.

# Fail open: a missing jq must not break every Bash call.
command -v jq >/dev/null 2>&1 || exit 0

cmd=$(jq -r '.tool_input.command // empty') || exit 0
[ -z "$cmd" ] && exit 0

# Same command-position shape as deny-raw-deletion.sh (start, or after ; & | $( `)
# with optional sudo/env/command/nohup/xargs and a path prefix, plus an optional
# package runner (npx wrangler …, pnpm exec wrangler …, mise exec … -- wrangler …).
# NOTE: heuristic on the raw string — quoted text can false-positive, and a
# method hidden in a variable (`M=DELETE; curl -X $M`) slips through. The rule
# and the auto mode classifier cover that gap; this only catches the literal
# forms an agent writes by default.
pos='(^|[;&|]|\$\(|`)[[:space:]]*'
pre='((sudo|env|command|nohup|xargs)([[:space:]]+(-[^[:space:]]+|[A-Za-z_][A-Za-z_0-9]*=[^[:space:]]*))*[[:space:]]+)*'
runner='((npx|bunx|pnpm|yarn|mise)([[:space:]]+[^[:space:]]+)*[[:space:]]+)?'
path='([^[:space:]]*/)?'
seg='[^;&|]*'
q="['\"]?"
end="([[:space:]]|\$|['\"])"

# HTTP DELETE: curl -X DELETE / -XDELETE / --request DELETE, wget --method=DELETE,
# httpie/xh `http DELETE url` or `xh delete url`.
http_method="${pos}${pre}${path}(curl|wget|wget2|http|https|xh)[[:space:]]${seg}(-X[[:space:]]*|--request[[:space:]=]+|--method[[:space:]=]+)${q}delete${end}"
http_positional="${pos}${pre}${path}(http|https|xh)[[:space:]]+(-[^[:space:]]+[[:space:]]+)*${q}delete${end}"
# gh api with an explicit DELETE method.
gh_api="${pos}${pre}${path}gh[[:space:]]+api[[:space:]]${seg}(-X[[:space:]]*|--method[[:space:]=]+)${q}delete${end}"
# Delete-family subcommands of cloud CLIs: wrangler delete, wrangler kv key delete,
# gh repo/release/secret delete, gcloud … delete, gsutil rm/rb.
cli_delete="${pos}${pre}${runner}${path}(wrangler|gh|gcloud|gsutil)([[:space:]]${seg})?[[:space:]]+(delete|destroy|purge|rm|rb)${end}"
# IaC teardown: terraform/tofu/terragrunt destroy, terraform apply -destroy, pulumi/cdk destroy.
iac_destroy="${pos}${pre}${runner}${path}(terraform|tofu|terragrunt|pulumi|cdk|cdktf)([[:space:]]${seg})?[[:space:]]+-?destroy${end}"

if echo "$cmd" | grep -qiE "$http_method" ||
   echo "$cmd" | grep -qiE "$http_positional" ||
   echo "$cmd" | grep -qiE "$gh_api" ||
   echo "$cmd" | grep -qiE "$cli_delete" ||
   echo "$cmd" | grep -qiE "$iac_destroy"
then
  echo "Remote deletion blocked by ~/.claude/hooks/deny-remote-deletion.sh: this command would delete or destroy state outside the git working tree (HTTP DELETE, or a delete/destroy subcommand of wrangler/gh/gcloud/terraform). Measurement must be read-only — verify with GET/list/describe, --dry-run, --help, or the docs instead. If the deletion is genuinely wanted, report the exact resource and command to the user and let them run it themselves; this hook takes no exceptions." >&2
  exit 2
fi

exit 0
