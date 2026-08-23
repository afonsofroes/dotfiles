---
name: mododev
description: "Default skill for modolab implementation work: one module at a time, production-grade Google-style docs, adversarial tests, validation gates, and stop-for-review behavior."
---

# Modolab Module Development

Use this skill for implementation work in a modolab repository.

## Workflow

Develop one coherent module or submodule per iteration. Do not start the next
module until the current one is implemented, validated, summarized, and reviewed.

When all required checks are green, stop and ask for review before proceeding.

## Module Size

Python source files must be under 600 lines and should be under 500 lines.

This limit exists to enforce separation of concerns. Do not reduce docstrings,
examples, typing, or readability to satisfy the line limit. Split responsibilities
into smaller modules instead.

## Source Quality

Every source module must start with a module docstring explaining:

- what the module provides
- where it fits in the package
- important operational or design constraints

Use comprehensive Google-style docstrings for public classes, functions, and
methods. Include `Args`, `Returns`, `Raises`, and `Examples` when useful.

Examples should be Sphinx-compatible. Prefer reStructuredText directives for
multi-line examples:

```rst
.. code-block:: python

   result = function_under_test()
```

Avoid import-time global side effects unless explicitly required.

## Design Rules

Use production-grade Python:

- explicit types
- cohesive modules
- clear optional dependency boundaries
- dependency injection where useful
- standard-library compatibility for library code
- informative errors over silent fallback

Avoid:

- hidden global configuration
- broad exception swallowing
- junk-drawer utility modules
- weakening tests to make implementation pass
- adding Ruff, mypy, or pytest ignores instead of fixing root causes

## Testing Standard

Tests must be production-grade and enterprise-ready.

Include, as applicable:

- adversarial unit tests, not only happy paths
- smoke tests for imports and basic runtime viability
- integration tests when behavior crosses module boundaries
- regression tests for discovered bugs
- edge-case and boundary tests
- error-path tests with clear expected failures
- configuration and environment-variable tests
- serialization/deserialization tests
- concurrency or async tests
- security-sensitive tests
- observability tests for logs, traces, metrics, and diagnostic failures
- public contract/API compatibility tests
- executable documentation/doctest examples
- performance-sensitive tests when performance is part of the contract

If a test fails, do not weaken the test unless it is objectively wrong. Fix the
root cause.

## Validation

After implementing a module, run the narrowest relevant checks first:

```bash
uv run ruff format <source-path> <test-path>
uv run ruff check --fix <source-path> <test-path>
uv run mypy <source-path> <test-path>
uv run pytest <test-path>
```

If any command fails:

- fix the root cause
- rerun the command
- do not add ignores or exclusions unless there is a documented and justified
  exception

Run broader checks when the module touches shared behavior, docs, packaging, or
cross-module contracts:

```bash
just check
```

Use online checks only when needed:

```bash
just check-online
```

## Commit Preparation

When asked to prepare commits, split the work into reviewable, functional
commits instead of defaulting to one bulk commit.

Each commit should:

- be self-contained and leave the repository in a functional state
- be ordered so dependencies land before downstream changes
- group related source, tests, and documentation together when they prove the
  same behavior
- avoid large unrelated file bundles
- use a clear and informative multi-line message
- start with a conventional prefix such as `feat(...)`, `fix(...)`,
  `refactor(...)`, `docs(...)`, `test(...)`, or `chore(...)`

Use a quoted here-document for multi-line commit messages so formatting is
stable and shell interpolation cannot change the message:

```bash
git commit -F - <<'EOF'
feat(llm): add retry queue scheduling contract

Explain the behavior change, why it belongs in this commit, and any important
validation or compatibility notes.
EOF
```

## Completion Report

When the module is complete, summarize:

- what was implemented
- files changed
- validation commands run
- residual risks or review points

Then stop and ask for review.
