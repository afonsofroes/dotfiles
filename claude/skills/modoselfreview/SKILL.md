---
name: modoselfreview
description: "Use for critical self-review and fix work on the current modolab branch against its base. This is not a third-party PR reviewer skill; it audits and improves the agent's own branch changes before review."
---

# Modolab Branch Self-Review

Use this skill to critically review and fix the current branch before
asking a human or external reviewer to review it.

This is a self-review workflow, not a reviewer-only workflow for commenting on
someone else's PR.

## Required Inputs

The user must provide:

- `Base`: the branch or commit to review the current branch against.

If `Base` is missing, ask for it before reviewing, running checks, or making
code changes. Do not infer the base branch.

## Preflight Boundary

Before reviewing, running checks, or making fixes, run:

```bash
git status --porcelain
git merge-base <Base> HEAD
```

Treat `<merge-base>...HEAD` as the committed branch review scope.

By default, review and fix only committed branch changes in that scope. Staged,
unstaged, and untracked worktree changes are excluded unless the user explicitly
asks to include them.

If dirty worktree paths exist, list them and avoid touching unrelated dirty
paths. If a required fix would touch a dirty path that is not explicitly
included in the self-review, stop and ask before editing it.

## Base Workflow

Use the `mododev` skill as the quality baseline.

Review the changed code against the branch base as an enterprise production
pre-review branch audit. The goal is to find and fix relevant issues in the
current branch before external review.

## Review Scope

Probe changed code for:

- bugs and correctness gaps
- weak abstractions or incomplete foundational design
- security and safety risks
- inefficiencies
- hardcoded values
- brittle assumptions
- poor DX or UX
- integration risks

Assess typing rigorously. Typing must be strict. Avoid unstructured
dictionaries unless they are clearly the correct boundary representation, such
as JSON or provider payloads. Any dictionary use must be justified, typed, and
constrained.

Assess tests for behavior, edge cases, error paths, adversarial inputs, and
regression risks. Tests must not be shallow, happy-path only, or overly coupled
to implementation details.

## Sub-Agent Policy

Use dedicated subagents only when useful, with a maximum of two.

Review subagent findings critically. Discard findings that are out of scope or
belong to later plans. Act on every relevant finding, including minor ones.

## Review/Fix Loop

Work in a review/fix loop for at most four iterations.

A review iteration means:

1. Perform a real pre-review branch audit against the changed code.
2. Identify concrete issues.
3. Fix the root cause of each relevant issue.
4. Rerun affected checks.

Quality gates, formatting, linting, mypy, pytest, and other validation retries
do not count as review iterations.

Never weaken a test to make it pass.

Exit early only when the self-review and any used subagents find no remaining
relevant issues.

## Validation

After fixes, rerun appropriate formatting, linting, typing, and test gates.

Use focused checks for affected files first. Run broader checks when changes
touch shared behavior, packaging, docs, or cross-module contracts.

Do not paste long successful logs.

## Completion Report

Before declaring completion, summarize:

- review rounds performed
- issues found and fixes made
- validation commands and results
- residual risks
- explicitly deferred items
