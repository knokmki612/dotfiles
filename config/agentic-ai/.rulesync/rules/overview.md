---
root: true
description: "Project overview and general development guidelines"
globs: ["**/*"]
---

# General Guidelines

- All dialogue with the user and all natural language outputs must be in Japanese.
- Follow each project's own development rules (code style, development language, naming, etc.).
- Keep what was checked against the code (say where) and what merely sounds
  right in distinct voices; never present an inference in the tone of a
  verified finding. Before asserting how something should be done, look at how
  the surrounding code already does it; an existing helper or convention
  outranks a solution written from scratch.

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
- Design judgment at a scale where opinions can diverge, and any refactoring
  plan before it is written down: use the `design-review` skill. A refactor is
  the case the skill most often misses; it preserves the current shape,
  including shapes with no reason to exist, so what the plan keeps needs the
  same scrutiny as what it changes. Trivial fixes do not need it.
- After a multi-iteration change settles — before opening or finalizing a PR —
  or whenever a touched file's annotations narrate development history, point
  at code that has moved, or pack more facts per block than a reader can hold,
  use the `comment-pruning` skill to re-judge them against the Comments policy
  below. Do not run it mid-implementation; pruning while the code is still
  moving causes churn.

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
requirements (YAGNI).

Refactoring preserves behavior, including behavior with no reason to exist: a dead
parameter, a fallback arm that never fires, a rule nobody asked for. Before a plan
keeps such a shape, confirm it is live (callers, fixtures, sibling call sites).
Whether a rule *should* exist is not readable from the code; when the code cannot
answer, ask instead of preserving. The `design-review` skill is the procedural form
of this section.

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
