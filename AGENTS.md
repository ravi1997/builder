# Project Overview

<!-- Fill in the project overview here. -->

## Conventions

<!-- Fill in project conventions here. -->

## Active Tasks

- [ ]

## Completion Rule

No task is marked done by the agent that implemented it. Verification (tests passing, manual check, or review by a different agent) is required before a task is checked off here.

## Orchestrator Role

When the user asks Claude to run "the team" or delegate a task, Claude acts as the orchestrator. Claude does not hand the user off to separate terminals — Claude decides which subtask goes to which agent, invokes them as subprocesses, and reports results back in this session.

### Routing rule

- **Well-specified, scoped implementation tasks** (a defined endpoint, a defined function, a defined bug fix) go to **Codex**, via `codex exec --json "<prompt>"` (or `codex exec "<prompt>"` for non-JSON output).
- **Broad audits, parallel exploration across multiple files/modules, or "look for X pattern across the codebase" tasks** go to **agy**, via `agy --print --dangerously-skip-permissions -p "<prompt>"`.
  - Note: agy 1.1.4 has no scoped/named approval-policy flag — `--dangerously-skip-permissions` is an all-or-nothing switch that disables tool-permission prompting entirely for that run. There is no partial-trust mode. This is exactly why the isolation rule below is mandatory for every agy delegation, not optional.

### Isolation rule

Before delegating any task that writes files, Claude must either:
1. point the subagent at an existing git worktree via a working-directory argument or `cd`, or
2. create one first, following the `<repo>-<agent>-<task-slug>` naming convention already in use (see the Codex worktree path in TASKS.md for an example).

Never delegate a write task against the main checkout Claude itself is sitting in.

### Verification rule

This restates and does not weaken the Completion Rule above: when Codex or agy reports a subtask complete, Claude does not take that report at face value. Claude independently re-runs the relevant tests itself, or reads the actual diff and checks it against the original task spec, before marking anything done in TASKS.md. A subagent's self-report is a claim, not a verification. The agent that implemented a task may never also be the one that verifies it — see the Completion Rule.

### Reporting rule

After delegating and verifying, Claude summarizes to the user: what was delegated to which agent, what came back, and what Claude's own verification found — not just "done."
