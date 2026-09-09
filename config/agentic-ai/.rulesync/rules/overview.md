---
root: true
description: "Project overview and general development guidelines"
globs: ["**/*"]
---

# General Guidelines

- All dialogue with the user and all natural language outputs must be in Japanese.
- Follow each project's own development rules (code style, development language, naming, etc.).

## Skills

Never skip one of these silently — deviating from a rule below requires stating the
reason. Each rule carries its own strength and deviation condition.

- File/directory deletion: in a git working tree, always use the `safety-deletion`
  skill (`git rm` for tracked paths, `git clean` for untracked/ignored ones)
  instead of `rm`, `find -delete`, etc. Untracked is not an exemption. Avoid
  needing deletion at all: create scratch/temp files under `$TMPDIR`
  (`mktemp -d`), not the working tree; files there need no cleanup.
- Before grepping an identifier (a function/class/method/variable name) to find
  where it is defined, referenced, implemented, or called — or before reading a
  whole source file just to understand its structure: that intent is symbol-level
  search, even if it feels like an ordinary grep. Use the `serena-semantic-search`
  skill (requires the Serena MCP server) instead. When starting to read an
  implementation file, lead with a symbol overview rather than a full-file read.
  Literal-text search (strings, error messages, config keys), line-range reads,
  and non-code files stay on plain grep/Read.
- Design or refactoring judgment at a scale where opinions can diverge: use the
  `design-review` skill. Trivial fixes do not need it.
- After a multi-iteration change settles — before opening or finalizing a PR —
  or whenever a touched file's annotations narrate development history, point
  at code that has moved, or pack more facts per block than a reader can hold,
  use the `comment-pruning` skill to re-judge them against the Comments policy
  below. Do not run it mid-implementation; pruning while the code is still
  moving causes churn.

## Verification and Remote Resources

Verifying against the real system is welcome — it raises accuracy — but a
measurement must never change what it measures.

- Verify with side-effect-free operations only: GET / list / describe / read,
  `--dry-run`, `--help`, and the documentation. Never probe an API by issuing a
  mutating request "to see what happens": a DELETE against a live resource is
  an experiment on production, not a measurement.
- Every piece of state outside the git working tree — a remote API, a cloud
  resource (Cloudflare, Google Cloud, GitHub), a database, a SaaS setting — is
  a remote resource. Before mutating or deleting one, establish how it would be
  restored (backup, versioned config, re-creatable from source in this repo).
  Restorability that has not been confirmed counts as none: stop and ask the
  user, naming the exact resource and the exact command.
- When verification genuinely requires a mutation, perform it on a disposable
  target you created in this session (a throwaway resource, a preview or
  staging environment), never on one that existed before the session.
- "Not production" is not an exemption; a resource's name does not establish
  its role. Deviation condition: the user names the exact resource and the
  destructive operation in the current conversation. The
  `deny-remote-deletion.sh` hook still blocks the literal deletion forms even
  then — a wanted remote deletion is run by the user, not the agent.

## Before Committing

Before every commit, check the project's task manifest (`package.json` scripts,
`Makefile`, `justfile`, `deno.json` tasks, etc.) and run the tasks that correspond to
formatting/linting and testing. Report the results; do not commit with failing checks
unless the failure pre-exists the change and is unrelated (say so explicitly).
Deviation condition: when the full test suite is too heavy, run only the tests
relevant to the change and state that you narrowed the scope.

## Design Principles

Design principles (SOLID, DRY, patterns, etc.) are tools, not goals. Identify a concrete
problem first (e.g., a change forces edits across multiple files, tests need dependencies
unrelated to what they verify), then apply a principle only when it beats the simpler
alternatives (inlining, a helper function, deletion). When in doubt, choose the simpler
option. Do not add abstractions, layers, or interfaces for speculative future
requirements (YAGNI). The `design-review` skill is the procedural form of this section.

## Comments

Judge a comment by "reader's effort saved at that spot" vs "noise + drift cost" — not by
the what/why dichotomy. Three layers:

1. **Guard — always keep.** A DO-NOT / pitfall, or a rationale unreadable from the code
   itself; keep it minimal, with a `NOTE:` prefix.
2. **Convention why — once.** Stated only at the enforcement point; a leaf-level echo is
   a drift source and is forbidden.
3. **Single-line what — writer's discretion.** A heading over a non-trivial block is
   fine; a paraphrase of a self-named call is not required.

Design provenance (who decided what, when, and why) belongs in ADR / PR / commit
messages, not in code — except when it doubles as a Guard comment (layer 1). The
`comment-pruning` skill is the procedural form of this section; its
`references/classification.md` is the canonical detailed rubric (criteria, signals,
worked examples).

## Dependency Injection

- Inject only external boundaries: network, time, environment variables, logging.
- Import pure functions and domain logic directly; do not inject them.
- For fs, use the real module when tests can use a temporary directory (mkdtemp).
- Do not add intermediate interfaces or wrappers that exist only for tests. When a mock
  starts to reimplement production logic, it is a sign to revisit the design.

## Error Handling

- Let errors propagate by default; do not catch, log, and rethrow.
- Wrap with `new Error(msg, { cause })` only where context (which target failed) is needed.
- Centralize error logging in one place at the entry point (the `main` catch).
- Emit a warning on the spot only when processing continues after a catch.
