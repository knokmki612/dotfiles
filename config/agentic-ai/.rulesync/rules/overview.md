---
root: true
targets: ["*"]
description: "Project overview and general development guidelines"
globs: ["**/*"]
---

# Project Overview

## General Guidelines

- All dialogue with the user and all natural language outputs must be in Japanese.
- Follow the development rules (including code style, development language, etc.) of each project
- Follow consistent naming conventions
- Write self-documenting code with clear variable and function names

## Design Principles

- Design principles (SOLID, DRY, patterns, etc.) are tools, not goals. Identify a
  concrete problem first (e.g., a change forces edits across multiple files, tests need
  dependencies unrelated to what they verify), then apply a principle only when it beats
  the simpler alternatives (inlining, a helper function, deletion). When in doubt, choose
  the simpler option.
- Do not add abstractions, layers, or interfaces for speculative future requirements (YAGNI).

## Comments

Judge a comment by the trade-off between "the reader's effort saved at that spot" and
"noise + drift cost". Do not judge by the what/why dichotomy. Use the three layers below.

### 1. Guard comments — always keep

A point that would puzzle someone reading the implementation, or a DO-NOT / pitfall to see
when referencing it. Keep a rationale only when it satisfies **all** of:

- Locality: the reason is specific to this spot (not a codebase-wide convention).
- Non-recoverability: it cannot be read off types, signatures, error messages, or nearby code.
- Guard nature: removing or changing it breaks something (i.e., it stops a future "improvement").
- Not language-spec-obvious: not the likes of "a log appears where it is written".

Keep "looks wrong but is correct" and "DO NOT X" cases minimal with a `NOTE:` prefix so the
reasoning stays traceable.

### 2. Convention why — once, at the definition/enforcement point

Codebase-wide conventions (e.g., errors are rethrown at the leaf with context added to `cause`,
and logged once in `main`) are not written at every application site. Write them once at the
convention's enforcement point (root/main, or the relevant function). A leaf-level echo is a
drift source — a convention change would force edits at every copy — and is forbidden.

### 3. Single-line what — writer's discretion

A single-line comment that serves as a heading for a following non-trivial multi-line block is
fine (it aids top-to-bottom reading). A one-line paraphrase of a single self-named call has
little value and is not required.

### Do not keep provenance in code

Design provenance ("who decided what, when, and why") belongs in ADR / PR / commit messages.
History written in code rots. The only exception is the Guard case above (questions or DO-NOTs
surfaced while reading the implementation); only then keep the essence of the provenance
minimally with a `NOTE:` prefix.

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
