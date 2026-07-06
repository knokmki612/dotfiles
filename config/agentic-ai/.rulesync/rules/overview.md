---
root: true
description: "Project overview and general development guidelines"
globs: ["**/*"]
---

# General Guidelines

- All dialogue with the user and all natural language outputs must be in Japanese.
- Follow each project's own development rules (code style, development language, naming, etc.).

## Design Principles

Design principles (SOLID, DRY, patterns, etc.) are tools, not goals. Identify a concrete
problem first (e.g., a change forces edits across multiple files, tests need dependencies
unrelated to what they verify), then apply a principle only when it beats the simpler
alternatives (inlining, a helper function, deletion). When in doubt, choose the simpler
option. Do not add abstractions, layers, or interfaces for speculative future
requirements (YAGNI).

## Comments

Judge a comment by "reader's effort saved at that spot" vs "noise + drift cost" — not by
the what/why dichotomy. Three layers:

1. **Guard — always keep.** A point that would puzzle someone reading the implementation,
   or a DO-NOT / pitfall. Keep a rationale only when it is specific to this spot, cannot
   be read off types, signatures, error messages, nearby code, or language semantics, and
   removing it would invite a breaking "improvement". Keep these minimal, with a `NOTE:`
   prefix, so the reasoning stays traceable.
2. **Convention why — once.** Write codebase-wide conventions once, at the enforcement
   point (root/main, or the relevant function). A leaf-level echo is a drift source and
   is forbidden.
3. **Single-line what — writer's discretion.** A heading line for a following non-trivial
   multi-line block is fine; a one-line paraphrase of a single self-named call is not
   required.

Design provenance (who decided what, when, and why) belongs in ADR / PR / commit
messages, not in code — except when it doubles as a Guard comment (layer 1).

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
