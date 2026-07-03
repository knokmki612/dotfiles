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
- Comments are a tool, not a goal. Add a comment only to explain why (intent, rationale,
  non-obvious constraints), not what the code already states; do not add comments that
  merely restate the code. When in doubt, improve names instead of adding a comment.

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
